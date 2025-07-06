package swp.se1941jv.pls.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.CommunicationResponseDto;
import swp.se1941jv.pls.entity.Communication;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.repository.CommunicationRepository;
import swp.se1941jv.pls.repository.LessonRepository;

import java.util.Collections;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommunicationService {

    private final CommunicationRepository communicationRepository;
    private final LessonRepository lessonRepository;

    @Transactional(readOnly = true)
    public List<CommunicationResponseDto> getCommunicationsForLesson(Long lessonId) {
        List<Communication> rootCommunications = communicationRepository.findRootCommunicationsByLessonId(lessonId);
        Long currentUserId = SecurityUtils.getCurrentUserId();
        return rootCommunications.stream()
                .map(communication -> CommunicationResponseDto.fromEntity(communication, currentUserId))
                .collect(Collectors.toList());
    }

    @Transactional
    public CommunicationResponseDto createCommunication(Long lessonId, String content, Long parentId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new NoSuchElementException("Lesson not found with id: " + lessonId));

        Communication newComm = new Communication();
        newComm.setLesson(lesson);
        newComm.setContent(content);

        if (parentId != null) {
            Communication parentComm = communicationRepository.findById(parentId)
                    .orElseThrow(
                            () -> new NoSuchElementException("Parent communication not found with id: " + parentId));
            newComm.setParentComment(parentComm);
        }

        Communication savedComm = communicationRepository.save(newComm);
        Long currentUserId = SecurityUtils.getCurrentUserId();

        return communicationRepository.findByIdWithDetails(savedComm.getId())
                .map(fullCommunication -> CommunicationResponseDto.fromEntity(fullCommunication, currentUserId))
                .orElseThrow(() -> new IllegalStateException("Could not find and map newly created communication"));
    }

    @Transactional(readOnly = true)
    public List<CommunicationResponseDto> getAllRootCommunications() {
        List<Long> rootIds = communicationRepository.findAllRootCommunicationIds();

        if (rootIds.isEmpty()) {
            return Collections.emptyList();
        }

        List<Communication> allRootCommunications = communicationRepository.findAllByIdsWithDetails(rootIds);
        Long currentUserId = SecurityUtils.getCurrentUserId();

        return allRootCommunications.stream()
                .map(comm -> CommunicationResponseDto.fromEntity(comm, currentUserId))
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteCommunicationByAdmin(long communicationId) {
        Communication comm = communicationRepository.findById(communicationId)
                .orElseThrow(() -> new NoSuchElementException("Communication not found"));
        deleteRecursively(comm);
    }

    private void deleteRecursively(Communication comm) {
        if (comm.getReplies() != null) {
            for (Communication reply : comm.getReplies()) {
                deleteRecursively(reply);
            }
        }
        communicationRepository.delete(comm);
    }

}