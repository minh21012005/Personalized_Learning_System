package swp.se1941jv.pls.service.impl;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
// Các import sau đây có thể vẫn cần thiết cho các logic khác không liên quan đến file
// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.util.StringUtils;
// import org.springframework.web.multipart.MultipartFile; // Chắc chắn bỏ vì saveSubject không còn tham số này
// import java.io.IOException; // Bỏ nếu saveSubject không còn throws IOException
// import java.io.InputStream;
// import java.nio.file.Files;
// import java.nio.file.Path;
// import java.nio.file.Paths;
// import java.nio.file.StandardCopyOption;
// import java.util.UUID;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.service.SubjectService;

import java.util.Optional; // Giữ lại vì getSubjectById dùng

@Service
public class SubjectServiceImpl implements SubjectService {

    private final SubjectRepository subjectRepository;

    // Bỏ @Value("${file.upload-dir:./uploads/subjects}") private String uploadDir;
    // vì service này không trực tiếp quản lý đường dẫn upload file nữa.

    public SubjectServiceImpl(SubjectRepository subjectRepository) {
        this.subjectRepository = subjectRepository;
    }

    @Override
    public Page<Subject> getAllSubjects(String filterName, Long filterGradeId, Pageable pageable) {
        String searchName = (filterName != null && filterName.trim().isEmpty()) ? null : filterName;
        return subjectRepository.findByFilter(searchName, filterGradeId, pageable);
    }

    @Override
    public Optional<Subject> getSubjectById(Long id) {
        return subjectRepository.findById(id);
    }

    @Override
    // Signature của phương thức đã thay đổi: không còn MultipartFile imageFile, không còn throws IOException
    public Subject saveSubject(Subject subject) {
        // TOÀN BỘ LOGIC XỬ LÝ UPLOAD/DELETE FILE ẢNH TRONG PHƯƠNG THỨC NÀY TRƯỚC ĐÂY SẼ ĐƯỢC XÓA BỎ.
        // SubjectController sẽ gọi UploadService để xử lý file trước,
        // sau đó gán tên file đã lưu vào subject.setSubjectImage(),
        // rồi mới gọi phương thức saveSubject này.
        // Phương thức này giờ chỉ đơn thuần lưu đối tượng Subject đã được chuẩn bị sẵn.

        // Ví dụ:
        // Dòng này: subject.setSubjectImage(uniqueFileName); // Sẽ do Controller làm
        // Dòng này: Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING); // Sẽ do UploadService làm
        // Dòng này: Files.deleteIfExists(oldImagePath); // Sẽ do Controller gọi UploadService.deleteUploadedFile

        return subjectRepository.save(subject);
    }

    @Override
    public void deleteSubjectById(Long id) {
        // LOGIC XÓA FILE ẢNH VẬT LÝ SẼ ĐƯỢC XỬ LÝ TRONG SubjectController
        // TRƯỚC KHI GỌI PHƯƠNG THỨC NÀY.
        // Phương thức này chỉ xóa bản ghi Subject khỏi database.

        // Ví dụ:
        // Dòng này: Path imagePath = Paths.get(uploadDir).resolve(imageName); // Sẽ do Controller làm
        // Dòng này: Files.deleteIfExists(imagePath); // Sẽ do Controller gọi UploadService.deleteUploadedFile

        subjectRepository.deleteById(id);
    }
}