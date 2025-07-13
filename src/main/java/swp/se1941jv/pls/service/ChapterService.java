package swp.se1941jv.pls.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.chapter.ChapterFormDTO;
import swp.se1941jv.pls.dto.response.chapter.ChapterListDTO;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.SubjectAssignment;
import swp.se1941jv.pls.entity.SubjectStatusHistory;
import swp.se1941jv.pls.repository.ChapterRepository;
import swp.se1941jv.pls.repository.SubjectAssignmentRepository;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.repository.SubjectStatusHistoryRepository;
import swp.se1941jv.pls.service.specification.ChapterSpecifications;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChapterService {

    private final ChapterRepository chapterRepository;
    private final SubjectRepository subjectRepository;
    private final SubjectAssignmentRepository subjectAssignmentRepository;
    private final SubjectStatusHistoryRepository statusHistoryRepository;
    private final UserService userService;
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");

    /**
     * Tạo chương mới từ entity.
     */
    @Transactional
    public void createChapter(ChapterFormDTO dto, Long userId) {
        validateStaffAccess(dto.getSubjectId(), userId);
        if (chapterRepository.existsByChapterNameAndSubject_SubjectId(dto.getChapterName(), dto.getSubjectId())) {
            throw new IllegalArgumentException("chapter.name.exists");
        }

        Chapter chapter = toChapterEntity(dto);
        chapter.setStatus(false);
        chapter.setUserCreated(userId);
        chapter.setCreatedAt(LocalDateTime.now());
        chapterRepository.save(chapter);

    }

    @Transactional
    public void updateChapter(ChapterFormDTO dto, Long userId) {
        validateStaffAccess(dto.getSubjectId(), userId);
        Chapter chapter = chapterRepository.findById(dto.getChapterId())
                .orElseThrow(() -> new IllegalArgumentException("chapter.message.notFound"));

        if (!chapter.getSubject().getSubjectId().equals(dto.getSubjectId())) {
            throw new IllegalArgumentException("chapter.message.invalidSubject");
        }
        if (!chapter.getChapterName().equals(dto.getChapterName()) &&
                chapterRepository.existsByChapterNameAndSubject_SubjectId(dto.getChapterName(), dto.getSubjectId())) {
            throw new IllegalArgumentException("chapter.name.exists");
        }

        chapter.setChapterName(dto.getChapterName());
        chapter.setChapterDescription(dto.getChapterDescription());
        chapter.setUpdatedAt(LocalDateTime.now());
        chapterRepository.save(chapter);
    }

    @Transactional
    public void deleteChapter(Long chapterId, Long userId) {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new IllegalArgumentException("chapter.message.notFound"));
        validateStaffAccess(chapter.getSubject().getSubjectId(), userId);
        chapterRepository.deleteById(chapterId);
    }

//    /**
//     * Phê duyệt chương.
//     */
//    @Transactional
//    public void approveChapter(Long chapterId) {
//        if (chapterId == null || chapterId <= 0) {
//            throw new IllegalArgumentException("ID chương không hợp lệ.");
//        }
//        Chapter chapter = chapterRepository.findById(chapterId)
//                .orElseThrow(() -> new IllegalArgumentException("Chương không tồn tại."));
//        if (chapter.getChapterStatus() != Chapter.ChapterStatus.PENDING) {
//            throw new IllegalArgumentException("Chương không ở trạng thái PENDING.");
//        }
//        try {
//            chapter.setChapterStatus(Chapter.ChapterStatus.APPROVED);
//            chapterRepository.save(chapter);
//        } catch (Exception e) {
//            throw new RuntimeException("Lỗi khi phê duyệt chương.", e);
//        }
//    }

//    /**
//     * Từ chối chương.
//     */
//    @Transactional
//    public void rejectChapter(Long chapterId) {
//        if (chapterId == null || chapterId <= 0) {
//            throw new IllegalArgumentException("ID chương không hợp lệ.");
//        }
//        Chapter chapter = chapterRepository.findById(chapterId)
//                .orElseThrow(() -> new IllegalArgumentException("Chương không tồn tại."));
//        if (chapter.getChapterStatus() != Chapter.ChapterStatus.PENDING) {
//            throw new IllegalArgumentException("Chương không ở trạng thái PENDING.");
//        }
//        try {
//            chapter.setChapterStatus(Chapter.ChapterStatus.REJECTED);
//            chapterRepository.save(chapter);
//        } catch (Exception e) {
//            throw new RuntimeException("Lỗi khi từ chối chương.", e);
//        }
//    }

