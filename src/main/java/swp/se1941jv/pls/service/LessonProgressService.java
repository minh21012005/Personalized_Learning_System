package swp.se1941jv.pls.service;

import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.LessonProgress;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.LessonProgressRepository;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.repository.PackageRepository;
import swp.se1941jv.pls.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class LessonProgressService {

    private final LessonProgressRepository lessonProgressRepository;
    private final UserRepository userRepository;
    private final LessonRepository lessonRepository;
    private final SubjectRepository subjectRepository;
    private final PackageRepository packageRepository;

    public LessonProgressService(LessonProgressRepository lessonProgressRepository,
                                 UserRepository userRepository,
                                 LessonRepository lessonRepository,
                                 SubjectRepository subjectRepository,
                                 PackageRepository packageRepository) {
        this.lessonProgressRepository = lessonProgressRepository;
        this.userRepository = userRepository;
        this.lessonRepository = lessonRepository;
        this.subjectRepository = subjectRepository;
        this.packageRepository = packageRepository;
    }

    public LessonProgress saveProgress(Long userId, Long lessonId, Long subjectId, Long packageId,
                                       Integer watchedTime, Boolean isCompleted) {
        if (userId == null || lessonId == null || subjectId == null || packageId == null) {
            throw new IllegalArgumentException("userId, lessonId, subjectId, và packageId không được để trống");
        }
        if (watchedTime == null || isCompleted == null) {
            throw new IllegalArgumentException("watchedTime và isCompleted không được để trống");
        }

        // Kiểm tra sự tồn tại của User, Lesson, Subject, Package
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng với id: " + userId));
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài học với id: " + lessonId));
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy môn học với id: " + subjectId));
        Package packageEntity = packageRepository.findById(packageId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy gói học với id: " + packageId));

        Optional<LessonProgress> existing = lessonProgressRepository.findByUserAndLessonAndSubjectAndPackageEntity(user, lesson, subject, packageEntity);
        LessonProgress progress;

        if (existing.isPresent()) {
            progress = existing.get();
            if (Boolean.TRUE.equals(progress.getIsCompleted())) {
                return progress; // Không cập nhật nếu đã hoàn thành
            }
            if (Boolean.TRUE.equals(isCompleted) && !Boolean.TRUE.equals(progress.getIsCompleted())) {
                progress.setWatchedTime(watchedTime);
                progress.setIsCompleted(isCompleted);
            } else if (progress.getWatchedTime() >= watchedTime) {
                return progress; // Không cập nhật nếu thời gian mới nhỏ hơn hoặc bằng
            }
                progress.setWatchedTime(watchedTime);
                progress.setIsCompleted(isCompleted);
        } else {
            progress = LessonProgress.builder()
                    .user(user)
                    .lesson(lesson)
                    .subject(subject)
                    .packageEntity(packageEntity)
                    .watchedTime(watchedTime)
                    .isCompleted(isCompleted)
                    .build();
        }

        progress.setUpdatedAt(LocalDateTime.now());
        return lessonProgressRepository.save(progress);
    }

    public Optional<LessonProgress> getProgress(Long userId, Long lessonId, Long subjectId, Long packageId) {
        if (userId == null || lessonId == null || subjectId == null || packageId == null) {
            throw new IllegalArgumentException("userId, lessonId, subjectId, và packageId không được để trống");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng với id: " + userId));
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài học với id: " + lessonId));
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy môn học với id: " + subjectId));
        Package packageEntity = packageRepository.findById(packageId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy gói học với id: " + packageId));

        return lessonProgressRepository.findByUserAndLessonAndSubjectAndPackageEntity(user, lesson, subject, packageEntity);
    }
}