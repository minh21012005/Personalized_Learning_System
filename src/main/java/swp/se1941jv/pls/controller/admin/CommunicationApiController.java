package swp.se1941jv.pls.controller.admin;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import swp.se1941jv.pls.dto.request.UpdateStatusRequest;
import swp.se1941jv.pls.dto.request.CreateCommunicationRequest;
import swp.se1941jv.pls.dto.response.CommunicationResponseDto;
import swp.se1941jv.pls.entity.Communication.CommentStatus;
import swp.se1941jv.pls.service.CommunicationService;
import swp.se1941jv.pls.service.CommunicationService.HubStatistics;

@RestController
@RequestMapping("/api/communications")
@RequiredArgsConstructor
public class CommunicationApiController {

    private final CommunicationService communicationService;

    @GetMapping("/hub")
    public ResponseEntity<Page<CommunicationResponseDto>> getHubCommunications(
            @RequestParam(name = "status", required = false) CommentStatus status,
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "5") int size) {
        Page<CommunicationResponseDto> pagedResponse = communicationService.getAllRootCommunications(status, keyword, page, size);
        return ResponseEntity.ok(pagedResponse);
    }

    @PostMapping("/lesson/{lessonId}")
    public ResponseEntity<CommunicationResponseDto> postNewCommunication(
            @PathVariable Long lessonId,
            @Valid @RequestBody CreateCommunicationRequest request) {

        CommunicationResponseDto newCommunication = communicationService.createCommunication(
                lessonId,
                request.getContent(),
                request.getParentId()
        );
        return new ResponseEntity<>(newCommunication, HttpStatus.CREATED);
    }

    @DeleteMapping("/{communicationId}")
    public ResponseEntity<Void> deleteCommunication(@PathVariable Long communicationId) {
        communicationService.deleteCommunicationByAdmin(communicationId);
        return ResponseEntity.noContent().build();
    }

     @PutMapping("/{communicationId}/status")
     public ResponseEntity<Void> updateStatus(
        @PathVariable Long communicationId,
        @RequestBody UpdateStatusRequest request){
            communicationService.updateCommentStatus(communicationId, request.getCommentStatus());
            return ResponseEntity.ok().build();
     }

     @GetMapping("/hub/statistics")
     public ResponseEntity<HubStatistics> getStatistics() {
        HubStatistics stats = communicationService.getHubStatistics();
        return ResponseEntity.ok(stats);
    }
}