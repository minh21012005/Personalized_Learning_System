package swp.se1941jv.pls.controller.client.lesson;

import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.dto.response.LessonProgressDTO;
import swp.se1941jv.pls.entity.LessonProgress;
import swp.se1941jv.pls.service.LessonProgressService;

@Slf4j
@RestController
@RequestMapping("/api/lesson-progress")
public class LessonProgressController {

    @Autowired
    private LessonProgressService progressService;

    /**
     * Lưu tiến trình học tập của người dùng.
     * @param progress DTO chứa thông tin tiến trình.
     * @return ResponseEntity chứa DTO đã lưu hoặc lỗi.
     */
    @PreAuthorize("hasAnyRole('STUDENT')")
    @PostMapping("/save")
    public ResponseEntity<LessonProgressDTO> saveProgress(@Valid @RequestBody LessonProgressDTO progress) {
        log.info("Saving progress for userId: {}, lessonId: {}", progress.getUserId(), progress.getLessonId());
        try {
            LessonProgress saved = progressService.saveProgress(
                    progress.getUserId(),
                    progress.getLessonId(),
                    progress.getSubjectId(),
                    progress.getPackageId(),
                    progress.getWatchedTime(),
                    progress.getIsCompleted()
            );
            LessonProgressDTO responseDTO = mapToDTO(saved);
            log.info("Progress saved successfully for lessonId: {}", progress.getLessonId());
            return ResponseEntity.ok(responseDTO);
        } catch (Exception e) {
            log.error("Error saving progress for lessonId: {}: {}", progress.getLessonId(), e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Lấy tiến trình học tập của người dùng.
     * @param userId ID người dùng.
     * @param lessonId ID bài học.
     * @param subjectId ID môn học.
     * @param packageId ID gói học.
     * @return ResponseEntity chứa DTO tiến trình hoặc lỗi.
     */
    @PreAuthorize("hasAnyRole('STUDENT')")
    @GetMapping
    public ResponseEntity<LessonProgressDTO> getProgress(
            @RequestParam Long userId,
            @RequestParam Long lessonId,
            @RequestParam Long subjectId,
            @RequestParam Long packageId) {
        log.info("Fetching progress for userId: {}, lessonId: {}", userId, lessonId);
        try {
            return progressService.getProgress(userId, lessonId, subjectId, packageId)
                    .map(progress -> {
                        LessonProgressDTO dto = mapToDTO(progress);
                        log.info("Progress fetched successfully for lessonId: {}", lessonId);
                        return ResponseEntity.ok(dto);
                    })
                    .orElseGet(() -> {
                        log.warn("No progress found for lessonId: {}", lessonId);
                        return ResponseEntity.notFound().build();
                    });
        } catch (Exception e) {
            log.error("Error fetching progress for lessonId: {}: {}", lessonId, e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Chuyển đổi entity sang DTO.
     * @param progress Entity LessonProgress.
     * @return LessonProgressDTO.
     */
    private LessonProgressDTO mapToDTO(LessonProgress progress) {
        return LessonProgressDTO.builder()
                .id(progress.getId())
                .userId(progress.getUser().getUserId())
                .lessonId(progress.getLesson().getLessonId())
                .subjectId(progress.getSubject().getSubjectId())
                .packageId(progress.getPackageEntity().getPackageId())
                .watchedTime(progress.getWatchedTime())
                .isCompleted(progress.getIsCompleted())
                .build();
    }
}