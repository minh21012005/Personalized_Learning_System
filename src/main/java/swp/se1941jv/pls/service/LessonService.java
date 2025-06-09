package swp.se1941jv.pls.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.service.specification.LessonSpecifications;

import java.util.List;
import java.util.Optional;

@Service
public class LessonService {
    private final LessonRepository lessonRepository;
    public LessonService(LessonRepository lessonRepository) {
        this.lessonRepository = lessonRepository;
    }

    public Page<Lesson> findLessons(Long chapterId ,Pageable pageable) {
        Specification<Lesson> spec = Specification.where(null);
        if(chapterId != null){
            spec = spec.and(LessonSpecifications.hasChapterId(chapterId));
        }
        return lessonRepository.findAll(spec, pageable);
    }

    public Optional<Lesson> findLesson(Long lessonId) {
        return lessonRepository.findById(lessonId);
    }

    public void saveLesson(Lesson lesson) {
        lessonRepository.save(lesson);
    }

    public void updateLessonsStatus(List<Long> lessonIds) {
        for (Long id : lessonIds) {
            Optional<Lesson> lessonOpt = lessonRepository.findById(id);
            if (lessonOpt.isPresent()) {
                Lesson lesson = lessonOpt.get();
                lesson.setStatus(!lesson.getStatus()); // Đảo ngược trạng thái
                lessonRepository.save(lesson);
            }
        }
    }

    public boolean existsByLessonNameAndChapterId(String lessonName, Long chapterId) {
        return lessonRepository.existsByLessonNameAndChapterChapterId(lessonName, chapterId);
    }
}