//    /**
//     * Lấy danh sách chương theo chapterStatus với phân trang và lọc.
//     */
//    public Page<ChapterResponseDTO> findChaptersByChapterStatus(
//            Long subjectId,
//            String chapterStatus,
//            Boolean status,
//            LocalDateTime startDate,
//            LocalDateTime endDate,
//            Long userCreated,
//            int page,
//            int size) {
//        if (page < 0 || size <= 0) {
//            throw new IllegalArgumentException("Thông số phân trang không hợp lệ.");
//        }
//
//        Specification<Chapter> spec = Specification.where(null);
//        if (subjectId != null) {
//            spec = spec.and(ChapterSpecifications.hasSubjectId(subjectId));
//        }
//        if (chapterStatus != null && !chapterStatus.trim().isEmpty()) {
//            spec = spec.and(ChapterSpecifications.hasChapterStatus(chapterStatus));
//        } else {
//            spec = spec.and((root, query, cb) -> cb.in(root.get("chapterStatus"))
//                    .value(Chapter.ChapterStatus.PENDING)
//                    .value(Chapter.ChapterStatus.APPROVED)
//                    .value(Chapter.ChapterStatus.REJECTED));
//        }
//        if (status != null) {
//            spec = spec.and(ChapterSpecifications.hasStatus(status));
//        }
//        if (startDate != null || endDate != null) {
//            spec = spec.and(ChapterSpecifications.hasUpdatedAtBetween(startDate, endDate));
//        }
//        if (userCreated != null) {
//            spec = spec.and(ChapterSpecifications.hasUserCreated(userCreated));
//        }
//
//        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "updatedAt"));
//        Page<Chapter> chapters = chapterRepository.findAll(spec, pageable);
//
//        return chapters.map(chapter -> ChapterResponseDTO.builder()
//                .chapterId(chapter.getChapterId())
//                .chapterName(chapter.getChapterName())
//                .chapterDescription(chapter.getChapterDescription())
//                .status(chapter.getStatus())
//                .chapterStatus(ChapterResponseDTO.ChapterStatusDTO.builder()
//                        .statusCode(chapter.getChapterStatus().name())
//                        .description(chapter.getChapterStatus().getDescription())
//                        .build())
//                .subjectName(chapter.getSubject().getSubjectName())
//                .userCreated(chapter.getUserCreated())
//                .userFullName(userService.getUserFullName(chapter.getUserCreated()))
//                .updatedAt(chapter.getUpdatedAt())
//                .build());
//    }

//    /**
//     * Lọc danh sách chương theo subjectId, tên, và trạng thái với dữ liệu cơ bản.
//     */
//    public List<ChapterResponseDTO> findChaptersBySubjectId(Long subjectId, String chapterName, Boolean status) {
//        if (subjectId == null || subjectId <= 0) {
//            throw new IllegalArgumentException("ID môn học không hợp lệ.");
//        }
//        if (!subjectRepository.existsById(subjectId)) {
//            throw new IllegalArgumentException("Môn học không tồn tại.");
//        }
//
//        Specification<Chapter> spec = Specification.where(ChapterSpecifications.hasSubjectId(subjectId));
//        if (chapterName != null && !chapterName.trim().isEmpty()) {
//            spec = spec.and(ChapterSpecifications.hasName(chapterName));
//        }
//        if (status != null) {
//            spec = spec.and(ChapterSpecifications.hasStatus(status));
//        }
//
//        try {
//            return chapterRepository.findAll(spec).stream()
//                    .map(chapter -> ChapterResponseDTO.builder()
//                            .chapterId(chapter.getChapterId())
//                            .chapterName(chapter.getChapterName())
//                            .chapterDescription(chapter.getChapterDescription())
//                            .status(chapter.getStatus())
//                            .chapterStatus(ChapterResponseDTO.ChapterStatusDTO.builder()
//                                    .statusCode(chapter.getChapterStatus().name())
//                                    .description(chapter.getChapterStatus().getDescription())
//                                    .build())
//                            .listLesson(chapter.getLessons().stream()
//                                    .map(lesson -> LessonResponseDTO.builder()
//                                            .lessonId(lesson.getLessonId())
//                                            .lessonName(lesson.getLessonName())
//                                            .status(lesson.getStatus())
//                                            .lessonStatus(LessonResponseDTO.LessonStatusDTO.builder()
//                                                    .statusCode(lesson.getLessonStatus().name())
//                                                    .description(lesson.getLessonStatus().getDescription())
//                                                    .build())
//                                            .build())
//                                    .toList())
//                            .build())
//                    .toList();
//        } catch (Exception e) {
//            log.error("Failed to fetch chapters: {}", e.getMessage(), e);
//            throw new RuntimeException("Lỗi khi lấy danh sách chương.", e);
//        }
//    }

    /**
     * Lấy thông tin chương theo ID dưới dạng entity.
     */
    public Optional<Chapter> getChapterById(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new IllegalArgumentException("ID chương không hợp lệ.");
        }
        return chapterRepository.findById(chapterId);
    }
