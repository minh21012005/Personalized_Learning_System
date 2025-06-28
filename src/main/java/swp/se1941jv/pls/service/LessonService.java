package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.service.specification.LessonSpecifications;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class LessonService {

    private final LessonRepository lessonRepository;
    private final ObjectMapper objectMapper;
    private final UserService userService;

    /**
     * Tạo bài học mới.
     */
    @Transactional
    public void createLesson(Lesson lesson) {
        if (lesson == null || lesson.getChapter() == null || lesson.getChapter().getChapterId() == null) {
            throw new IllegalArgumentException("Dữ liệu bài học không hợp lệ.");
        }
        Long chapterId = lesson.getChapter().getChapterId();

        if (lessonRepository.existsByLessonNameAndChapter_ChapterId(lesson.getLessonName(), chapterId)) {
            throw new IllegalArgumentException("Tên bài học đã tồn tại trong chương này.");
        }

        try {
            lessonRepository.save(lesson);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tạo bài học.", e);
        }
    }

    /**
     * Cập nhật bài học hiện có.
     */
    @Transactional
    public void updateLesson(Lesson lesson) {
        if (lesson == null || lesson.getLessonId() == null || lesson.getChapter() == null || lesson.getChapter().getChapterId() == null) {
            throw new IllegalArgumentException("Dữ liệu bài học không hợp lệ.");
        }
        Long chapterId = lesson.getChapter().getChapterId();

        if (!lessonRepository.existsById(lesson.getLessonId())) {
            throw new IllegalArgumentException("Bài học không tồn tại.");
        }

        if (lesson.getLessonStatus() != Lesson.LessonStatus.DRAFT) {
            throw new IllegalArgumentException("Bài học không ở trạng thái DRAFT.");
        }

        if (lessonRepository.existsByLessonNameAndChapter_ChapterId(lesson.getLessonName(), chapterId) &&
                !lessonRepository.findById(lesson.getLessonId())
                        .map(l -> l.getLessonName().equals(lesson.getLessonName()))
                        .orElse(false)) {
            throw new IllegalArgumentException("Tên bài học đã tồn tại trong chương này.");
        }

        try {
            lessonRepository.save(lesson);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi cập nhật bài học.", e);
        }
    }

    /**
     * Nộp bài học (chuyển trạng thái từ DRAFT sang PENDING).
     */
    @Transactional
    public void submitLesson(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new IllegalArgumentException("ID bài học không hợp lệ.");
        }

        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại."));

        if (lesson.getLessonStatus() != Lesson.LessonStatus.DRAFT) {
            throw new IllegalArgumentException("Bài học không ở trạng thái DRAFT.");
        }

        try {
            lesson.setLessonStatus(Lesson.LessonStatus.PENDING);
            lessonRepository.save(lesson);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi nộp bài học.", e);
        }
    }

    /**
     * Hủy nộp bài học (chuyển trạng thái từ PENDING về DRAFT).
     */
    @Transactional
    public void cancelLesson(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new IllegalArgumentException("ID bài học không hợp lệ.");
        }

        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại."));

        if (lesson.getLessonStatus() != Lesson.LessonStatus.PENDING) {
            throw new IllegalArgumentException("Chỉ có bài học ở trạng thái PENDING mới có thể hủy.");
        }

        try {
            lesson.setLessonStatus(Lesson.LessonStatus.DRAFT);
            lessonRepository.save(lesson);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi hủy nộp bài học.", e);
        }
    }

    /**
     * Phê duyệt bài học (chuyển trạng thái sang APPROVED).
     */
    @Transactional
    public void approveLesson(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new IllegalArgumentException("ID bài học không hợp lệ.");
        }

        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại."));

        if (lesson.getLessonStatus() == Lesson.LessonStatus.APPROVED) {
            throw new IllegalArgumentException("Bài học đã được phê duyệt.");
        }

        try {
            lesson.setLessonStatus(Lesson.LessonStatus.APPROVED);
            lessonRepository.save(lesson);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi phê duyệt bài học.", e);
        }
    }

    /**
     * Từ chối bài học (chuyển trạng thái sang REJECTED).
     */
    @Transactional
    public void rejectLesson(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new IllegalArgumentException("ID bài học không hợp lệ.");
        }

        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại."));

        if (lesson.getLessonStatus() == Lesson.LessonStatus.REJECTED) {
            throw new IllegalArgumentException("Bài học đã bị từ chối.");
        }

        try {
            lesson.setLessonStatus(Lesson.LessonStatus.REJECTED);
            lessonRepository.save(lesson);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi từ chối bài học.", e);
        }
    }

    /**
     * Tìm danh sách bài học theo chapterId, tên, và trạng thái với dữ liệu cơ bản.
     */
    public List<LessonResponseDTO> findLessonsByChapterId(Long chapterId, String lessonName, Boolean status) {
        if (chapterId == null || chapterId <= 0) {
            throw new IllegalArgumentException("ID chương không hợp lệ.");
        }

        Specification<Lesson> spec = Specification.where(LessonSpecifications.hasChapterId(chapterId));
        if (lessonName != null && !lessonName.trim().isEmpty()) {
            spec = spec.and(LessonSpecifications.hasName(lessonName));
        }
        if (status != null) {
            spec = spec.and(LessonSpecifications.hasStatus(status));
        }

        try {
            return lessonRepository.findAll(spec).stream()
                    .map(lesson -> LessonResponseDTO.builder()
                            .lessonId(lesson.getLessonId())
                            .lessonName(lesson.getLessonName())
                            .videoSrc(lesson.getVideoSrc())
                            .videoTime(lesson.getVideoTime())
                            .status(lesson.getStatus())
                            .lessonStatus(LessonResponseDTO.LessonStatusDTO.builder()
                                    .statusCode(lesson.getLessonStatus().name())
                                    .description(lesson.getLessonStatus().getDescription())
                                    .build())
                            .build())
                    .toList();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi lấy danh sách bài học.", e);
        }
    }

    /**
     * Lấy thông tin bài học theo ID dưới dạng entity.
     */
    public Optional<Lesson> getLessonById(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new IllegalArgumentException("ID bài học không hợp lệ.");
        }
        return lessonRepository.findById(lessonId);
    }

    /**
     * Lấy thông tin bài học theo ID dưới dạng DTO đầy đủ.
     */
    public LessonResponseDTO getLessonResponseById(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new IllegalArgumentException("ID bài học không hợp lệ.");
        }

        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại."));
        List<String> materials = new ArrayList<>();
        try {
            if (lesson.getMaterialsJson() != null && !lesson.getMaterialsJson().isEmpty()) {
                materials = objectMapper.readValue(lesson.getMaterialsJson(), new TypeReference<>() {});
            }
        } catch (Exception e) {
            log.warn("Failed to parse materials for lessonId={}: {}", lesson.getLessonId(), e.getMessage());
        }

        return LessonResponseDTO.builder()
                .lessonId(lesson.getLessonId())
                .lessonName(lesson.getLessonName())
                .lessonDescription(lesson.getLessonDescription())
                .videoSrc(lesson.getVideoSrc())
                .videoTime(lesson.getVideoTime())
                .status(lesson.getStatus())
                .lessonStatus(LessonResponseDTO.LessonStatusDTO.builder()
                        .statusCode(lesson.getLessonStatus().name())
                        .description(lesson.getLessonStatus().getDescription())
                        .build())
                .materials(materials)
                .build();
    }

    /**
     * Lấy danh sách bài học đã được phê duyệt (APPROVED) của một chương.
     */
    public List<LessonResponseDTO> getApprovedLessonsByChapterId(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new IllegalArgumentException("ID chương không hợp lệ.");
        }

        return findLessonsByChapterId(chapterId, null, null).stream()
                .filter(lesson -> "APPROVED".equals(lesson.getLessonStatus().getStatusCode()))
                .toList();
    }

    /**
     * Cập nhật trạng thái của nhiều bài học.
     */
    @Transactional
    public void toggleLessonsStatus(List<Long> lessonIds) {
        if (lessonIds == null || lessonIds.isEmpty()) {
            throw new IllegalArgumentException("Danh sách ID bài học không được để trống.");
        }
        if (lessonIds.stream().anyMatch(id -> id == null || id <= 0)) {
            throw new IllegalArgumentException("ID bài học không hợp lệ trong danh sách.");
        }

        List<Lesson> lessons = lessonRepository.findAllById(lessonIds);
        if (lessons.isEmpty()) {
            throw new IllegalArgumentException("Không tìm thấy bài học nào trong danh sách.");
        }

        try {
            lessons.forEach(lesson -> lesson.setStatus(!lesson.getStatus()));
            lessonRepository.saveAll(lessons);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi cập nhật trạng thái bài học.", e);
        }
    }

    /**
     * Tìm danh sách bài học theo các bộ lọc với phân trang và sắp xếp, chỉ lấy PENDING, APPROVED, REJECTED.
     */
    public Page<LessonResponseDTO> findLessonsByFilters(
            Long subjectId, Long chapterId, String lessonStatus, Boolean status,
            LocalDate startDate, LocalDate endDate, Long userCreated,
            int page, int size, Sort sort) {
        if (page < 0 || size <= 0) {
            throw new IllegalArgumentException("Thông số phân trang không hợp lệ.");
        }

        Specification<Lesson> spec = Specification.where(null);
        if (subjectId != null) {
            spec = spec.and(LessonSpecifications.hasSubjectId(subjectId));
        }
        if (chapterId != null) {
            spec = spec.and(LessonSpecifications.hasChapterId(chapterId));
        }
        if (lessonStatus != null && !lessonStatus.trim().isEmpty()) {
            spec = spec.and(LessonSpecifications.hasLessonStatus(lessonStatus));
        } else {
            spec = spec.and((root, query, cb) -> cb.in(root.get("lessonStatus"))
                    .value(Lesson.LessonStatus.PENDING)
                    .value(Lesson.LessonStatus.APPROVED)
                    .value(Lesson.LessonStatus.REJECTED));
        }
        if (status != null) {
            spec = spec.and(LessonSpecifications.hasStatus(status));
        }
        if (startDate != null || endDate != null) {
            spec = spec.and(LessonSpecifications.hasUpdatedAtBetween(startDate, endDate));
        }
        if (userCreated != null) {
            spec = spec.and(LessonSpecifications.hasUserCreated(userCreated));
        }

        PageRequest pageRequest = PageRequest.of(page, size, sort);
        return lessonRepository.findAll(spec, pageRequest).map(lesson -> {
            String userFullName = lesson.getChapter() != null && lesson.getChapter().getUserCreated() != null
                    ? userService.getUserFullName(lesson.getChapter().getUserCreated())
                    : "Chưa có thông tin";
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            return LessonResponseDTO.builder()
                    .lessonId(lesson.getLessonId())
                    .lessonName(lesson.getLessonName())
                    .lessonDescription(lesson.getLessonDescription())
                    .videoSrc(lesson.getVideoSrc())
                    .videoTime(lesson.getVideoTime())
                    .status(lesson.getStatus())
                    .lessonStatus(LessonResponseDTO.LessonStatusDTO.builder()
                            .statusCode(lesson.getLessonStatus().name())
                            .description(lesson.getLessonStatus().getDescription())
                            .build())
                    .materials(new ArrayList<>())
                    .chapterId(lesson.getChapter() != null ? lesson.getChapter().getChapterId() : null)
                    .chapterName(lesson.getChapter() != null ? lesson.getChapter().getChapterName() : "Chưa có dữ liệu")
                    .userFullName(userFullName)
                    .subjectName(lesson.getChapter() != null && lesson.getChapter().getSubject() != null
                            ? lesson.getChapter().getSubject().getSubjectName()
                            : "Chưa có dữ liệu")
                    .updatedAt(lesson.getUpdatedAt().format(formatter))
                    .build();
        });
    }

    /**
     * Lấy thông tin bài học đầy đủ theo ID dưới dạng DTO.
     */
    public LessonResponseDTO getFullLessonResponseById(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new IllegalArgumentException("ID bài học không hợp lệ.");
        }

        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại."));
        List<String> materials = new ArrayList<>();
        try {
            if (lesson.getMaterialsJson() != null && !lesson.getMaterialsJson().isEmpty()) {
                materials = objectMapper.readValue(lesson.getMaterialsJson(), new TypeReference<>() {});
            }
        } catch (Exception e) {
            log.warn("Failed to parse materials for lessonId={}: {}", lesson.getLessonId(), e.getMessage());
        }

        String userFullName = lesson.getChapter() != null && lesson.getChapter().getUserCreated() != null
                ? userService.getUserFullName(lesson.getChapter().getUserCreated())
                : "Chưa có thông tin";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return LessonResponseDTO.builder()
                .lessonId(lesson.getLessonId())
                .lessonName(lesson.getLessonName())
                .lessonDescription(lesson.getLessonDescription())
                .videoSrc(lesson.getVideoSrc())
                .videoTime(lesson.getVideoTime())
                .status(lesson.getStatus())
                .lessonStatus(LessonResponseDTO.LessonStatusDTO.builder()
                        .statusCode(lesson.getLessonStatus().name())
                        .description(lesson.getLessonStatus().getDescription())
                        .build())
                .materials(materials)
                .chapterId(lesson.getChapter() != null ? lesson.getChapter().getChapterId() : null)
                .chapterName(lesson.getChapter() != null ? lesson.getChapter().getChapterName() : "Chưa có dữ liệu")
                .userFullName(userFullName)
                .subjectName(lesson.getChapter() != null && lesson.getChapter().getSubject() != null
                        ? lesson.getChapter().getSubject().getSubjectName()
                        : "Chưa có dữ liệu")
                .updatedAt(lesson.getUpdatedAt().format(formatter))
                .build();
    }


}