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
import java.util.HashMap;
import java.util.Map;
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
        if (userId == null || lessonId == null) {
            throw new IllegalArgumentException("userId và lessonId không được để trống");
        }
        if (watchedTime == null || isCompleted == null) {
            throw new IllegalArgumentException("watchedTime và isCompleted không được để trống");
        }

        KeyLessonUser key = KeyLessonUser.builder()
                .userId(userId)
                .lessonId(lessonId)
                .build();

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng với id: " + userId));

        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài học với id: " + lessonId));

        Optional<LessonProgress> existing = lessonProgressRepository.findById(key);
        LessonProgress progress;

        if (existing.isPresent()) {
            progress = existing.get();
            if (Boolean.TRUE.equals(progress.getIsCompleted())) {
                return progress; // Không cập nhật nếu đã hoàn thành
            }
            if (Boolean.TRUE.equals(isCompleted) && !Boolean.TRUE.equals(progress.getIsCompleted())) {
                progress.setWatchedTime(watchedTime);
                progress.setIsCompleted(isCompleted);
            }
            else
            if (progress.getWatchedTime() >= watchedTime) {
                return progress; // Không cập nhật nếu thời gian mới nhỏ hơn hoặc bằng
            }
            progress.setWatchedTime(watchedTime);
            progress.setIsCompleted(isCompleted);
        } else {
            progress = LessonProgress.builder()
                    .id(key)
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
        KeyLessonUser key = KeyLessonUser.builder()
                .userId(userId)
                .lessonId(lessonId)
                .build();
        return lessonProgressRepository.findById(key);
    }
}
