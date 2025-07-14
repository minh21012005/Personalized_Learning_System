package swp.se1941jv.pls.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import swp.se1941jv.pls.dto.response.lesson.LessonFormDTO;

import jakarta.servlet.ServletContext;

@Service
public class FileUploadService {

    private static final Logger logger = LoggerFactory.getLogger(FileUploadService.class);
    private final ServletContext servletContext;

    public FileUploadService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    private LessonFormDTO.LessonMaterialDTO handleSaveUploadFile(MultipartFile file, String targetFolder) {
        if (file == null || file.isEmpty()) {
            logger.warn("Attempted to save an empty or null file for target folder: {}", targetFolder);
            return null;
        }

        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
        if (originalFilename.contains("..")) {
            logger.error("Cannot store file with relative path outside current directory (Path Traversal attempt): {}", originalFilename);
            return null;
        }

        LessonFormDTO.LessonMaterialDTO material = new LessonFormDTO.LessonMaterialDTO();
        try {
            byte[] bytes = file.getBytes();

            String rootResourcesPath = this.servletContext.getRealPath("/resources/files");
            if (rootResourcesPath == null) {
                logger.error("Could not get real path for /resources/files. Ensure webapp structure is correct.");
                return null;
            }

            File targetDir = new File(rootResourcesPath + File.separator + targetFolder);
            if (!targetDir.exists()) {
                if (!targetDir.mkdirs()) {
                    logger.error("Failed to create directory: {}", targetDir.getAbsolutePath());
                    return null;
                }
                logger.info("Created directory: {}", targetDir.getAbsolutePath());
            }

            String fileExtension = "";
            int dotIndex = originalFilename.lastIndexOf('.');
            if (dotIndex > 0 && dotIndex < originalFilename.length() - 1) {
                fileExtension = originalFilename.substring(dotIndex);
            }
            if (!fileExtension.matches("\\.(?i)(pdf|doc|docx)$")) {
                logger.warn("Invalid file extension uploaded: {} for original file: {}", fileExtension, originalFilename);
                return null;
            }

            String fileNameWithTimestamp = System.currentTimeMillis() + "-" + originalFilename;
            File serverFile = new File(targetDir.getAbsolutePath() + File.separator + fileNameWithTimestamp);

            try (BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(serverFile))) {
                stream.write(bytes);
            }
            logger.info("File saved successfully: {}", serverFile.getAbsolutePath());

            material.setFilePath(fileNameWithTimestamp);
            material.setFileName(originalFilename);
            return material;
        } catch (IOException e) {
            logger.error("Error saving file {}: {}", originalFilename, e.getMessage(), e);
            return null;
        } catch (Exception e) {
            logger.error("Unexpected error saving file {}: {}", originalFilename, e.getMessage(), e);
            return null;
        }
    }

    public List<LessonFormDTO.LessonMaterialDTO> handleSaveUploadFiles(MultipartFile[] files, String targetFolder) {
        List<LessonFormDTO.LessonMaterialDTO> savedMaterials = new ArrayList<>();
        if (files == null || files.length == 0) {
            logger.warn("No files provided for upload to target folder: {}", targetFolder);
            return savedMaterials;
        }

        for (MultipartFile file : files) {
            LessonFormDTO.LessonMaterialDTO material = handleSaveUploadFile(file, targetFolder);
            if (material != null) {
                savedMaterials.add(material);
            }
        }

        logger.info("Successfully saved {} out of {} files to folder: {}", savedMaterials.size(), files.length, targetFolder);
        return savedMaterials;
    }

    public boolean deleteUploadedFile(String fileName, String targetFolder) {
        if (fileName == null || fileName.isEmpty() || targetFolder == null || targetFolder.isEmpty()) {
            logger.warn("File name or target folder is empty for deletion. FileName: {}, TargetFolder: {}", fileName, targetFolder);
            return false;
        }
        try {
            String rootResourcesPath = this.servletContext.getRealPath("/resources/files");
            if (rootResourcesPath == null) {
                logger.error("Could not get real path for /resources/files during delete. FileName: {}, TargetFolder: {}", fileName, targetFolder);
                return false;
            }
            File fileToDelete = new File(rootResourcesPath + File.separator + targetFolder + File.separator + fileName);

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
        } catch (Exception e) {
            logger.error("Error deleting file {} in folder {}: {}", fileName, targetFolder, e.getMessage(), e);
            return false;
        }
    }

    public boolean deleteUploadedFiles(List<String> fileNames, String targetFolder) {
        if (fileNames == null || fileNames.isEmpty() || targetFolder == null || targetFolder.isEmpty()) {
            logger.warn("File names list or target folder is empty for deletion. FileNames: {}, TargetFolder: {}", fileNames, targetFolder);
            return false;
        }

        boolean allDeleted = true;
        for (String fileName : fileNames) {
            if (!deleteUploadedFile(fileName, targetFolder)) {
                allDeleted = false;
            }
        }

        if (allDeleted) {
            logger.info("Successfully deleted all {} files from folder: {}", fileNames.size(), targetFolder);
        } else {
            logger.warn("Some files could not be deleted from folder: {}", targetFolder);
        }
        return allDeleted;
    }
}
