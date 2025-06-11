package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.exception.lesson.DuplicateLessonNameException;
import swp.se1941jv.pls.exception.lesson.LessonNotFoundException;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.service.specification.LessonSpecifications;


import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class LessonService {

    private final LessonRepository lessonRepository;
    private final ObjectMapper objectMapper;

    public LessonService(LessonRepository lessonRepository, @Qualifier("jacksonObjectMapper") ObjectMapper objectMapper) {
        this.lessonRepository = lessonRepository;
        this.objectMapper = objectMapper;
    }

    /**
     * Kiểm tra xem tên bài học đã tồn tại trong chương chưa.
     *
     * @param lessonName Tên bài học
     * @param chapterId  ID của chương
     * @return true nếu tên bài học đã tồn tại, false nếu không
     */
    public boolean existsByLessonNameAndChapterChapterId(String lessonName, Long chapterId) {
        return lessonRepository.existsByLessonNameAndChapter_ChapterId(lessonName, chapterId);
    }

    /**
     * Lưu hoặc cập nhật một bài học.
     *
     * @param lesson Bài học cần lưu
     * @throws DuplicateLessonNameException nếu tên bài học đã tồn tại
     * @throws LessonNotFoundException      nếu bài học không tồn tại khi cập nhật
     */
    @Transactional
    public void saveLesson(Lesson lesson) {
        if (lesson.getLessonId() == null) {
            // Tạo mới
            if (existsByLessonNameAndChapterChapterId(lesson.getLessonName(), lesson.getChapter().getChapterId())) {
                throw new DuplicateLessonNameException("Tên bài học đã tồn tại trong chương này");
            }
        } else {
            // Cập nhật
            Lesson existingLesson = findLessonById(lesson.getLessonId())
                    .orElseThrow(() -> new LessonNotFoundException("Bài học không tồn tại"));
            if (!existingLesson.getLessonName().equals(lesson.getLessonName()) &&
                    existsByLessonNameAndChapterChapterId(lesson.getLessonName(), lesson.getChapter().getChapterId())) {
                throw new DuplicateLessonNameException("Tên bài học đã tồn tại trong chương này");
            }
        }
        lessonRepository.save(lesson);
    }

    /**
     * Lấy danh sách bài học theo chapterId.
     *
     * @param chapterId ID của chương
     * @return Danh sách bài học
     */
    public List<Lesson> findLessonsByChapterId(Long chapterId) {
        return lessonRepository.findAll(LessonSpecifications.hasChapterId(chapterId));
    }

    /**
     * Tìm một bài học theo ID.
     *
     * @param lessonId ID của bài học
     * @return Optional chứa bài học nếu tìm thấy
     */
    public Optional<Lesson> findLessonById(Long lessonId) {
        return lessonRepository.findById(lessonId);
    }

    /**
     * Đổi trạng thái (true/false) của nhiều bài học.
     *
     * @param lessonIds Danh sách ID của các bài học
     */
    @Transactional
    public void toggleLessonsStatus(List<Long> lessonIds) {
        List<Lesson> lessons = lessonRepository.findAllById(lessonIds);
        for (Lesson lesson : lessons) {
            lesson.setStatus(!lesson.getStatus());
        }
        lessonRepository.saveAll(lessons);
    }

    /**
     * Lấy một bài học active theo ID.
     *
     * @param lessonId ID của bài học
     * @return Optional chứa bài học nếu tìm thấy và active
     */
    public Optional<Lesson> getActiveLessonById(Long lessonId) {
        return lessonRepository.findByLessonIdAndStatusTrue(lessonId);
    }

    /**
     * Lấy danh sách các LessonResponseDTO active của một chapter.
     *
     * @param chapterId ID của chương
     * @return Danh sách LessonResponseDTO chứa thông tin lesson và danh sách materials
     */
    public List<LessonResponseDTO> getActiveLessonsResponseByChapterId(Long chapterId) {
        List<Lesson> lessons = getActiveLessonsByChapterId(chapterId);
        return lessons.stream()
                .map(lesson -> LessonResponseDTO.builder()
                        .lessonId(lesson.getLessonId())
                        .lessonName(lesson.getLessonName())
                        .lessonDescription(lesson.getLessonDescription())
                        .build())
                .collect(Collectors.toList());
    }

    // Phương thức hỗ trợ (giả định từ phản hồi trước)
    private List<Lesson> getActiveLessonsByChapterId(Long chapterId) {
        return lessonRepository.findByChapterIdAndIsActive(chapterId, true);
    }

    /**
     * Lấy thông tin chi tiết của một bài học active dưới dạng DTO.
     *
     * @param lessonId ID của bài học
     * @return LessonResponseDTO chứa thông tin lesson và danh sách materials
     * @throws LessonNotFoundException nếu bài học không tồn tại hoặc không active
     */
    public LessonResponseDTO getActiveLessonResponseById(Long lessonId) {
        Lesson lesson = getActiveLessonById(lessonId).orElse(null);
        if (lesson == null) {
            throw new LessonNotFoundException("Bài học không tồn tại hoặc không active");
        }
        List<String> materials = new ArrayList<>();
        try {
            if (lesson.getMaterialsJson() != null && !lesson.getMaterialsJson().isEmpty()) {
                materials = objectMapper.readValue(lesson.getMaterialsJson(), new TypeReference<List<String>>() {});
            }
        } catch (Exception e) {
            materials = new ArrayList<>();
        }
        return LessonResponseDTO.builder()
                .lessonId(lesson.getLessonId())
                .lessonName(lesson.getLessonName())
                .lessonDescription(lesson.getLessonDescription())
                .videoSrc(lesson.getVideoSrc())
                .status(lesson.getStatus())
                .materials(materials)
                .build();
    }
}

