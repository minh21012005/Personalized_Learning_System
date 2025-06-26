package swp.se1941jv.pls.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.LessonProgress;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.keys.KeyLessonUser;
import swp.se1941jv.pls.repository.LessonProgressRepository;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class LessonProgressService {

    private final LessonProgressRepository lessonProgressRepository;
    private final UserRepository userRepository;
    private final LessonRepository lessonRepository;

    public LessonProgressService(LessonProgressRepository lessonProgressRepository, UserRepository userRepository, LessonRepository lessonRepository) {
        this.lessonProgressRepository = lessonProgressRepository;
        this.userRepository = userRepository;
        this.lessonRepository = lessonRepository;
    }

    public LessonProgress saveProgress(Long userId, Long lessonId, Integer watchedTime, Boolean isCompleted) {

        KeyLessonUser keyLessonUser = KeyLessonUser.builder()
                .userId(userId)
                .lessonId(lessonId)
                .build();

        Optional<LessonProgress> existing = lessonProgressRepository.findById(keyLessonUser);
        LessonProgress progress;

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + userId));

        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Lesson not found with id: " + lessonId));
        if (existing.isPresent()) {
            progress = existing.get();
            progress.setWatchedTime(watchedTime);
            progress.setIsCompleted(isCompleted);
        } else {
            progress = LessonProgress.builder()
                    .user(user)
                    .lesson(lesson)
                    .watchedTime(watchedTime)
                    .isCompleted(isCompleted)
                    .build();
        }

        progress.setUpdatedAt(LocalDateTime.now());
        return lessonProgressRepository.save(progress);
    }

    public Optional<LessonProgress> getProgress(Long userId, Long lessonId) {
        KeyLessonUser keyLessonUser = KeyLessonUser.builder()
                .userId(userId)
                .lessonId(lessonId)
                .build();

        return lessonProgressRepository.findById(keyLessonUser);
    }
}
