package swp.se1941jv.pls.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.UUID; // Import UUID

import org.slf4j.Logger; // Sử dụng SLF4J Logger
import org.slf4j.LoggerFactory; // Sử dụng SLF4J Logger
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils; // Import StringUtils
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;

@Service
public class UploadService {

    private static final Logger logger = LoggerFactory.getLogger(UploadService.class);
    private final ServletContext servletContext;

    public UploadService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    public String handleSaveUploadFile(MultipartFile file, String targetFolder) {
        if (file == null || file.isEmpty()) {
            logger.warn("Attempted to save an empty or null file for target folder: {}", targetFolder);
            return ""; // Trả về rỗng nếu file trống
        }

        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename()); // Làm sạch tên file gốc
        if (originalFilename.contains("..")) { // Kiểm tra path traversal cơ bản
            logger.error("Cannot store file with relative path outside current directory (Path Traversal attempt): {}", originalFilename);
            return ""; // Hoặc ném một exception tùy chỉnh
        }

        String finalName = "";
        try {
            byte[] bytes = file.getBytes();

            String rootResourcesImgPath = this.servletContext.getRealPath("/resources/img");
            if (rootResourcesImgPath == null) {
                logger.error("Could not get real path for /resources/img. Ensure webapp structure is correct and server is configured for getRealPath.");
                return "";
            }

            File targetDir = new File(rootResourcesImgPath + File.separator + targetFolder);
            if (!targetDir.exists()) {
                if (!targetDir.mkdirs()) { // Cố gắng tạo thư mục (bao gồm cả thư mục cha nếu cần)
                    logger.error("Failed to create directory: {}", targetDir.getAbsolutePath());
                    return ""; // Không thể tạo thư mục
                }
                logger.info("Created directory: {}", targetDir.getAbsolutePath());
            }

            // Tạo tên file duy nhất hơn bằng UUID và giữ lại đuôi file gốc
            String fileExtension = "";
            int dotIndex = originalFilename.lastIndexOf('.');
            if (dotIndex > 0 && dotIndex < originalFilename.length() - 1) {
                fileExtension = originalFilename.substring(dotIndex);
            }
            // Basic image extension validation (bạn có thể làm chặt chẽ hơn)
            if (!fileExtension.matches("\\.(?i)(jpg|jpeg|png|gif)$")) {
                 logger.warn("Invalid file extension uploaded: {} for original file: {}", fileExtension, originalFilename);
                 // Bạn có thể trả về "" hoặc ném một exception ở đây nếu muốn thông báo lỗi rõ ràng hơn cho người dùng
                 // throw new IllegalArgumentException("Invalid file type. Only JPG, JPEG, PNG, GIF are allowed.");
                 return ""; // Tạm thời trả về rỗng
            }

            finalName = UUID.randomUUID().toString() + fileExtension; // Sử dụng UUID
            File serverFile = new File(targetDir.getAbsolutePath() + File.separator + finalName);

            try (BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(serverFile))) {
                stream.write(bytes);
            }
            logger.info("File saved successfully: {}", serverFile.getAbsolutePath());

        } catch (IOException e) {
            logger.error("Error saving file {}: {}", originalFilename, e.getMessage(), e);
            return ""; // Trả về chuỗi rỗng nếu có lỗi
        } catch (Exception e) { // Bắt các lỗi không mong muốn khác
            logger.error("Unexpected error saving file {}: {}", originalFilename, e.getMessage(), e);
            return "";
        }
        return finalName; // Trả về tên file đã lưu (không bao gồm đường dẫn)
    }

    /**
     * Xóa file đã upload khỏi thư mục con được chỉ định bên trong /resources/img/.
     *
     * @param fileName Tên file cần xóa (ví dụ: "abc.jpg").
     * @param targetFolder Thư mục con chứa file (ví dụ: "subjects", "avatars").
     * @return true nếu xóa thành công hoặc file không tồn tại, false nếu xóa thất bại.
     */
    public boolean deleteUploadedFile(String fileName, String targetFolder) {
        if (fileName == null || fileName.isEmpty() || targetFolder == null || targetFolder.isEmpty()) {
            logger.warn("File name or target folder is empty for deletion. FileName: {}, TargetFolder: {}", fileName, targetFolder);
            return false; // Không thể xóa nếu thiếu thông tin
        }
        try {
            String rootResourcesImgPath = this.servletContext.getRealPath("/resources/img");
            if (rootResourcesImgPath == null) {
                logger.error("Could not get real path for /resources/img during delete. FileName: {}, TargetFolder: {}", fileName, targetFolder);
                return false;
            }
            File fileToDelete = new File(rootResourcesImgPath + File.separator + targetFolder + File.separator + fileName);

            if (fileToDelete.exists()) {
                if (fileToDelete.delete()) {
                    logger.info("File deleted successfully: {}", fileToDelete.getAbsolutePath());
                    return true;
                } else {
                    logger.error("Failed to delete file: {}", fileToDelete.getAbsolutePath());
                    return false;
                }
            } else {
                logger.info("File to delete not found (considered success for cleanup): {}", fileToDelete.getAbsolutePath());
                return true; // Nếu file không tồn tại, coi như đã xóa thành công (không có gì để làm)
            }
        } catch (SecurityException se) {
            logger.error("Security error deleting file {} in folder {}: {}", fileName, targetFolder, se.getMessage(), se);
            return false;
        }
         catch (Exception e) { // Bắt các lỗi chung khác
            logger.error("Error deleting file {} in folder {}: {}", fileName, targetFolder, e.getMessage(), e);
            return false;
        }
    }
}