package swp.se1941jv.pls.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.exception.Lesson.DuplicateLessonNameException;
import swp.se1941jv.pls.exception.Lesson.LessonNotFoundException;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.service.specification.LessonSpecifications;


import java.util.List;
import java.util.Optional;

@Service
public class LessonService {

    private final LessonRepository lessonRepository;

    @Autowired
    public LessonService(LessonRepository lessonRepository) {
        this.lessonRepository = lessonRepository;
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
}

