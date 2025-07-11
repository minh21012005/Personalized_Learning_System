package swp.se1941jv.pls.service;

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
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.CommunicationRepository;
import swp.se1941jv.pls.repository.LessonRepository;
import swp.se1941jv.pls.repository.UserRepository;

import java.util.Collections;
import java.util.List;
import java.util.Comparator;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommunicationService {

    private final CommunicationRepository communicationRepository;
    private final LessonRepository lessonRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public Page<CommunicationResponseDto> getAllRootCommunications(int page, int size) {
        System.out.println("SERVICE: Processing getAllRootCommunications for page = " + page);
        // Bước 1: Tạo đối tượng Pageable cho request hiện tại.
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());

        // Bước 2: Lấy trang các ID. `rootIdsPage` chứa thông tin phân trang chính xác (totalPages, totalElements).
        Page<Long> rootIdsPage = communicationRepository.findRootCommunicationIds(pageable);
        List<Long> rootIdsOnCurrentPage = rootIdsPage.getContent();

        System.out.println("SERVICE: Found " + rootIdsOnCurrentPage.size() + " IDs for page " + page + ". Total elements in DB: " + rootIdsPage.getTotalElements());
        
        // Bước 3: Nếu trang hiện tại không có ID nào, trả về một trang DTO rỗng nhưng vẫn giữ thông tin phân trang.
        if (rootIdsOnCurrentPage.isEmpty()) {
            return Page.empty(pageable);
        }

        // Bước 4: Lấy toàn bộ thông tin chi tiết của các comment có ID thuộc trang hiện tại.
        List<Communication> rootCommunications = communicationRepository.findByIdsWithDetails(rootIdsOnCurrentPage);
        
        // Bước 5: "Làm đầy" cây reply cho từng comment.
        rootCommunications.forEach(this::initializeAllReplies);

        // Bước 6: Sắp xếp lại danh sách trong bộ nhớ để đảm bảo thứ tự khớp với yêu cầu `Sort.by("createdAt").descending()`.
        // Mặc dù Pageable đã sắp xếp ID, nhưng `IN (...)` có thể không giữ thứ tự, nên bước này là cần thiết.
        rootCommunications.sort(Comparator.comparing(Communication::getCreatedAt).reversed());

        // Bước 7: Chuyển đổi danh sách các Entity đã được sắp xếp sang DTO.
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

        if (parentId != null) {
            Communication parentComm = communicationRepository.findById(parentId)
                    .orElseThrow(() -> new NoSuchElementException("Parent communication not found with id: " + parentId));
            newComm.setParentComment(parentComm);
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
}