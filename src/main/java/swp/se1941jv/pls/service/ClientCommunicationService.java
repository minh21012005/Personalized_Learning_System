package swp.se1941jv.pls.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.CommunicationResponseDto;
import swp.se1941jv.pls.entity.Communication;
import swp.se1941jv.pls.entity.Communication.CommentStatus;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.repository.CommunicationRepository;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.dto.request.CreateCommunicationRequest;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ClientCommunicationService {
    private final CommunicationRepository communicationRepository;
    private final LessonRepository lessonRepository;

    @Transactional
    public List<CommunicationResponseDto> getApprovedCommentsForLesson(Long lessonId) {
        List<Communication> rootComments = communicationRepository.findApprovedRootCommentByLessonId(lessonId);
        rootComments.forEach(this::loadAndFilterApprovedReplies);
        Long currentUserId = SecurityUtils.getCurrentUserId();
        return rootComments.stream()
                .map(comment -> CommunicationResponseDto.fromEntity(comment, currentUserId))
                .collect(Collectors.toList());
    }

    @Transactional
    public CommunicationResponseDto postNewComment(CreateCommunicationRequest request) {
    Long lessonId = request.getLessonId();
    String content = request.getContent();
    Long parentId = request.getParentId();


    Lesson lesson = lessonRepository.findById(lessonId)
            .orElseThrow(() -> new NoSuchElementException("Lesson not found with id: " + lessonId));

    Communication newComm = new Communication();
    newComm.setLesson(lesson);
    newComm.setContent(content);


    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    boolean isPrivilegedUser = false;
    if (authentication != null && authentication.isAuthenticated()) {
        List<String> privilegedRoles = Arrays.asList("ROLE_ADMIN", "ROLE_CONTENT_MANAGER");
        isPrivilegedUser = authentication.getAuthorities().stream()
                .map(auth -> auth.getAuthority())
                .anyMatch(privilegedRoles::contains);
    }
    newComm.setCommentStatus(isPrivilegedUser ? CommentStatus.APPROVED : CommentStatus.PENDING);


    if (parentId != null) {
        Communication parentComm = communicationRepository.findById(parentId)
                .orElseThrow(() -> new NoSuchElementException("Parent comment not found with id: " + parentId));
        newComm.setParentComment(parentComm);
    }

    Communication savedComm = communicationRepository.save(newComm);
    return CommunicationResponseDto.fromEntity(savedComm, SecurityUtils.getCurrentUserId());
    }

    @Transactional
    public void deleteOwnComment(Long commentId) {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("User must be logged in to delete comments.");
        }
        Communication comment = communicationRepository.findById(commentId)
                .orElseThrow(() -> new NoSuchElementException("Comment not found with id: " + commentId));

        if (!comment.getUserCreated().equals(currentUserId)) {
            throw new SecurityException("User does not have permission to delete this comment.");
        }
        communicationRepository.delete(comment);
    }

    private void loadAndFilterApprovedReplies(Communication comment) {
        if (comment.getReplies() == null || comment.getReplies().isEmpty()) {
            return;
        }

        List<Communication> approvedReplies = comment.getReplies().stream()
                .filter(reply -> reply.getCommentStatus() == CommentStatus.APPROVED)
                .collect(Collectors.toList());

        comment.setReplies(approvedReplies);

        for (Communication reply : comment.getReplies()) {
            loadAndFilterApprovedReplies(reply);
        }
    }
}
