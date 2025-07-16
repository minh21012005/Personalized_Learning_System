package swp.se1941jv.pls.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.chapter.ChapterFormDTO;
import swp.se1941jv.pls.dto.response.chapter.ChapterListDTO;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.SubjectAssignment;
import swp.se1941jv.pls.entity.SubjectStatusHistory;
import swp.se1941jv.pls.repository.ChapterRepository;
import swp.se1941jv.pls.repository.SubjectAssignmentRepository;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.repository.SubjectStatusHistoryRepository;
import swp.se1941jv.pls.service.specification.ChapterSpecifications;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChapterService {

    private final ChapterRepository chapterRepository;
    private final SubjectRepository subjectRepository;
    private final SubjectAssignmentRepository subjectAssignmentRepository;
    private final SubjectStatusHistoryRepository statusHistoryRepository;
    private final UserService userService;
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");

    /**
     * Tạo chương mới từ entity.
     */
    @Transactional
    public void createChapter(ChapterFormDTO dto, Long userId) {
        validateStaffAccess(dto.getSubjectId(), userId);
        if (chapterRepository.existsByChapterNameAndSubject_SubjectId(dto.getChapterName(), dto.getSubjectId())) {
            throw new IllegalArgumentException("chapter.name.exists");
        }

        Chapter chapter = toChapterEntity(dto);
        chapter.setStatus(false);
        chapter.setUserCreated(userId);
        chapter.setCreatedAt(LocalDateTime.now());
        chapterRepository.save(chapter);

        // Kiểm tra và cập nhật trạng thái subject nếu là REJECTED
        updateSubjectStatusIfRejected(dto.getSubjectId());
    }

    @Transactional
    public void updateChapter(ChapterFormDTO dto, Long userId) {
        validateStaffAccess(dto.getSubjectId(), userId);
        Chapter chapter = chapterRepository.findById(dto.getChapterId())
                .orElseThrow(() -> new IllegalArgumentException("chapter.message.notFound"));

        if (!chapter.getSubject().getSubjectId().equals(dto.getSubjectId())) {
            throw new IllegalArgumentException("chapter.message.invalidSubject");
        }
        if (!chapter.getChapterName().equals(dto.getChapterName()) &&
                chapterRepository.existsByChapterNameAndSubject_SubjectId(dto.getChapterName(), dto.getSubjectId())) {
            throw new IllegalArgumentException("chapter.name.exists");
        }

        chapter.setChapterName(dto.getChapterName());
        chapter.setChapterDescription(dto.getChapterDescription());
        chapter.setUpdatedAt(LocalDateTime.now());
        chapterRepository.save(chapter);

        // Kiểm tra và cập nhật trạng thái subject nếu là REJECTED
        updateSubjectStatusIfRejected(dto.getSubjectId());
    }

    @Transactional
    public void deleteChapter(Long chapterId, Long userId) {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new IllegalArgumentException("chapter.message.notFound"));
        validateStaffAccess(chapter.getSubject().getSubjectId(), userId);

        // Kiểm tra và cập nhật trạng thái subject nếu là REJECTED
        updateSubjectStatusIfRejected(chapter.getSubject().getSubjectId());

        chapterRepository.deleteById(chapterId);
    }

    /**
     * Lấy thông tin chương theo ID dưới dạng entity.
     */
    public Optional<Chapter> getChapterById(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new IllegalArgumentException("ID chương không hợp lệ.");
        }
        return chapterRepository.findById(chapterId);
    }

    public Page<ChapterListDTO> findChaptersBySubjectId(Long subjectId, String chapterName, Boolean status, Long userId, Pageable pageable) {
        Optional<SubjectAssignment> assignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        if (assignment.isEmpty() || !assignment.get().getUser().getUserId().equals(userId)) {
            throw new IllegalArgumentException("subject.message.notAssigned");
        }
        Specification<Chapter> spec = Specification.where(ChapterSpecifications.hasSubjectId(subjectId));
        if (chapterName != null && !chapterName.trim().isEmpty()) {
            spec = spec.and(ChapterSpecifications.hasName(chapterName));
        }
        if (status != null) {
            spec = spec.and(ChapterSpecifications.hasStatus(status));
        }

        return chapterRepository.findAll(spec, pageable).map(this::toChapterResponseDTO);
    }

    public void validateStaffAccess(Long subjectId, Long userId) {
        Optional<SubjectAssignment> assignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        if (assignment.isEmpty() || !assignment.get().getUser().getUserId().equals(userId)) {
            throw new IllegalArgumentException("Bạn không được phân công cho môn học này.");
        }
        Optional<SubjectStatusHistory> status = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (status.isEmpty() || (status.get().getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT && status.get().getStatus() != SubjectStatusHistory.SubjectStatus.REJECTED)) {
            throw new IllegalArgumentException("Môn học không ở trạng thái DRAFT hoặc REJECTED để chỉnh sửa.");
        }
    }

    private Chapter toChapterEntity(ChapterFormDTO dto) {
        Subject subject = subjectRepository.findById(dto.getSubjectId())
                .orElseThrow(() -> new IllegalArgumentException("subject.message.notFound"));
        return Chapter.builder()
                .chapterId(dto.getChapterId())
                .chapterName(dto.getChapterName())
                .chapterDescription(dto.getChapterDescription())
                .subject(subject)
                .build();
    }

    private ChapterListDTO toChapterResponseDTO(Chapter chapter) {
        return ChapterListDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .status(chapter.getStatus())
                .subjectName(chapter.getSubject().getSubjectName())
                .userCreated(chapter.getUserCreated())
                .userFullName(chapter.getUserCreated() != null ? userService.getUserFullName(chapter.getUserCreated()) : null)
                .createdAt(chapter.getCreatedAt() != null ? chapter.getCreatedAt().format(formatter) : null)
                .build();
    }

    private void updateSubjectStatusIfRejected(Long subjectId) {
        Optional<SubjectStatusHistory> status = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (status.isPresent() && status.get().getStatus() == SubjectStatusHistory.SubjectStatus.REJECTED) {
            SubjectStatusHistory updatedStatus = status.get();
            updatedStatus.setStatus(SubjectStatusHistory.SubjectStatus.DRAFT);
            statusHistoryRepository.save(updatedStatus);
        }
    }
}