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
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.exception.*;
import swp.se1941jv.pls.repository.ChapterRepository;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.service.specification.ChapterSpecifications;

import java.time.LocalDateTime;
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
    private final LessonService lessonService;
    private final UserService userService;

    /**
     * Tạo chương mới từ entity.
     */
    @Transactional
    public void createChapter(Chapter chapter) {
        if (chapter == null) {
            throw new ValidationException("Dữ liệu chương không được để trống");
        }
        if (chapter.getSubject() == null || chapter.getSubject().getSubjectId() == null) {
            throw new ValidationException("ID môn học không hợp lệ");
        }

        Long subjectId = chapter.getSubject().getSubjectId();
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new NotFoundException("Môn học không tồn tại"));

        if (chapterRepository.existsByChapterNameAndSubject(chapter.getChapterName(), subject)) {
            throw new DuplicateNameException("Tên chương đã tồn tại cho môn học này");
        }

        chapter.setStatus(true);
        chapter.setChapterStatus(Chapter.ChapterStatus.DRAFT);

        try {
            chapterRepository.save(chapter);
            log.info("Chapter created: chapterId={}", chapter.getChapterId());
        } catch (Exception e) {
            log.error("Failed to create chapter: {}", e.getMessage(), e);
            throw new ApplicationException("CREATE_ERROR", "Lỗi khi tạo chương", e);
        }
    }

    /**
     * Cập nhật chương hiện có từ entity.
     */
    @Transactional
    public void updateChapter(Chapter chapter) {
        if (chapter == null || chapter.getChapterId() == null) {
            throw new ValidationException("Dữ liệu chương không được để trống");
        }
        if (chapter.getSubject() == null || chapter.getSubject().getSubjectId() == null) {
            throw new ValidationException("ID môn học không hợp lệ");
        }

        Long subjectId = chapter.getSubject().getSubjectId();
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new NotFoundException("Môn học không tồn tại"));

        if (!chapterRepository.existsById(chapter.getChapterId())) {
            throw new NotFoundException("Chương không tồn tại");
        }

        if (chapterRepository.existsByChapterNameAndSubject(chapter.getChapterName(), subject) &&
                !chapterRepository.findById(chapter.getChapterId())
                        .map(c -> c.getChapterName().equals(chapter.getChapterName()))
                        .orElse(false)) {
            throw new DuplicateNameException("Tên chương đã tồn tại cho môn học này");
        }

        try {
            chapterRepository.save(chapter);
            log.info("Chapter updated: chapterId={}", chapter.getChapterId());
        } catch (Exception e) {
            log.error("Failed to update chapter: {}", e.getMessage(), e);
            throw new ApplicationException("UPDATE_ERROR", "Lỗi khi cập nhật chương", e);
        }
    }

    /**
     * Nộp chương (chuyển trạng thái từ DRAFT sang PENDING).
     */
    @Transactional
    public void submitChapter(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
        }

        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new NotFoundException("Chương không tồn tại"));

        if (chapter.getChapterStatus() != Chapter.ChapterStatus.DRAFT) {
            throw new ApplicationException("SUBMIT_ERROR", "Chương không ở trạng thái DRAFT");
        }

        try {
            chapter.setChapterStatus(Chapter.ChapterStatus.PENDING);
            chapterRepository.save(chapter);
            log.info("Chapter submitted: chapterId={}", chapterId);
        } catch (Exception e) {
            log.error("Failed to submit chapter: {}", e.getMessage(), e);
            throw new ApplicationException("SUBMIT_ERROR", "Lỗi khi nộp chương", e);
        }
    }

    /**
     * Hủy trạng thái PENDING, chuyển về DRAFT.
     */
    @Transactional
    public void cancelChapter(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
        }

        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new NotFoundException("Chương không tồn tại"));

        if (chapter.getChapterStatus() != Chapter.ChapterStatus.PENDING) {
            throw new ApplicationException("CANCEL_ERROR", "Chương không ở trạng thái PENDING");
        }

        try {
            chapter.setChapterStatus(Chapter.ChapterStatus.DRAFT);
            chapterRepository.save(chapter);
            log.info("Chapter canceled: chapterId={}", chapterId);
        } catch (Exception e) {
            log.error("Failed to cancel chapter: {}", e.getMessage(), e);
            throw new ApplicationException("CANCEL_ERROR", "Lỗi khi hủy chương", e);
        }
    }

    public void approveChapter(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
        }
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new NotFoundException("Chương không tồn tại"));
        if (chapter.getChapterStatus() != Chapter.ChapterStatus.PENDING) {
            throw new ApplicationException("APPROVE_ERROR", "Chương không ở trạng thái PENDING");
        }
        try {
            chapter.setChapterStatus(Chapter.ChapterStatus.APPROVED);
            chapterRepository.save(chapter);
        } catch (Exception e) {
            throw new ApplicationException("APPROVE_ERROR", "Lỗi khi phê duyệt chương", e);
        }
        chapterRepository.save(chapter);
    }

    public void rejectChapter(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
        }
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new NotFoundException("Chương không tồn tại"));
        if (chapter.getChapterStatus() != Chapter.ChapterStatus.PENDING) {
            throw new ApplicationException("REJECT_ERROR", "Chương không ở trạng thái PENDING");
        }
        try {
            chapter.setChapterStatus(Chapter.ChapterStatus.REJECTED);
            chapterRepository.save(chapter);
        } catch (Exception e) {
            throw new ApplicationException("REJECT_ERROR", "Lỗi khi phê duyệt chương", e);
        }

    }

    /**
     * Lấy danh sách chương theo chapterStatus với phân trang và lọc.
     */
    public Page<ChapterResponseDTO> findChaptersByChapterStatus(
            Long subjectId,
            String chapterStatus,
            Boolean status,
            LocalDateTime startDate,
            LocalDateTime endDate,
            Long userCreated,
            int page,
            int size) {
        if (page < 0 || size <= 0) {
            throw new ValidationException("Thông số phân trang không hợp lệ");
        }

        Specification<Chapter> spec = Specification.where(null);
        if (subjectId != null) {
            spec = spec.and(ChapterSpecifications.hasSubjectId(subjectId));
        }
        if (chapterStatus != null && !chapterStatus.trim().isEmpty()) {
            spec = spec.and(ChapterSpecifications.hasChapterStatus(chapterStatus));
        } else {
            // Mặc định chỉ lấy PENDING, APPROVED, REJECTED
            spec = spec.and((root, query, cb) -> cb.in(root.get("chapterStatus"))
                    .value(Chapter.ChapterStatus.PENDING)
                    .value(Chapter.ChapterStatus.APPROVED)
                    .value(Chapter.ChapterStatus.REJECTED));
        }
        if (status != null) {
            spec = spec.and(ChapterSpecifications.hasStatus(status));
        }
        if (startDate != null || endDate != null) {
            spec = spec.and(ChapterSpecifications.hasUpdatedAtBetween(startDate, endDate));
        }
        if (userCreated != null) {
            spec = spec.and(ChapterSpecifications.hasUserCreated(userCreated));
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "updatedAt"));
        Page<Chapter> chapters = chapterRepository.findAll(spec, pageable);

        return chapters.map(chapter -> ChapterResponseDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .status(chapter.getStatus())
                .chapterStatus(ChapterResponseDTO.ChapterStatusDTO.builder()
                        .statusCode(chapter.getChapterStatus().name())
                        .description(chapter.getChapterStatus().getDescription())
                        .build())
                .subjectName(chapter.getSubject().getSubjectName())
                .userCreated(chapter.getUserCreated())
                .userFullName(userService.getUserFullName(chapter.getUserCreated()))
                .updatedAt(chapter.getUpdatedAt())
                .build());
    }


    /**
     * Cập nhật trạng thái của nhiều chương.
     */
    @Transactional
    public void toggleChaptersStatus(List<Long> chapterIds) {
        if (chapterIds == null || chapterIds.isEmpty()) {
            throw new ValidationException("Danh sách ID chương không được để trống");
        }
        if (chapterIds.stream().anyMatch(id -> id == null || id <= 0)) {
            throw new ValidationException("ID chương không hợp lệ trong danh sách");
        }

        List<Chapter> chapters = chapterRepository.findAllById(chapterIds);
        if (chapters.isEmpty()) {
            throw new NotFoundException("Không tìm thấy chương nào trong danh sách");
        }

        try {
            chapters.forEach(chapter -> chapter.setStatus(!chapter.getStatus()));
            chapterRepository.saveAll(chapters);
            log.info("Updated status for chapters: {}", chapterIds);
        } catch (Exception e) {
            log.error("Failed to update chapter status: {}", e.getMessage(), e);
            throw new ApplicationException("UPDATE_ERROR", "Lỗi khi cập nhật trạng thái chương", e);
        }
    }

    /**
     * Lọc danh sách chương theo subjectId, tên, và trạng thái với dữ liệu cơ bản.
     */
    public List<ChapterResponseDTO> findChaptersBySubjectId(Long subjectId, String chapterName, Boolean status) {
        if (subjectId == null || subjectId <= 0) {
            throw new ValidationException("ID môn học không hợp lệ");
        }
        if (!subjectRepository.existsById(subjectId)) {
            throw new NotFoundException("Môn học không tồn tại");
        }

        Specification<Chapter> spec = Specification.where(ChapterSpecifications.hasSubjectId(subjectId));
        if (chapterName != null && !chapterName.trim().isEmpty()) {
            spec = spec.and(ChapterSpecifications.hasName(chapterName));
        }
        if (status != null) {
            spec = spec.and(ChapterSpecifications.hasStatus(status));
        }

        try {
            return chapterRepository.findAll(spec).stream()
                    .map(chapter -> ChapterResponseDTO.builder()
                            .chapterId(chapter.getChapterId())
                            .chapterName(chapter.getChapterName())
                            .chapterDescription(chapter.getChapterDescription())
                            .status(chapter.getStatus())
                            .chapterStatus(ChapterResponseDTO.ChapterStatusDTO.builder()
                                    .statusCode(chapter.getChapterStatus().name())
                                    .description(chapter.getChapterStatus().getDescription())
                                    .build())
                            .listLesson(chapter.getLessons().stream()
                                    .map(lesson -> LessonResponseDTO.builder()
                                            .lessonId(lesson.getLessonId())
                                            .lessonName(lesson.getLessonName())
                                            .status(lesson.getStatus())
                                            .lessonStatus(LessonResponseDTO.LessonStatusDTO.builder()
                                                    .statusCode(lesson.getLessonStatus().name())
                                                    .description(lesson.getLessonStatus().getDescription())
                                                    .build())
                                            .build())
                                    .toList())
                            .build())
                    .toList();
        } catch (Exception e) {
            log.error("Failed to fetch chapters: {}", e.getMessage(), e);
            throw new ApplicationException("FETCH_ERROR", "Lỗi khi lấy danh sách chương", e);
        }
    }

    /**
     * Lấy thông tin chương theo ID dưới dạng entity.
     */
    public Optional<Chapter> getChapterById(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
        }
        return chapterRepository.findById(chapterId);
    }


    /**
     * Lấy thông tin chương dưới dạng DTO đầy đủ theo ID.
     */
    public ChapterResponseDTO getChapterResponseByChapterId(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
        }

        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new NotFoundException("Chương không tồn tại"));

        return ChapterResponseDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .status(chapter.getStatus())
                .chapterStatus(ChapterResponseDTO.ChapterStatusDTO.builder()
                        .statusCode(chapter.getChapterStatus().name())
                        .description(chapter.getChapterStatus().getDescription())
                        .build())
                .subjectName(chapter.getSubject() != null ? chapter.getSubject().getSubjectName() : null)
                .userCreated(chapter.getUserCreated())
                .userFullName(chapter.getUserCreated() != null ? userService.getUserFullName(chapter.getUserCreated()) : null)
                .updatedAt(chapter.getUpdatedAt())
                .build();
    }

    /**
     * Lấy thông tin chương dưới dạng DTO đầy đủ.
     */
    public ChapterResponseDTO getChapterResponseById(Long chapterId, Long subjectId) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
        }
        if (subjectId == null || subjectId <= 0) {
            throw new ValidationException("ID môn học không hợp lệ");
        }

        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new NotFoundException("Chương không tồn tại"));
        if (!chapter.getSubject().getSubjectId().equals(subjectId)) {
            throw new RelationshipException("Chương không thuộc môn học này");
        }
        return ChapterResponseDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .status(chapter.getStatus())
                .chapterStatus(ChapterResponseDTO.ChapterStatusDTO.builder()
                        .statusCode(chapter.getChapterStatus().name())
                        .description(chapter.getChapterStatus().getDescription())
                        .build())
                .listLesson(new ArrayList<>())
                .build();
    }


}