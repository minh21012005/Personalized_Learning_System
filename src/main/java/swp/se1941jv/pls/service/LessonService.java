package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.exception.ApplicationException;
import swp.se1941jv.pls.exception.DuplicateNameException;
import swp.se1941jv.pls.exception.NotFoundException;
import swp.se1941jv.pls.exception.ValidationException;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.service.specification.LessonSpecifications;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class LessonService {

    private final LessonRepository lessonRepository;
    private final ObjectMapper objectMapper;

    /**
     * Lưu hoặc cập nhật bài học từ entity.
     *
     * @param lesson Entity chứa thông tin bài học
     * @throws ValidationException nếu dữ liệu đầu vào không hợp lệ
     * @throws DuplicateNameException nếu tên bài học đã tồn tại
     * @throws NotFoundException nếu bài học không tồn tại khi cập nhật
     */
    @Transactional
    public void saveLesson(Lesson lesson) {
        if (lesson == null) {
            throw new ValidationException("Dữ liệu bài học không được để trống");
        }
        if (lesson.getChapter() == null || lesson.getChapter().getChapterId() == null) {
            throw new ValidationException("ID chương không hợp lệ");
        }

        Long chapterId = lesson.getChapter().getChapterId();
        // Kiểm tra tên bài học trùng lặp
        if (lessonRepository.existsByLessonNameAndChapter_ChapterId(lesson.getLessonName(), chapterId)) {
            if (lesson.getLessonId() == null ||
                    !lessonRepository.findById(lesson.getLessonId())
                            .map(l -> l.getLessonName().equals(lesson.getLessonName()))
                            .orElse(false)) {
                throw new DuplicateNameException("Tên bài học đã tồn tại trong chương này");
            }
        }

        if (lesson.getLessonId() != null && !lessonRepository.existsById(lesson.getLessonId())) {
            throw new NotFoundException("Bài học không tồn tại");
        }

        try {
            lessonRepository.save(lesson);
            log.info("Lesson saved: lessonId={}", lesson.getLessonId());
        } catch (Exception e) {
            log.error("Failed to save lesson: {}", e.getMessage(), e);
            throw new ApplicationException("SAVE_ERROR", "Lỗi khi lưu bài học", e);
        }
    }

    /**
     * Tìm danh sách bài học theo chapterId, tên, và trạng thái với dữ liệu cơ bản.
     *
     * @param chapterId ID của chương
     * @param lessonName Tên bài học (tùy chọn)
     * @param status Trạng thái (tùy chọn)
     * @return Danh sách LessonResponseDTO với dữ liệu cơ bản
     * @throws ValidationException nếu chapterId không hợp lệ
     */
    public List<LessonResponseDTO> findLessonsByChapterId(Long chapterId, String lessonName, Boolean status) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
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
                            .build())
                    .toList();
        } catch (Exception e) {
            log.error("Failed to fetch lessons: {}", e.getMessage(), e);
            throw new ApplicationException("FETCH_ERROR", "Lỗi khi lấy danh sách bài học", e);
        }
    }

    /**
     * Lấy thông tin bài học theo ID dưới dạng entity.
     *
     * @param lessonId ID của bài học
     * @return Optional chứa Lesson entity
     */
    public Optional<Lesson> getLessonById(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new ValidationException("ID bài học không hợp lệ");
        }
        return lessonRepository.findById(lessonId);
    }

    /**
     * Lấy thông tin bài học theo ID dưới dạng DTO đầy đủ.
     *
     * @param lessonId ID của bài học
     * @return LessonResponseDTO
     * @throws NotFoundException nếu bài học không tồn tại
     * @throws ValidationException nếu lessonId không hợp lệ
     */
    public LessonResponseDTO getLessonResponseById(Long lessonId) {
        if (lessonId == null || lessonId <= 0) {
            throw new ValidationException("ID bài học không hợp lệ");
        }

        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new NotFoundException("Bài học không tồn tại"));
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
                .materials(materials)
                .build();
    }

    /**
     * Cập nhật trạng thái của nhiều bài học.
     *
     * @param lessonIds Danh sách ID bài học
     * @throws ValidationException nếu danh sách lessonIds không hợp lệ
     * @throws NotFoundException nếu không tìm thấy bài học
     */
    @Transactional
    public void toggleLessonsStatus(List<Long> lessonIds) {
        if (lessonIds == null || lessonIds.isEmpty()) {
            throw new ValidationException("Danh sách ID bài học không được để trống");
        }
        if (lessonIds.stream().anyMatch(id -> id == null || id <= 0)) {
            throw new ValidationException("ID bài học không hợp lệ trong danh sách");
        }

        List<Lesson> lessons = lessonRepository.findAllById(lessonIds);
        if (lessons.isEmpty()) {
            throw new NotFoundException("Không tìm thấy bài học nào trong danh sách");
        }

        try {
            lessons.forEach(lesson -> lesson.setStatus(!lesson.getStatus()));
            lessonRepository.saveAll(lessons);
            log.info("Updated status for lessons: {}", lessonIds);
        } catch (Exception e) {
            log.error("Failed to update lesson status: {}", e.getMessage(), e);
            throw new ApplicationException("UPDATE_ERROR", "Lỗi khi cập nhật trạng thái bài học", e);
        }
    }
}