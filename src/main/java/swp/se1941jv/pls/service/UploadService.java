package swp.se1941jv.pls.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.UUID; 

import org.slf4j.Logger; 
import org.slf4j.LoggerFactory; 
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils; 
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
            return ""; 
        }

        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename()); 
        if (originalFilename.contains("..")) { 
            logger.error("Cannot store file with relative path outside current directory (Path Traversal attempt): {}", originalFilename);
            return ""; 
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
                if (!targetDir.mkdirs()) { 
                    logger.error("Failed to create directory: {}", targetDir.getAbsolutePath());
                    return ""; 
                }
                logger.info("Created directory: {}", targetDir.getAbsolutePath());
            }

        
            String fileExtension = "";
            int dotIndex = originalFilename.lastIndexOf('.');
            if (dotIndex > 0 && dotIndex < originalFilename.length() - 1) {
                fileExtension = originalFilename.substring(dotIndex);
            }
            if (!fileExtension.matches("\\.(?i)(jpg|jpeg|png|gif)$")) {
                 logger.warn("Invalid file extension uploaded: {} for original file: {}", fileExtension, originalFilename);
                 return ""; 
            }

            finalName = UUID.randomUUID().toString() + fileExtension; 
            File serverFile = new File(targetDir.getAbsolutePath() + File.separator + finalName);

            try (BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(serverFile))) {
                stream.write(bytes);
            }
            logger.info("File saved successfully: {}", serverFile.getAbsolutePath());

        } catch (IOException e) {
            logger.error("Error saving file {}: {}", originalFilename, e.getMessage(), e);
            return ""; 
        } catch (Exception e) { 
            logger.error("Unexpected error saving file {}: {}", originalFilename, e.getMessage(), e);
            return "";
        }
        return finalName; 
    }

    
    
    public boolean deleteUploadedFile(String fileName, String targetFolder) {
        if (fileName == null || fileName.isEmpty() || targetFolder == null || targetFolder.isEmpty()) {
            logger.warn("File name or target folder is empty for deletion. FileName: {}, TargetFolder: {}", fileName, targetFolder);
            return false; 
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
                return true;
            }
        } catch (SecurityException se) {
            logger.error("Security error deleting file {} in folder {}: {}", fileName, targetFolder, se.getMessage(), se);
            return false;
        }
         catch (Exception e) {
            logger.error("Error deleting file {} in folder {}: {}", fileName, targetFolder, e.getMessage(), e);
            return false;
        }
    }
}