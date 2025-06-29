package swp.se1941jv.pls.controller.admin;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.dto.request.CreateCommunicationRequest;
import swp.se1941jv.pls.dto.response.CommunicationResponseDto;
import swp.se1941jv.pls.entity.Communication;
import swp.se1941jv.pls.service.CommunicationService;

import java.util.List;

@RestController
@RequestMapping("/api/communications")
@RequiredArgsConstructor
public class CommunicationApiController {

    private final CommunicationService communicationService;

    @GetMapping("/lesson/{lessonId}")
    public ResponseEntity<List<CommunicationResponseDto>> getCommunicationsByLesson(@PathVariable Long lessonId) {
        List<CommunicationResponseDto> communications = communicationService.getCommunicationsForLesson(lessonId);
        return ResponseEntity.ok(communications);
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

    @GetMapping("/hub")
    public ResponseEntity<List<CommunicationResponseDto>> getHubCommunications() {
        List<CommunicationResponseDto> communications = communicationService.getAllRootCommunications();
        return ResponseEntity.ok(communications);
    }

    @DeleteMapping("/{communicationId}")
    public ResponseEntity<Void> deleteCommunication(@PathVariable Long communicationId) {
        return ResponseEntity.noContent().build();
    }
}
