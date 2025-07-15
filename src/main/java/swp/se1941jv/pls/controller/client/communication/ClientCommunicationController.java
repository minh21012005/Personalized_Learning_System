package swp.se1941jv.pls.controller.client.communication;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.dto.request.CreateCommunicationRequest;
import swp.se1941jv.pls.dto.response.CommunicationResponseDto;
import swp.se1941jv.pls.service.ClientCommunicationService;

import java.util.List;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
public class ClientCommunicationController {
    private final ClientCommunicationService clientCommunicationService;

    // Endpoint để client lấy các bình luận đã được duyệt của một bài học
    @GetMapping("/lesson/{lessonId}")
    public ResponseEntity<List<CommunicationResponseDto>> getApprovedCommentsForLesson(@PathVariable Long lessonId) {
        List<CommunicationResponseDto> comments = clientCommunicationService.getApprovedCommentsForLesson(lessonId);
        return ResponseEntity.ok(comments);
    }

    // Endpoint để client (đã đăng nhập) đăng bình luận mới
    @PostMapping("/add")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<CommunicationResponseDto> postNewComment(
            @RequestBody CreateCommunicationRequest request) {

        CommunicationResponseDto newComment = clientCommunicationService.postNewComment(request);

        return ResponseEntity.status(201).body(newComment);
    }

    // Endpoint để client tự xóa bình luận của mình
    @DeleteMapping("/{commentId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> deleteOwnComment(@PathVariable Long commentId) {
        clientCommunicationService.deleteOwnComment(commentId);
        return ResponseEntity.noContent().build();
    }
}