//
//    /**
//     * Lấy thông tin chương dưới dạng DTO đầy đủ theo ID.
//     */
//    public ChapterResponseDTO getChapterResponseByChapterId(Long chapterId) {
//        if (chapterId == null || chapterId <= 0) {
//            throw new IllegalArgumentException("ID chương không hợp lệ.");
//        }
//
//        Chapter chapter = chapterRepository.findById(chapterId)
//                .orElseThrow(() -> new IllegalArgumentException("Chương không tồn tại."));
//
//        return ChapterResponseDTO.builder()
//                .chapterId(chapter.getChapterId())
//                .chapterName(chapter.getChapterName())
//                .chapterDescription(chapter.getChapterDescription())
//                .status(chapter.getStatus())
//                .chapterStatus(ChapterResponseDTO.ChapterStatusDTO.builder()
//                        .statusCode(chapter.getChapterStatus().name())
//                        .description(chapter.getChapterStatus().getDescription())
//                        .build())
//                .subjectName(chapter.getSubject() != null ? chapter.getSubject().getSubjectName() : null)
//                .userCreated(chapter.getUserCreated())
//                .userFullName(chapter.getUserCreated() != null ? userService.getUserFullName(chapter.getUserCreated()) : null)
//                .updatedAt(chapter.getUpdatedAt())
//                .build();
//    }

//    /**
//     * Lấy thông tin chương dưới dạng DTO đầy đủ.
//     */
//    public ChapterResponseDTO getChapterResponseById(Long chapterId, Long subjectId) {
//        if (chapterId == null || chapterId <= 0) {
//            throw new IllegalArgumentException("ID chương không hợp lệ.");
//        }
//        if (subjectId == null || subjectId <= 0) {
//            throw new IllegalArgumentException("ID môn học không hợp lệ.");
//        }
//
//        Chapter chapter = chapterRepository.findById(chapterId)
//                .orElseThrow(() -> new IllegalArgumentException("Chương không tồn tại."));
//        if (!chapter.getSubject().getSubjectId().equals(subjectId)) {
//            throw new IllegalArgumentException("Chương không thuộc môn học này.");
//        }
//        return ChapterResponseDTO.builder()
//                .chapterId(chapter.getChapterId())
//                .chapterName(chapter.getChapterName())
//                .chapterDescription(chapter.getChapterDescription())
//                .status(chapter.getStatus())
//                .chapterStatus(ChapterResponseDTO.ChapterStatusDTO.builder()
//                        .statusCode(chapter.getChapterStatus().name())
//                        .description(chapter.getChapterStatus().getDescription())
//                        .build())
//                .listLesson(new ArrayList<>())
//                .build();
//    }

    public Page<ChapterListDTO> findChaptersBySubjectId(Long subjectId, String chapterName, Boolean status, Long userId, Pageable pageable) {
        validateStaffAccess(subjectId, userId);
        Specification<Chapter> spec = Specification.where(ChapterSpecifications.hasSubjectId(subjectId));
        if (chapterName != null && !chapterName.trim().isEmpty()) {
            spec = spec.and(ChapterSpecifications.hasName(chapterName));
        }
        if (status != null) {
            spec = spec.and(ChapterSpecifications.hasStatus(status));
        }

        return chapterRepository.findAll(spec, pageable).map(this::toChapterResponseDTO);
    }

    private void validateStaffAccess(Long subjectId, Long userId) {
        Optional<SubjectAssignment> assignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        if (assignment.isEmpty() || !assignment.get().getUser().getUserId().equals(userId)) {
            throw new IllegalArgumentException("subject.message.notAssigned");
        }
        Optional<SubjectStatusHistory> status = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subjectId);
        if (status.isEmpty() || status.get().getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT) {
            throw new IllegalArgumentException("subject.message.notDraftForEdit");
        }
    }

    private Chapter toChapterEntity(ChapterFormDTO dto) {
        Subject subject = subjectRepository.findById(dto.getSubjectId())
                .orElseThrow(() -> new IllegalArgumentException("subject.message.notFound"));
        return Chapter.builder()
                .chapterId(dto.getChapterId())
                .chapterName(dto.getChapterName())
                .chapterDescription(dto.getChapterDescription())
                .subject(subject)
                .build();
    }

    private ChapterListDTO toChapterResponseDTO(Chapter chapter) {
        return ChapterListDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .status(chapter.getStatus())
                .subjectName(chapter.getSubject().getSubjectName())
                .userCreated(chapter.getUserCreated())
                .userFullName(chapter.getUserCreated() != null ? userService.getUserFullName(chapter.getUserCreated()) : null)
                .createdAt(chapter.getCreatedAt() != null ? chapter.getCreatedAt().format(formatter) : null)
                .build();
    }


}