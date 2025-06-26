package swp.se1941jv.pls.controller.client.lesson;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.dto.response.LessonProgressDTO;
import swp.se1941jv.pls.entity.LessonProgress;
import swp.se1941jv.pls.service.LessonProgressService;

@RestController
@RequestMapping("/api/lesson-progress")
public class LessonProgressController {
    @Autowired
    private LessonProgressService progressService;

    @PreAuthorize("hasAnyRole('STUDENT')")
    @PostMapping("/save")
    public ResponseEntity<LessonProgressDTO> saveProgress(@RequestBody LessonProgressDTO progress) {
        if (progress.getUserId() == null || progress.getLessonId() == null ||
                progress.getSubjectId() == null || progress.getPackageId() == null ||
                progress.getWatchedTime() == null || progress.getIsCompleted() == null) {
            return ResponseEntity.badRequest().build();
        }

        LessonProgress saved = progressService.saveProgress(
                progress.getUserId(),
                progress.getLessonId(),
                progress.getSubjectId(),
                progress.getPackageId(),
                progress.getWatchedTime(),
                progress.getIsCompleted()
        );
        LessonProgressDTO responseDTO = LessonProgressDTO.builder()
                .id(saved.getId())
                .userId(saved.getUser().getUserId())
                .lessonId(saved.getLesson().getLessonId())
                .subjectId(saved.getSubject().getSubjectId())
                .packageId(saved.getPackageEntity().getPackageId())
                .watchedTime(saved.getWatchedTime())
                .isCompleted(saved.getIsCompleted())
                .build();
        return ResponseEntity.ok(responseDTO);
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    @GetMapping
    public ResponseEntity<LessonProgressDTO> getProgress(
            @RequestParam Long userId,
            @RequestParam Long lessonId,
            @RequestParam Long subjectId,
            @RequestParam Long packageId) {
        if (userId == null || lessonId == null || subjectId == null || packageId == null) {
            return ResponseEntity.badRequest().build();
        }

        return progressService.getProgress(userId, lessonId, subjectId, packageId)
                .map(progress -> ResponseEntity.ok(
                        LessonProgressDTO.builder()
                                .id(progress.getId())
                                .userId(progress.getUser().getUserId())
                                .lessonId(progress.getLesson().getLessonId())
                                .subjectId(progress.getSubject().getSubjectId())
                                .packageId(progress.getPackageEntity().getPackageId())
                                .watchedTime(progress.getWatchedTime())
                                .isCompleted(progress.getIsCompleted())
                                .build()
                ))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}