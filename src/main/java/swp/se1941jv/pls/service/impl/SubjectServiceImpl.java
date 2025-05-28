package swp.se1941jv.pls.service.impl; // Sửa tên package thành chữ thường

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value; // Cần để đọc đường dẫn upload
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils; // Tiện ích xử lý chuỗi
import org.springframework.web.multipart.MultipartFile;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.service.SubjectService;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class SubjectServiceImpl implements SubjectService { // Sửa tên class

    private final SubjectRepository subjectRepository;

    // Lấy đường dẫn thư mục upload từ application.yaml
    // Ví dụ: file.upload-dir=uploads/subjects
    @Value("${file.upload-dir:./uploads/subjects}") // Thêm giá trị mặc định nếu không có trong properties
    private String uploadDir;

    // @Autowired // Có thể bỏ @Autowired ở đây nếu chỉ có 1 constructor
    public SubjectServiceImpl(SubjectRepository subjectRepository) {
        this.subjectRepository = subjectRepository;
    }

    @Override
    public List<Subject> getAllSubjects() {
        return subjectRepository.findAll();
    }

    @Override
    public Optional<Subject> getSubjectById(Long id) {
        return subjectRepository.findById(id);
    }

    @Override
    public Subject saveSubject(Subject subject, MultipartFile imageFile) throws IOException {
        String originalFileName = null;
        String uniqueFileName = null;

        // 1. Xử lý upload ảnh nếu có file mới được cung cấp và file không rỗng
        if (imageFile != null && !imageFile.isEmpty()) {
            originalFileName = StringUtils.cleanPath(imageFile.getOriginalFilename()); // Làm sạch tên file

            // Tạo tên file duy nhất để tránh trùng lặp
            String fileExtension = "";
            if (originalFileName != null && originalFileName.contains(".")) {
                fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }
            uniqueFileName = UUID.randomUUID().toString() + fileExtension;

            // Tạo thư mục upload nếu chưa tồn tại
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath); // Tạo cả các thư mục cha nếu cần
            }

            // Xóa ảnh cũ nếu đây là thao tác cập nhật và có ảnh mới
            // và subject đã có ảnh cũ
            if (subject.getSubjectId() != null && subject.getSubjectImage() != null && !subject.getSubjectImage().isEmpty()) {
                // Lấy subject hiện tại từ DB để chắc chắn thông tin ảnh là mới nhất
                // (Mặc dù subject được truyền vào đã có subjectImage, nhưng để an toàn hơn)
                Optional<Subject> existingSubjectOpt = subjectRepository.findById(subject.getSubjectId());
                if (existingSubjectOpt.isPresent() && existingSubjectOpt.get().getSubjectImage() != null) {
                    Path oldImagePath = Paths.get(uploadDir).resolve(existingSubjectOpt.get().getSubjectImage());
                    try {
                        Files.deleteIfExists(oldImagePath);
                    } catch (IOException e) {
                        // Log lỗi hoặc xử lý tùy ý, không nên để việc xóa ảnh cũ làm hỏng cả quá trình lưu
                        System.err.println("Could not delete old image: " + oldImagePath + " - " + e.getMessage());
                    }
                }
            }

            // Lưu file mới
            try (InputStream inputStream = imageFile.getInputStream()) {
                Path filePath = uploadPath.resolve(uniqueFileName);
                Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
                subject.setSubjectImage(uniqueFileName); // Cập nhật tên file ảnh mới vào entity
            } catch (IOException ioe) {
                throw new IOException("Could not save image file: " + originalFileName, ioe);
            }
        } else {
            // Nếu không có file mới được upload khi cập nhật, giữ lại ảnh cũ
            if (subject.getSubjectId() != null) { // Đây là trường hợp update
                // Lấy lại thông tin subject hiện tại từ DB để không ghi đè mất ảnh cũ
                // nếu subjectImage trong đối tượng subject truyền vào là null (do form không gửi)
                Optional<Subject> existingSubjectOpt = subjectRepository.findById(subject.getSubjectId());
                if (existingSubjectOpt.isPresent()) {
                    subject.setSubjectImage(existingSubjectOpt.get().getSubjectImage());
                } else {
                    // Trường hợp edit subject không tồn tại, nên throw lỗi hoặc xử lý
                    // Tuy nhiên, controller nên kiểm tra subject tồn tại trước khi gọi save
                    // Ở đây, nếu subject không tồn tại, save sẽ thành create mới, nên không set image cũ
                }
            }
            // Nếu là tạo mới (subject.getSubjectId() == null) và không có file ảnh,
            // thì subject.getSubjectImage() sẽ là null (mặc định hoặc do chưa set)
        }


        // 2. Logic xử lý trường isActive (nếu cần)
        // Trường `isActive` của bạn là boolean, nó sẽ được bind từ form (checkbox).
        // Nếu checkbox không được tick, giá trị sẽ là false. Nếu được tick, là true.
        // Không cần logic đặc biệt ở đây trừ khi bạn có yêu cầu cụ thể.
        // Ví dụ, nếu bạn muốn `isActive` mặc định là `true` khi tạo mới và form không có checkbox:
        // if (subject.getSubjectId() == null) {
        //     subject.setActive(true); // Giả sử Subject có phương thức setActive
        // }

        // 3. Lưu entity Subject vào database
        return subjectRepository.save(subject);
    }

    @Override
    public void deleteSubjectById(Long id) {
        // Trước khi xóa subject, nên xóa file ảnh liên quan (nếu có)
        Optional<Subject> subjectOptional = subjectRepository.findById(id);
        if (subjectOptional.isPresent()) {
            Subject subjectToDelete = subjectOptional.get();
            String imageName = subjectToDelete.getSubjectImage();
            if (imageName != null && !imageName.isEmpty()) {
                Path imagePath = Paths.get(uploadDir).resolve(imageName);
                try {
                    Files.deleteIfExists(imagePath);
                } catch (IOException e) {
                    // Log lỗi hoặc xử lý tùy ý
                    System.err.println("Error deleting image file: " + imagePath + " - " + e.getMessage());
                }
            }
            subjectRepository.deleteById(id);
        } else {
            // Xử lý trường hợp subject không tồn tại, ví dụ throw exception
            
        }
    }
}