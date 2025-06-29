package swp.se1941jv.pls.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Builder;
import lombok.Data;
import swp.se1941jv.pls.entity.Communication;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;


@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class CommunicationResponseDto {
    private Long id;
    private String content;
    private String subjectName;
    private String lessonName;
    private AuthorResponseDTO author;
    private LocalDateTime createdAt;
    private List<CommunicationResponseDto> replies;
    private boolean isOwner;
    private Long lessonId;

    public static CommunicationResponseDto fromEntity(Communication communication, Long currentUserId) {
        if (communication == null) {
            return null;
        }

        List<CommunicationResponseDto> replyDtos = (communication.getReplies() != null) ?
                communication.getReplies().stream()
                        .map(reply -> CommunicationResponseDto.fromEntity(reply, currentUserId))
                        .collect(Collectors.toList()) :
                Collections.emptyList();

        boolean isOwner = (communication.getUserCreated() != null && communication.getUserCreated().equals(currentUserId));

        return CommunicationResponseDto.builder()
                .id(communication.getId())
                .content(communication.getContent())
                .subjectName(communication.getLesson().getChapter().getSubject().getSubjectName())
                .lessonId(communication.getLesson().getLessonId())
                .lessonName(communication.getLesson().getLessonName())
                .author(AuthorResponseDTO.fromEntity(communication.getUser()))
                .createdAt(communication.getCreatedAt())
                .replies(replyDtos)
                .isOwner(isOwner)
                .build();
    }

}
