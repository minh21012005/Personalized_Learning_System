package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.lesson.LessonFormDTO;
import swp.se1941jv.pls.dto.response.lesson.LessonListDTO;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.*;
import swp.se1941jv.pls.service.specification.LessonSpecifications;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class LessonService {
    private final FileUploadService fileUploadService;
    private final LessonRepository lessonRepository;
    private final ChapterRepository chapterRepository;
    private final LessonMaterialRepository lessonMaterialRepository;
    private final SubjectAssignmentRepository subjectAssignmentRepository;
    private final SubjectStatusHistoryRepository statusHistoryRepository;
    private final UserService userService;
    private final ObjectMapper objectMapper;
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private final TestStaffService testStaffService;
    private final TestRepository testRepository;

    @Transactional
    public void createLesson(LessonFormDTO dto, Long userId) {
        validateStaffAccess(dto.getChapterId(), userId);
        if (lessonRepository.existsByLessonNameAndChapter_ChapterId(dto.getLessonName(), dto.getChapterId())) {
            throw new IllegalArgumentException("Tên bài học đã tồn tại trong chương này!");
        }

        Lesson lesson = toLessonEntity(dto);
        lesson.setStatus(false); // Mặc định là FALSE theo yêu cầu
        lesson.setUserCreated(userId);
        lesson.setIsHidden(false);
        lesson.setCreatedAt(LocalDateTime.now());
        lesson = lessonRepository.save(lesson);

        if (dto.getLessonMaterials() != null && !dto.getLessonMaterials().isEmpty()) {
            saveLessonMaterials(lesson, dto.getLessonMaterials());
        }

        // Kiểm tra và cập nhật trạng thái subject nếu là REJECTED
        updateSubjectStatusIfRejected(dto.getChapterId());
    }

    @Transactional
    public void updateLesson(LessonFormDTO dto, Long userId, MultipartFile[] materialFiles) {
        validateStaffAccess(dto.getChapterId(), userId);
        Lesson lesson = lessonRepository.findById(dto.getLessonId())
                .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại!"));

        // Kiểm tra trùng tên với lesson khác
        if (!dto.getLessonName().equals(lesson.getLessonName()) &&
                lessonRepository.existsByLessonNameAndChapter_ChapterIdAndLessonIdNot(dto.getLessonName(), dto.getChapterId(), dto.getLessonId())) {
            throw new IllegalArgumentException("Tên bài học đã tồn tại trong chương này!");
        }

        // 1. Lấy list cũ
        List<LessonMaterial> oldMaterials = new ArrayList<>(lesson.getLessonMaterials());

        // 2. Danh sách filePath giữ lại
        List<String> keepPaths = Optional.ofNullable(dto.getLessonMaterials())
                .orElse(Collections.emptyList())
                .stream()
                .map(LessonFormDTO.LessonMaterialDTO::getFilePath)
                .collect(Collectors.toList());

        // 3. Xóa những file không được giữ
        List<String> toDelete = oldMaterials.stream()
                .map(LessonMaterial::getFilePath)
                .filter(path -> !keepPaths.contains(path))
                .collect(Collectors.toList());
        if (!toDelete.isEmpty()) {
            fileUploadService.deleteUploadedFiles(toDelete, "materials");
            lessonMaterialRepository.deleteAll(oldMaterials.stream()
                    .filter(m -> toDelete.contains(m.getFilePath()))
                    .collect(Collectors.toList()));
        }

        // 4. Chuẩn bị list mới
        List<LessonMaterial> updatedMaterials = oldMaterials.stream()
                .filter(m -> keepPaths.contains(m.getFilePath()))
                .collect(Collectors.toList());

        // 5. Upload file mới
        if (materialFiles != null && materialFiles.length > 0) {
            List<LessonFormDTO.LessonMaterialDTO> newDtos = fileUploadService.handleSaveUploadFiles(materialFiles, "materials");
            Set<String> existingNames = updatedMaterials.stream().map(LessonMaterial::getFileName).collect(Collectors.toSet());
            for (LessonFormDTO.LessonMaterialDTO mdto : newDtos) {
                if (existingNames.contains(mdto.getFileName())) {
                    throw new IllegalArgumentException("Tài liệu trùng tên: " + mdto.getFileName());
                }
                LessonMaterial m = LessonMaterial.builder()
                        .fileName(mdto.getFileName())
                        .filePath(mdto.getFilePath())
                        .lesson(lesson)
                        .build();
                lessonMaterialRepository.save(m);
                updatedMaterials.add(m);
            }
        }

        // 6. Gán lại
        lesson.getLessonMaterials().clear();
        lesson.getLessonMaterials().addAll(updatedMaterials);

        // 7. Cập nhật các field khác
        lesson.setLessonName(dto.getLessonName());
        lesson.setLessonDescription(dto.getLessonDescription());
        lesson.setVideoSrc(dto.getVideoSrc());
        lesson.setVideoTime(dto.getVideoTime());
        lesson.setVideoTitle(dto.getVideoTitle());
        lesson.setThumbnailUrl(dto.getThumbnailUrl());
        lesson.setUpdatedAt(LocalDateTime.now());

        lessonRepository.save(lesson);

        // Kiểm tra và cập nhật trạng thái subject nếu là REJECTED
        updateSubjectStatusIfRejected(dto.getChapterId());
    }

    @Transactional
    public void deleteLesson(Long lessonId, Long userId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại!"));
        validateStaffAccess(lesson.getChapter().getChapterId(), userId);

        // Kiểm tra và cập nhật trạng thái subject nếu là REJECTED
        updateSubjectStatusIfRejected(lesson.getChapter().getChapterId());

        // Delete associated test if exists
        if (lesson.getTest() != null) {
            testRepository.deleteById(lesson.getTest().getTestId());
        }

        // Delete associated lesson materials
        List<String> filePaths = lesson.getLessonMaterials().stream()
                .map(LessonMaterial::getFilePath)
                .collect(Collectors.toList());
        if (!filePaths.isEmpty()) {
            fileUploadService.deleteUploadedFiles(filePaths, "materials");
        }

        lessonRepository.deleteById(lessonId);
    }

    public Page<LessonListDTO> findLessonsByChapterId(Long chapterId, String lessonName, Boolean status, Long userId, Pageable pageable) {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new IllegalArgumentException("Chương không tồn tại!"));
        Long subjectId = chapter.getSubject().getSubjectId();
        Optional<SubjectAssignment> assignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        if (assignment.isEmpty() || !assignment.get().getUser().getUserId().equals(userId)) {
            throw new IllegalArgumentException("Chỉ có STAFF được giao môn học này mới có thể thao tác!");
        }
        Specification<Lesson> spec = Specification.where(LessonSpecifications.hasChapterId(chapterId));
        if (lessonName != null && !lessonName.trim().isEmpty()) {
            spec = spec.and(LessonSpecifications.hasName(lessonName));
        }
        if (status != null) {
            spec = spec.and(LessonSpecifications.hasStatus(status));
        }

        return lessonRepository.findAll(spec, pageable).map(this::toLessonListDTO);
    }

    public Optional<Lesson> getLessonById(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new IllegalArgumentException("ID bài học không hợp lệ!");
        }
        return lessonRepository.findById(lessonId);
    }

    @Transactional
    public void toggleLessonHiddenStatus(Long lessonId, Long userId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại!"));
        validateStaffAccess(lesson.getChapter().getChapterId(), userId);


        lesson.setIsHidden(!lesson.getIsHidden());
        if (Boolean.TRUE.equals(lesson.getIsHidden())) {
            lesson.setStatus(false);
        }
        lesson.setUpdatedAt(LocalDateTime.now());
        lessonRepository.save(lesson);

        updateSubjectStatusIfRejected(lesson.getChapter().getChapterId());
    }

    private Lesson toLessonEntity(LessonFormDTO dto) {
        Chapter chapter = chapterRepository.findById(dto.getChapterId())
                .orElseThrow(() -> new IllegalArgumentException("chapter.message.notFound"));
        return Lesson.builder()
                .lessonId(dto.getLessonId())
                .lessonName(dto.getLessonName())
                .lessonDescription(dto.getLessonDescription())
                .videoSrc(dto.getVideoSrc())
                .videoTime(dto.getVideoTime())
                .videoTitle(dto.getVideoTitle())
                .thumbnailUrl(dto.getThumbnailUrl())
                .chapter(chapter)
                .build();
    }

    public LessonListDTO toLessonListDTO(Lesson lesson) {
        return LessonListDTO.builder()
                .lessonId(lesson.getLessonId())
                .lessonName(lesson.getLessonName())
                .lessonDescription(lesson.getLessonDescription())
                .videoSrc(lesson.getVideoSrc())
                .videoTime(lesson.getVideoTime())
                .videoTitle(lesson.getVideoTitle())
                .thumbnailUrl(lesson.getThumbnailUrl())
                .status(lesson.getStatus())
                .isHidden(lesson.getIsHidden())
                .lessonMaterials(lesson.getLessonMaterials().stream()
                        .map(material -> LessonListDTO.LessonMaterialDTO.builder()
                                .fileName(material.getFileName())
                                .filePath(material.getFilePath())
                                .build())
                        .collect(Collectors.toList()))
                .chapterId(lesson.getChapter().getChapterId())
                .chapterName(lesson.getChapter().getChapterName())
                .userFullName(lesson.getUserCreated() != null ? userService.getUserFullName(lesson.getUserCreated()) : "Không có thông tin")
                .createdAt(lesson.getCreatedAt() != null ? lesson.getCreatedAt().format(formatter) : null)
                .build();
    }

    private void saveLessonMaterials(Lesson lesson, List<LessonFormDTO.LessonMaterialDTO> lessonMaterialDTOs) {
        if (lessonMaterialDTOs != null) {
            lessonMaterialDTOs.forEach(materialDTO -> {
                LessonMaterial material = LessonMaterial.builder()
                        .fileName(materialDTO.getFileName())
                        .filePath(materialDTO.getFilePath())
                        .lesson(lesson)
                        .build();
                lessonMaterialRepository.save(material);
            });
        }
    }

    public void validateStaffAccess(Long chapterId, Long userId) {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new IllegalArgumentException("Chương không tồn tại!"));
        Long subjectId = chapter.getSubject().getSubjectId();
        Optional<SubjectAssignment> assignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        if (assignment.isEmpty() || !assignment.get().getUser().getUserId().equals(userId)) {
            throw new IllegalArgumentException("Chỉ có STAFF được giao môn học này mới có thể thao tác!");
        }
        Optional<SubjectStatusHistory> status = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (status.isEmpty() || (status.get().getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT && status.get().getStatus() != SubjectStatusHistory.SubjectStatus.REJECTED)) {
            throw new IllegalArgumentException("Chỉ có thể thao tác trên môn học ở trạng thái DRAFT hoặc REJECTED!");
        }
    }

    private void updateSubjectStatusIfRejected(Long chapterId) {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new IllegalArgumentException("Chương không tồn tại!"));
        Long subjectId = chapter.getSubject().getSubjectId();
        Optional<SubjectStatusHistory> status = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (status.isPresent() && status.get().getStatus() == SubjectStatusHistory.SubjectStatus.REJECTED) {
            SubjectStatusHistory updatedStatus = status.get();
            updatedStatus.setStatus(SubjectStatusHistory.SubjectStatus.DRAFT);
            statusHistoryRepository.save(updatedStatus);
        }
    }
}