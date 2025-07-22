package swp.se1941jv.pls.service;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import org.hibernate.Hibernate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.CommunicationResponseDto;
import org.springframework.data.domain.PageImpl;
import swp.se1941jv.pls.entity.Communication;
import swp.se1941jv.pls.entity.Communication.CommentStatus;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.CommunicationRepository;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.repository.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.GrantedAuthority;


import java.util.NoSuchElementException;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Comparator;
import java.util.Map;
import java.util.HashMap;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;
import java.util.Arrays;

@Service
@RequiredArgsConstructor
public class CommunicationService {

    @Getter
    @AllArgsConstructor
    public static class HubStatistics {
        private long total;
        private long pending;
        private long approved;
        private long rejected;
        private long hidden;
    }


    @Transactional(readOnly = true)
    public HubStatistics getHubStatistics() {
        long total = communicationRepository.countRootCommunications(null, null,null, null);
        long pending = communicationRepository.countRootCommunications(CommentStatus.PENDING, null, null, null);
        long approved = communicationRepository.countRootCommunications(CommentStatus.APPROVED, null, null, null);
        long rejected = communicationRepository.countRootCommunications(CommentStatus.REJECTED, null, null, null);
        long hidden = communicationRepository.countRootCommunications(CommentStatus.HIDDEN, null, null, null);
        return new HubStatistics(total, pending, approved, rejected, hidden);
    }

    private final CommunicationRepository communicationRepository;
    private final LessonRepository lessonRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public Page<CommunicationResponseDto> getAllRootCommunications(CommentStatus status,String keyword,LocalDateTime startDate, LocalDateTime endDate, int page, int size) {
        System.out.println("SERVICE: Processing getAllRootCommunications for page = " + page);

        Sort sort = Sort.by(Sort.Direction.DESC, "lastActivityAt")
                    .and(Sort.by(Sort.Direction.DESC, "id"));

        Pageable pageable = PageRequest.of(page, size, sort);

        Page<Long> rootIdsPage;
        if(keyword != null && !keyword.trim().isEmpty()){
            rootIdsPage = communicationRepository.findRootCommunicationIdsWithKeywordSearch(status, keyword, startDate, endDate, pageable);
        } else {
            rootIdsPage = communicationRepository.findRootCommunicationIds(status,null,startDate, endDate,pageable);
        }

        List<Long> rootIdsOnCurrentPage = rootIdsPage.getContent();

        System.out.println("SERVICE: Found " + rootIdsOnCurrentPage.size() + " IDs for page " + page + ". Total elements in DB: " + rootIdsPage.getTotalElements());

        if (rootIdsOnCurrentPage.isEmpty()) {
            return Page.empty(pageable);
        }
        List<Communication> rootCommunications = communicationRepository.findByIdsWithDetails(rootIdsOnCurrentPage);

        rootCommunications.forEach(this::initializeAllReplies);

        Comparator<Communication> stableComparator = Comparator
            .comparing(Communication::getLastActivityAt, Comparator.reverseOrder())
            .thenComparing(Communication::getId, Comparator.reverseOrder());
    rootCommunications.sort(stableComparator);

        Long currentUserId = SecurityUtils.getCurrentUserId();
        List<CommunicationResponseDto> dtoList = rootCommunications.stream()
                .map(comm -> CommunicationResponseDto.fromEntity(comm, currentUserId))
                .collect(Collectors.toList());

         System.out.println("SERVICE: Creating PageImpl with page number = " + pageable.getPageNumber() + " and total elements = " + rootIdsPage.getTotalElements());
        System.out.println("==========================================================");
        return new PageImpl<>(dtoList, pageable, rootIdsPage.getTotalElements());
    }

    private void initializeAllReplies(Communication comment) {
        if (comment.getReplies() == null || comment.getReplies().isEmpty()) {
            return;
        }
        Hibernate.initialize(comment.getReplies());
        for (Communication reply : comment.getReplies()) {
            initializeAllReplies(reply);
        }
    }

    @Transactional
    public CommunicationResponseDto createCommunication(Long lessonId, String content, Long parentId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new NoSuchElementException("Lesson not found with id: " + lessonId));

        Communication newComm = new Communication();
        newComm.setLesson(lesson);
        newComm.setContent(content);

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        boolean isPrivilegedUser = false;

        if(authentication != null && authentication.isAuthenticated()){
            List<String> privilegedRoles = Arrays.asList("ROLE_ADMIN","ROLE_CONTENT_MANAGER");
        isPrivilegedUser = authentication.getAuthorities().stream()
        .map(GrantedAuthority::getAuthority)
        .anyMatch(privilegedRoles::contains);
        }

        if(isPrivilegedUser){
            newComm.setCommentStatus(CommentStatus.APPROVED);
        } else {
            newComm.setCommentStatus(CommentStatus.PENDING);
        }

        if (parentId != null) {
            Communication parentComm = communicationRepository.findById(parentId)
                    .orElseThrow(() -> new NoSuchElementException("Parent communication not found with id: " + parentId));
            newComm.setParentComment(parentComm);
            Communication rootComm = findRootComment(parentComm);
            rootComm.setLastActivityAt(LocalDateTime.now());
        }
        Communication savedComm = communicationRepository.save(newComm);
        Long currentUserId = SecurityUtils.getCurrentUserId();

        Communication fullCommunication = communicationRepository.findByIdWithDetails(savedComm.getId())
                .orElseThrow(() -> new IllegalStateException("Could not find newly created communication with details"));

        if (fullCommunication.getUser() == null && fullCommunication.getUserCreated() != null) {
             User author = userRepository.findById(fullCommunication.getUserCreated()).orElse(null);
             fullCommunication.setUser(author);
        }
        return CommunicationResponseDto.fromEntity(fullCommunication, currentUserId);
    }

    @Transactional
    public void deleteCommunicationByAdmin(Long communicationId) {
        if (communicationRepository.existsById(communicationId)) {
            communicationRepository.deleteById(communicationId);
        }
    }

    @Transactional
    public void updateCommentStatus(Long communicationId, CommentStatus newStatus) {
        Communication com = communicationRepository.findById(communicationId)
        .orElseThrow(() -> new NoSuchElementException("Communication not found with id: " + communicationId));
        com.setCommentStatus(newStatus);
    }

    private Communication findRootComment(Communication comment) {
    Communication current = comment;
    while (current.getParentComment() != null) {
        current = current.getParentComment();
    }
    return current;
   }
}