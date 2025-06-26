package swp.se1941jv.pls.controller.client.lesson;

import swp.se1941jv.pls.dto.response.LessonProgressDTO;
import swp.se1941jv.pls.entity.LessonProgress;
import swp.se1941jv.pls.service.LessonProgressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/lesson-progress")
public class LessonProgressController {
    @Autowired
    private LessonProgressService service;

    @PostMapping("/save")
    public ResponseEntity<LessonProgress> saveProgress(@RequestBody LessonProgressDTO progress) {
        LessonProgress saved = service.saveProgress(
                progress.getUserId(),
                progress.getLessonId(),
                progress.getWatchedTime(),
                progress.getIsCompleted()
        );
        return ResponseEntity.ok(saved);
    }

    @GetMapping
    public ResponseEntity<LessonProgress> getProgress(@RequestParam Long userId, @RequestParam Long lessonId) {
        return service.getProgress(userId, lessonId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
