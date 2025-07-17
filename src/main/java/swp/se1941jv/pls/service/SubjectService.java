package swp.se1941jv.pls.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.*;
import java.util.stream.Collectors;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.dto.response.learningPageData.LearningChapterDTO;
import swp.se1941jv.pls.dto.response.learningPageData.LearningLessonDTO;
import swp.se1941jv.pls.dto.response.learningPageData.LearningPageDataDTO;
import swp.se1941jv.pls.dto.response.learningPageData.LearningTestDTO;
import swp.se1941jv.pls.dto.response.subject.*;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.repository.*;

@Service
public class SubjectService {
    private final SubjectRepository subjectRepository;
    private final SubjectAssignmentRepository subjectAssignmentRepository;
    private final SubjectStatusHistoryRepository statusHistoryRepository;
    private final UserRepository userRepository;
    private final ChapterRepository chapterRepository;
    private final LessonRepository lessonRepository;
    private final UserPackageRepository userPackageRepository;
    private final PackageSubjectRepository packageSubjectRepository;
    private final LessonProgressRepository lessonProgressRepository;
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
    private final UserTestRepository userTestRepository;
    private final TestRepository testRepository;

    public SubjectService(SubjectRepository subjectRepository,
                          SubjectAssignmentRepository subjectAssignmentRepository,
                          SubjectStatusHistoryRepository statusHistoryRepository, UserRepository userRepository,
                           ChapterRepository chapterRepository, LessonRepository lessonRepository,
                          UserPackageRepository userPackageRepository,
                          PackageSubjectRepository packageSubjectRepository,
                          LessonProgressRepository lessonProgressRepository,
                          UserTestRepository userTestRepository, TestRepository testRepository
    ) {
        this.subjectRepository = subjectRepository;
        this.subjectAssignmentRepository = subjectAssignmentRepository;
        this.statusHistoryRepository = statusHistoryRepository;
        this.userRepository = userRepository;
        this.chapterRepository = chapterRepository;
        this.lessonRepository = lessonRepository;
        this.userPackageRepository = userPackageRepository;
        this.packageSubjectRepository = packageSubjectRepository;
        this.lessonProgressRepository = lessonProgressRepository;
        this.userTestRepository = userTestRepository;
        this.testRepository = testRepository;
    }

    public List<Subject> getSubjectsByGradeId(Long gradeId, boolean isActive) {
        return subjectRepository.findByGradeIdAndIsActive(gradeId, isActive);
    }

    public Page<Subject> getSubjectsByGradeId(Long gradeId, boolean isActive, String keyword, Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return subjectRepository.findByGradeGradeIdAndIsActiveAndSubjectNameContainingIgnoreCase(gradeId, isActive,
                    keyword, pageable);
        }
        return subjectRepository.findByGradeGradeIdAndIsActive(gradeId, isActive, pageable);
    }

    // Lấy Subject hàng chờ
    public Page<Subject> getPendingSubjects(boolean isActive, String keyword, Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return subjectRepository.findByGradeIsNullAndIsActiveAndSubjectNameContainingIgnoreCase(isActive, keyword,
                    pageable);
        }
        return subjectRepository.findByGradeIsNullAndIsActive(isActive, pageable);
    }

    // Cập nhật gradeId cho Subject
    public void updateSubjectGrade(Long subjectId, Long gradeId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Subject not found"));
        if (gradeId != null) {
            Grade grade = new Grade();
            grade.setGradeId(gradeId);
            subject.setGrade(grade);
        } else {
            subject.setGrade(null);
        }
        subjectRepository.save(subject);
    }

    public Page<Subject> getAllSubjects(String filterName, Long filterGradeId, Pageable pageable) {
        String searchName = (filterName != null && filterName.trim().isEmpty()) ? null : filterName;
        return subjectRepository.findByFilter(searchName, filterGradeId, pageable);
    }

    public Optional<Subject> getSubjectById(Long id) {
        return subjectRepository.findById(id);
    }


    public List<Subject> findAllSubjects() {

        return subjectRepository.findAll();
    }

    public List<Subject> fetchAllSubjects() {
        return this.subjectRepository.findByIsActiveTrue();

    }

    public Optional<Subject> findById(long id) {
        return this.subjectRepository.findById(id);
    }

    @Transactional
    public void assignSubject(Long subjectId, Long userId, Long contentManagerId, String assignmentFeedback) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (latestStatus.isEmpty()) {
            throw new IllegalArgumentException("Môn học chưa có trạng thái, không thể giao!");
        }

        // Nếu môn học đang ở trạng thái PENDING, chuyển về DRAFT trước khi giao lại
        SubjectStatusHistory statusHistory = latestStatus.get();
        if (statusHistory.getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT) {
            throw new IllegalArgumentException("Chỉ có thể giao môn học ở trạng thái DRAFT!");
        }

        // Check if the request is to unassign the subject
        if (userId == null || userId == 0) {
            // Delete existing assignment if any
            Optional<SubjectAssignment> existingAssignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
            if (existingAssignment.isPresent()) {
                subjectAssignmentRepository.delete(existingAssignment.get());
            }
            return; // Exit early since no new assignment is needed
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Nhân viên không tồn tại"));

        User contentManager = userRepository.findById(contentManagerId)
                .orElseThrow(() -> new IllegalArgumentException("Người quản lý nội dung không tồn tại"));

        if (!"STAFF".equals(user.getRole().getRoleName())) {
            throw new IllegalArgumentException("Người được giao phải có vai trò STAFF!");
        }

        if (Boolean.FALSE.equals(user.getIsActive())) {
            throw new IllegalArgumentException("Nhân viên không hoạt động!");
        }

        // Xóa bản ghi giao việc cũ nếu có
        Optional<SubjectAssignment> existingAssignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        if (existingAssignment.isPresent()) {
            subjectAssignmentRepository.delete(existingAssignment.get());
        }

        // Tạo bản ghi giao việc mới
        SubjectAssignment assignment = SubjectAssignment.builder()
                .subject(subject)
                .user(user)
                .assignedBy(contentManager)
                .assignedAt(LocalDateTime.now())
                .build();

        subjectAssignmentRepository.save(assignment);
    }

    @Transactional
    public void submitForReview(Long subjectId, Long userId, String submissionFeedback) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));

        if (!"STAFF".equals(user.getRole().getRoleName())) {
            throw new IllegalArgumentException("Chỉ có STAFF mới có thể nộp duyệt môn học!");
        }

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (latestStatus.isPresent() && latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT) {
            throw new IllegalArgumentException("Chỉ có thể nộp môn học ở trạng thái DRAFT!");
        }

        Optional<SubjectAssignment> assignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        if (assignment.isEmpty() || !assignment.get().getUser().getUserId().equals(userId)) {
            throw new IllegalArgumentException("Chỉ có STAFF được giao môn học này mới có thể nộp duyệt!");
        }

        // Lọc các chương không ẩn
        List<Chapter> nonHiddenChapters = subject.getChapters().stream()
                .filter(chapter -> chapter.getIsHidden() == null || !chapter.getIsHidden())
                .collect(Collectors.toList());

        if (nonHiddenChapters.isEmpty()) {
            throw new IllegalArgumentException("Môn học phải có ít nhất một chương không ẩn!");
        }

        for (Chapter chapter : nonHiddenChapters) {
            if (!chapter.getStatus().equals(Boolean.FALSE)) {
                throw new IllegalArgumentException("Chương " + chapter.getChapterName() + " phải ở trạng thái không hoạt động trước khi nộp duyệt!");
            }
            // Lọc các bài học không ẩn
            List<Lesson> nonHiddenLessons = chapter.getLessons().stream()
                    .filter(lesson -> lesson.getIsHidden() == null || !lesson.getIsHidden())
                    .collect(Collectors.toList());
            if (nonHiddenLessons.isEmpty()) {
                throw new IllegalArgumentException("Chương " + chapter.getChapterName() + " phải có ít nhất một bài học không ẩn!");
            }
            for (Lesson lesson : nonHiddenLessons) {
                if (!lesson.getStatus().equals(Boolean.FALSE)) {
                    throw new IllegalArgumentException("Bài học " + lesson.getLessonName() + " phải ở trạng thái không hoạt động trước khi nộp duyệt!");
                }
            }
        }

        SubjectStatusHistory statusHistory;
        if (latestStatus.isPresent()) {
            statusHistory = latestStatus.get();
        } else {
            statusHistory = SubjectStatusHistory.builder()
                    .subject(subject)
                    .build();
        }

        statusHistory.setStatus(SubjectStatusHistory.SubjectStatus.PENDING);
        statusHistory.setChangedAt(LocalDateTime.now());
        statusHistory.setSubmittedBy(user);
        statusHistory.setFeedback(submissionFeedback != null && !submissionFeedback.trim().isEmpty() ?
                submissionFeedback : "Nộp duyệt bởi " + user.getFullName());
        statusHistory.setReviewer(null);
        statusHistoryRepository.save(statusHistory);

        subjectRepository.save(subject);
    }


    @Transactional
    public void reviewSubject(Long subjectId, String status, String feedback, Long reviewerId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));

        User reviewer = userRepository.findById(reviewerId)
                .orElseThrow(() -> new IllegalArgumentException("Người duyệt không tồn tại"));

        if (!"CONTENT_MANAGER".equals(reviewer.getRole().getRoleName()) && !"ADMIN".equals(reviewer.getRole().getRoleName())) {
            throw new IllegalArgumentException("Người duyệt phải có vai trò Content Manager hoặc Admin!");
        }

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.PENDING) {
            throw new IllegalArgumentException("Chỉ có thể duyệt môn học ở trạng thái PENDING!");
        }

        // Filter non-hidden chapters
        List<Chapter> nonHiddenChapters = subject.getChapters().stream()
                .filter(chapter -> chapter.getIsHidden() == null || !chapter.getIsHidden())
                .collect(Collectors.toList());

        if (nonHiddenChapters.isEmpty()) {
            throw new IllegalArgumentException("Môn học phải có ít nhất một chương không ẩn!");
        }

        for (Chapter chapter : nonHiddenChapters) {
            if (!chapter.getStatus().equals(Boolean.FALSE)) {
                throw new IllegalArgumentException("Chương " + chapter.getChapterName() + " phải ở trạng thái không hoạt động trước khi duyệt!");
            }
            // Filter non-hidden lessons
            List<Lesson> nonHiddenLessons = chapter.getLessons().stream()
                    .filter(lesson -> lesson.getIsHidden() == null || !lesson.getIsHidden())
                    .collect(Collectors.toList());
            if (nonHiddenLessons.isEmpty()) {
                throw new IllegalArgumentException("Chương " + chapter.getChapterName() + " phải có ít nhất một bài học không ẩn!");
            }
            for (Lesson lesson : nonHiddenLessons) {
                if (!lesson.getStatus().equals(Boolean.FALSE)) {
                    throw new IllegalArgumentException("Bài học " + lesson.getLessonName() + " phải ở trạng thái không hoạt động trước khi duyệt!");
                }
            }
        }

        SubjectStatusHistory.SubjectStatus newStatus = SubjectStatusHistory.SubjectStatus.valueOf(status);
        if (newStatus == SubjectStatusHistory.SubjectStatus.REJECTED && (feedback == null || feedback.trim().isEmpty())) {
            throw new IllegalArgumentException("Phải cung cấp phản hồi khi từ chối môn học!");
        }

        if (feedback != null && feedback.length() > 1000) {
            throw new IllegalArgumentException("Phản hồi không được vượt quá 1000 ký tự!");
        }

        // Cập nhật trạng thái chương và bài học nếu APPROVED
        if (newStatus == SubjectStatusHistory.SubjectStatus.APPROVED) {
            subject.setIsActive(true);

            for (Chapter chapter : nonHiddenChapters) {
                chapter.setStatus(true);
                for (Lesson lesson : chapter.getLessons()) {
                    if (lesson.getIsHidden() == null || !lesson.getIsHidden()) {
                        lesson.setStatus(true);
                    }
                }
            }
            subjectRepository.save(subject);
        }

        SubjectStatusHistory statusHistory = latestStatus.get();
        statusHistory.setStatus(newStatus);
        statusHistory.setChangedAt(LocalDateTime.now());
        statusHistory.setReviewer(reviewer);
        statusHistory.setFeedback(newStatus == SubjectStatusHistory.SubjectStatus.REJECTED ? feedback : null);
        statusHistoryRepository.save(statusHistory);
    }


    @Transactional
    public void publishSubject(Long subjectId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.APPROVED) {
            throw new IllegalArgumentException("Chỉ có thể xuất bản môn học ở trạng thái APPROVED!");
        }

        // Filter non-hidden chapters
        List<Chapter> nonHiddenChapters = subject.getChapters().stream()
                .filter(chapter -> chapter.getIsHidden() == null || !chapter.getIsHidden())
                .collect(Collectors.toList());

        if (nonHiddenChapters.isEmpty()) {
            throw new IllegalArgumentException("Môn học phải có ít nhất một chương không ẩn!");
        }

        for (Chapter chapter : nonHiddenChapters) {
            if (!chapter.getStatus()) {
                throw new IllegalArgumentException("Chương " + chapter.getChapterName() + " phải ở trạng thái hoạt động!");
            }
            // Filter non-hidden lessons
            List<Lesson> nonHiddenLessons = chapter.getLessons().stream()
                    .filter(lesson -> lesson.getIsHidden() == null || !lesson.getIsHidden())
                    .collect(Collectors.toList());
            if (nonHiddenLessons.isEmpty()) {
                throw new IllegalArgumentException("Chương " + chapter.getChapterName() + " phải có ít nhất một bài học không ẩn!");
            }
            for (Lesson lesson : nonHiddenLessons) {
                if (!lesson.getStatus()) {
                    throw new IllegalArgumentException("Bài học " + lesson.getLessonName() + " phải ở trạng thái hoạt động!");
                }
            }
        }

        subject.setIsActive(true);
        subjectRepository.save(subject);
    }


    //Lấy thông tin giao việc của một Subject để hiển thị trong danh sách.
    public Optional<SubjectAssignment> getAssignmentBySubjectId(Long subjectId) {
        return subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
    }

    //Lấy trạng thái mới nhất của Subject để hiển thị và validate.
    public Optional<SubjectStatusHistory> getLatestSubjectStatus(Long subjectId) {
        return statusHistoryRepository.findBySubjectSubjectId(subjectId);
    }

    public List<User> getStaff() {
        return userRepository.findByRole_RoleNameAndIsActive("STAFF", true);
    }

    // --- Hàm mới sử dụng DTO ---
    public Page<SubjectListDTO> getAllSubjectsWithDTO(String filterName, Long filterGradeId, Pageable pageable) {
        String searchName = (filterName != null && filterName.trim().isEmpty()) ? null : filterName;
        return subjectRepository.findByFilter(searchName, filterGradeId, pageable)
                .map(this::toSubjectListDTO);
    }

    public Page<SubjectListDTO> getPendingSubjectsWithDTO(String filterName, String submittedByName, Pageable pageable) {
        String searchName = (filterName != null && !filterName.trim().isEmpty()) ? filterName.trim() : null;
        String searchSubmittedBy = (submittedByName != null && !submittedByName.trim().isEmpty()) ? submittedByName.trim() : null;

        Page<Subject> pendingSubjects = subjectRepository.findPendingSubjects(searchName, searchSubmittedBy, pageable);
        return pendingSubjects.map(this::toSubjectListDTO);
    }

    public Optional<SubjectAssignDTO> getSubjectAssignDTOById(Long id) {
        return subjectRepository.findById(id).map(this::toSubjectAssignDTO);
    }

    public Optional<SubjectReviewDTO> getSubjectReviewDTOById(Long id) {
        Optional<Subject> subjectOpt = subjectRepository.findById(id);
        Optional<SubjectStatusHistory> statusOpt = statusHistoryRepository.findBySubjectSubjectId(id);
        if (subjectOpt.isPresent() && statusOpt.isPresent()) {
            return Optional.of(toSubjectReviewDTO(subjectOpt.get(), statusOpt.get()));
        }
        return Optional.empty();
    }

    public List<UserAssignDTO> getStaffWithDTO() {
        return userRepository.findByRole_RoleNameAndIsActive("STAFF", true)
                .stream()
                .map(this::toUserAssignDTO)
                .collect(Collectors.toList());
    }

    public Optional<SubjectFormDTO> getSubjectFormDTOById(Long id) {
        return subjectRepository.findById(id).map(this::toSubjectFormDTO);
    }

    @Transactional
    public void saveSubjectWithDTO(SubjectFormDTO dto, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));

        // Kiểm tra vai trò CONTENT_MANAGER
        if (!"CONTENT_MANAGER".equals(user.getRole().getRoleName())) {
            throw new IllegalArgumentException("Chỉ có Content Manager mới có thể chỉnh sửa môn học!");
        }

        if (dto.getSubjectId() != null) {
            // Kiểm tra môn học tồn tại
            Optional<Subject> subjectOpt = subjectRepository.findById(dto.getSubjectId());
            if (subjectOpt.isEmpty()) {
                throw new IllegalArgumentException("Môn học không tồn tại!");
            }

            // Kiểm tra trạng thái DRAFT
            Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findBySubjectSubjectId(dto.getSubjectId());
            if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT) {
                throw new IllegalArgumentException("Chỉ có thể chỉnh sửa môn học ở trạng thái DRAFT! Vui lòng chuyển về trạng thái DRAFT trước.");
            }
        }

        Subject subject = toSubjectEntity(dto);
        if (subject.getSubjectId() == null) {
            subject.setIsActive(false);
            subject = subjectRepository.save(subject);
            SubjectStatusHistory statusHistory = SubjectStatusHistory.builder()
                    .subject(subject)
                    .status(SubjectStatusHistory.SubjectStatus.DRAFT)
                    .changedAt(LocalDateTime.now())
                    .build();
            statusHistoryRepository.save(statusHistory);
        } else {
            subject = subjectRepository.save(subject);
            // Ghi log chỉnh sửa
            SubjectStatusHistory statusHistory = SubjectStatusHistory.builder()
                    .subject(subject)
                    .status(SubjectStatusHistory.SubjectStatus.DRAFT)
                    .changedAt(LocalDateTime.now())
                    .feedback("Chỉnh sửa bởi Content Manager")
                    .build();
            statusHistoryRepository.save(statusHistory);
        }
    }

    @Transactional
    public void revertToDraftByContentManager(Long subjectId, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));

        if (!"CONTENT_MANAGER".equals(user.getRole().getRoleName())) {
            throw new IllegalArgumentException("Chỉ có Content Manager mới có thể chuyển trạng thái về DRAFT!");
        }

        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại!"));

        Optional<SubjectStatusHistory> latestStatusOpt = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (latestStatusOpt.isEmpty()) {
            throw new IllegalArgumentException("Không tìm thấy lịch sử trạng thái của môn học!");
        }

        if (latestStatusOpt.get().getStatus() == SubjectStatusHistory.SubjectStatus.DRAFT) {
            throw new IllegalArgumentException("Môn học đã ở trạng thái DRAFT!");
        }

        // Update status for non-hidden chapters and lessons
        if (subject.getChapters() != null) {
            for (Chapter chapter : subject.getChapters()) {
                if (chapter.getIsHidden() == null || !chapter.getIsHidden()) {
                    chapter.setStatus(false);
                    if (chapter.getLessons() != null) {
                        for (Lesson lesson : chapter.getLessons()) {
                            if (lesson.getIsHidden() == null || !lesson.getIsHidden()) {
                                lesson.setStatus(false);
                            }
                        }
                    }
                }
            }
        }

        subject.setIsActive(false);
        subjectRepository.save(subject);

        SubjectStatusHistory latestStatus = latestStatusOpt.get();
        latestStatus.setStatus(SubjectStatusHistory.SubjectStatus.DRAFT);
        statusHistoryRepository.save(latestStatus);
    }

    @Transactional
    public void deleteSubjectByIdWithChecks(Long subjectId, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));

        // Kiểm tra vai trò CONTENT_MANAGER
        if (!"CONTENT_MANAGER".equals(user.getRole().getRoleName())) {
            throw new IllegalArgumentException("Chỉ có Content Manager mới có thể xóa môn học!");
        }

        if (!subjectRepository.existsById(subjectId)) {
            throw new IllegalArgumentException("Môn học không tồn tại");
        }

        // Kiểm tra trạng thái DRAFT
        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT) {
            throw new IllegalArgumentException("Chỉ có thể xóa môn học ở trạng thái DRAFT!");
        }

        // Kiểm tra nếu môn học đã được giao
        if (subjectAssignmentRepository.existsBySubjectSubjectId(subjectId)) {
            throw new IllegalArgumentException("Môn học đã được giao, không thể xóa!");
        }

        // Kiểm tra nếu môn học thuộc gói học
        if (packageSubjectRepository.existsBySubjectSubjectId(subjectId)) {
            throw new IllegalArgumentException("Môn học đang được sử dụng trong gói học!");
        }

        // Kiểm tra nếu môn học được người dùng đăng ký
        if (userPackageRepository.existsByPkg_PackageSubjects_Subject_SubjectId(subjectId)) {
            throw new IllegalArgumentException("Môn học đang được sử dụng bởi người dùng!");
        }

        // Xóa môn học
        subjectRepository.deleteById(subjectId);
    }

    @Transactional
    public Page<SubjectListDTO> getAssignedSubjectsForStaff(Long userId, String filterName, Long filterGradeId, Pageable pageable) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));

        if (!"STAFF".equals(user.getRole().getRoleName())) {
            throw new IllegalArgumentException("Chỉ có STAFF mới có thể xem danh sách môn học được giao!");
        }

        String searchName = (filterName != null && filterName.trim().isEmpty()) ? null : filterName;
        return subjectAssignmentRepository.findByUserUserIdAndSubjectSubjectNameContainingIgnoreCase(userId, searchName, pageable)
                .map(assignment -> toSubjectListDTO(assignment.getSubject()));
    }

    public Optional<SubjectDetailDTO> getSubjectDetailDTOById(Long subjectId) {
        Optional<Subject> subjectOpt = subjectRepository.findById(subjectId);
        if (subjectOpt.isEmpty()) {
            return Optional.empty();
        }

        Subject subject = subjectOpt.get();
        Optional<SubjectAssignment> assignmentOpt = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        Optional<SubjectStatusHistory> statusOpt = statusHistoryRepository.findBySubjectSubjectId(subjectId);

        SubjectDetailDTO.SubjectDetailDTOBuilder builder = SubjectDetailDTO.builder()
                .subjectId(subject.getSubjectId())
                .subjectName(subject.getSubjectName())
                .subjectDescription(subject.getSubjectDescription())
                .subjectImage(subject.getSubjectImage())
                .isActive(subject.getIsActive())
                .gradeName(subject.getGrade() != null ? subject.getGrade().getGradeName() : null)
                .createdAt(subject.getCreatedAt() != null ? subject.getCreatedAt().format(formatter) : null)
                .updatedAt(subject.getUpdatedAt() != null ? subject.getUpdatedAt().format(formatter) : null)
                .status(statusOpt.map(s -> s.getStatus().name()).orElse(null));

        assignmentOpt.ifPresent(assignment -> builder.assignedToFullName(assignment.getUser() != null ? assignment.getUser().getFullName() : null));

        statusOpt.ifPresent(status -> builder.submittedByFullName(status.getSubmittedBy() != null ? status.getSubmittedBy().getFullName() : null)
                .feedback(status.getFeedback()));

        List<ChapterDetailDTO> chapters = subject.getChapters().stream()
                .filter(chapter -> chapter.getIsHidden() != null && !chapter.getIsHidden()) // Filter chapters with isHidden = false
                .map(chapter -> ChapterDetailDTO.builder()
                        .chapterId(chapter.getChapterId())
                        .chapterName(chapter.getChapterName())
                        .chapterDescription(chapter.getChapterDescription())
                        .status(chapter.getStatus())
                        .createdAt(chapter.getCreatedAt() != null ? chapter.getCreatedAt().format(formatter) : null)
                        .userCreatedFullName(chapter.getUserCreated() != null ? userRepository.findById(chapter.getUserCreated())
                                .map(User::getFullName).orElse(null) : null)
                        .build())
                .collect(Collectors.toList());

        builder.chapters(chapters);
        return Optional.of(builder.build());
    }

    public Optional<ChapterDetailDTO> getChapterDetailDTOById(Long chapterId, Long subjectId) {
        Optional<Chapter> chapterOpt = chapterRepository.findByIdWithNonHiddenLessons(chapterId);
        if (chapterOpt.isEmpty() || !chapterOpt.get().getSubject().getSubjectId().equals(subjectId)) {
            return Optional.empty();
        }

        if (Boolean.TRUE.equals(chapterOpt.get().getIsHidden())) {
            throw  new IllegalArgumentException("Chương học này đã bị ẩn");
        }

        Chapter chapter = chapterOpt.get();
        return Optional.of(ChapterDetailDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .status(chapter.getStatus())
                .createdAt(chapter.getCreatedAt() != null ? chapter.getCreatedAt().format(formatter) : null)
                .userCreatedFullName(chapter.getUserCreated() != null ? userRepository.findById(chapter.getUserCreated())
                        .map(User::getFullName).orElse(null) : null)
                .lessons(chapter.getLessons().stream()
                        .map(lesson -> LessonDetailDTO.builder()
                                .lessonId(lesson.getLessonId())
                                .lessonName(lesson.getLessonName())
                                .lessonDescription(lesson.getLessonDescription())
                                .status(lesson.getStatus())
                                .createdAt(lesson.getCreatedAt() != null ? lesson.getCreatedAt().format(formatter) : null)
                                .userCreatedFullName(lesson.getUserCreated() != null ? userRepository.findById(lesson.getUserCreated())
                                        .map(User::getFullName).orElse(null) : null)

                                .build())
                        .collect(Collectors.toList()))
                .build());
    }

    public Optional<LessonDetailDTO> getLessonDetailDTOById(Long lessonId, Long chapterId, Long subjectId) {
        Optional<Lesson> lessonOpt = lessonRepository.findByIdWithMaterials(lessonId);
        if (lessonOpt.isEmpty() || !lessonOpt.get().getChapter().getChapterId().equals(chapterId) ||
                !lessonOpt.get().getChapter().getSubject().getSubjectId().equals(subjectId)) {
            return Optional.empty();
        }

        if (Boolean.TRUE.equals(lessonOpt.get().getIsHidden())) {
            throw new IllegalArgumentException("Bài học này đã bị ẩn");
        }


        Lesson lesson = lessonOpt.get();
        return Optional.of(LessonDetailDTO.builder()
                .lessonId(lesson.getLessonId())
                .lessonName(lesson.getLessonName())
                .lessonDescription(lesson.getLessonDescription())
                .status(lesson.getStatus())
                .videoSrc(lesson.getVideoSrc())
                .videoTime(lesson.getVideoTime())
                .videoTitle(lesson.getVideoTitle())
                .thumbnailUrl(lesson.getThumbnailUrl())
                .createdAt(lesson.getCreatedAt() != null ? lesson.getCreatedAt().format(formatter) : null)
                .userCreatedFullName(lesson.getUserCreated() != null ? userRepository.findById(lesson.getUserCreated())
                        .map(User::getFullName).orElse(null) : null)
                .lessonMaterials(lesson.getLessonMaterials().stream()
                        .map(material -> LessonDetailDTO.LessonMaterialDTO.builder()
                                .fileName(material.getFileName())
                                .filePath(material.getFilePath())
                                .build())
                        .collect(Collectors.toList()))
                .build());
    }

    public Boolean hasAccessSubjectInPackage(Long packageId, Long userId, Long subjectId) {
        // Kiểm tra user có gói học, gói chưa hết hạn, và môn học thuộc gói
        if (!userPackageRepository.existsByUser_UserIdAndPkg_PackageIdAndPkg_PackageSubjects_Subject_SubjectIdAndEndDateAfter(userId, packageId, subjectId, LocalDateTime.now())) {
            return false;
        }

        // Kiểm tra môn học có trong gói
        if (!packageSubjectRepository.existsBySubjectSubjectId(subjectId)) {
            return false;
        }

        // Kiểm tra môn học có ở trạng thái APPROVED và isActive
        Optional<Subject> subjectOpt = subjectRepository.findById(subjectId);
        if (subjectOpt.isEmpty() || !subjectOpt.get().getIsActive()) {
            return false;
        }

        Optional<SubjectStatusHistory> statusOpt = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        return statusOpt.isPresent() && SubjectStatusHistory.SubjectStatus.APPROVED.equals(statusOpt.get().getStatus());
    }

    public LearningPageDataDTO getLearningPageData(Long subjectId, Long packageId, Long userId) {
        // Kiểm tra quyền truy cập
        if (Boolean.FALSE.equals(hasAccessSubjectInPackage(packageId, userId, subjectId))) {
            throw new IllegalArgumentException("Bạn không có quyền truy cập môn học này trong gói học!");
        }

        // Lấy thông tin môn học
        Optional<Subject> subjectOpt = subjectRepository.findById(subjectId);
        if (subjectOpt.isEmpty()) {
            throw new IllegalArgumentException("Môn học không tồn tại!");
        }
        Subject subject = subjectOpt.get();

        // Lấy danh sách chương và bài học
        List<Chapter> chapters = chapterRepository.findBySubjectSubjectId(subjectId);
        List<LearningChapterDTO> chapterDTOs = chapters.stream()
                .filter(chapter -> chapter.getStatus()) // Chỉ lấy chương active
                .map(chapter -> {
                    List<LearningLessonDTO> lessonDTOs = chapter.getLessons().stream()
                            .filter(lesson -> lesson.getStatus()) // Chỉ lấy bài học active
                            .map(lesson -> {
                                Optional<LessonProgress> progressOpt = lessonProgressRepository.findByUserUserIdAndLessonLessonIdAndPackageEntityPackageId(userId, lesson.getLessonId(), packageId);
                                List<LearningLessonDTO.LessonMaterialDTO> materials = lesson.getLessonMaterials().stream()
                                        .map(material -> LearningLessonDTO.LessonMaterialDTO.builder()
                                                .filePath(material.getFilePath())
                                                .fileName(material.getFileName()) // Nếu không có fileName, trích xuất từ filePath
                                                .build())
                                        .collect(Collectors.toList());
                                // Lấy bài kiểm tra bài học (test_category_id = 4)
                                LearningTestDTO lessonTest = null;
                                List<Test> lessonTests = testRepository.findByTestCategoryTestCategoryIdAndIsOpenAndLessonLessonId(4L, true, lesson.getLessonId());
                                if (!lessonTests.isEmpty()) {
                                    Test test = lessonTests.get(0); // Lấy bài kiểm tra đầu tiên (giả định chỉ có một)

                                    List<UserTest> userTests = userTestRepository.findByTestIdUserId(test.getTestId(), userId).stream().sorted(Comparator.comparing(UserTest::getUserTestId).reversed()).collect(Collectors.toList());

                                    Optional<UserTest> userTestOpt = userTests.stream().findFirst();

//                                    Optional<UserTest> userTestOpt = userTestRepository.findByTestIdUserId(test.getTestId(), userId).stream().findFirst();
                                    lessonTest = LearningTestDTO.builder()
                                            .testId(test.getTestId())
                                            .userTestId(userTestOpt.map(UserTest::getUserTestId).orElse(test.getTestId()))
                                            .testName(test.getTestName())
                                            .durationTime(test.getDurationTime())
                                            .testCategoryName(test.getTestCategory() != null ? test.getTestCategory().getName() : "N/A")
                                            .isCompleted(userTestOpt.isPresent() && userTestOpt.get().getTimeEnd() != null)
                                            .startAt(test.getStartAt())
                                            .endAt(test.getEndAt())
                                            .build();
                                }
                                // Kiểm tra isCompleted: nếu có bài kiểm tra thì cần hoàn thành cả bài kiểm tra và video
                                boolean isCompleted = progressOpt.isPresent() && progressOpt.get().getIsCompleted();
                                if (lessonTest != null) {
                                    isCompleted = isCompleted && lessonTest.getIsCompleted();
                                }
                                return LearningLessonDTO.builder()
                                        .lessonId(lesson.getLessonId())
                                        .lessonName(lesson.getLessonName())
                                        .lessonDescription(lesson.getLessonDescription())
                                        .videoSrc(lesson.getVideoSrc())
                                        .videoTime(lesson.getVideoTime())
                                        .materials(materials)
                                        .isCompleted(isCompleted)
                                        .lessonTest(lessonTest)
                                        .build();
                            })
                            .collect(Collectors.toList());
                    // Lấy bài kiểm tra chương (test_category_id = 2)
                    List<Test> chapterTests = testRepository.findByTestCategoryTestCategoryIdAndIsOpenAndChapterChapterId(2L, true, chapter.getChapterId());
                    List<LearningTestDTO> chapterTestDTOs = chapterTests.stream()
                            .map(test -> {
                                List<UserTest> userTests = userTestRepository.findByTestIdUserId(test.getTestId(), userId).stream().sorted(Comparator.comparing(UserTest::getUserTestId).reversed()).collect(Collectors.toList());

                                Optional<UserTest> userTestOpt = userTests.stream().findFirst();
//                                Optional<UserTest> userTestOpt = userTestRepository.findByTestIdUserId(test.getTestId(), userId).stream().findFirst();
                                return LearningTestDTO.builder()
                                        .userTestId(userTestOpt.map(UserTest::getUserTestId).orElse(test.getTestId()))
                                        .testId(test.getTestId())
                                        .testName(test.getTestName())
                                        .durationTime(test.getDurationTime())
                                        .testCategoryName(test.getTestCategory() != null ? test.getTestCategory().getName() : "N/A")
                                        .isCompleted(userTestOpt.isPresent() && userTestOpt.get().getTimeEnd() != null)
                                        .startAt(test.getStartAt())
                                        .endAt(test.getEndAt())
                                        .build();
                            })
                            .collect(Collectors.toList());
                    return LearningChapterDTO.builder()
                            .chapterId(chapter.getChapterId())
                            .chapterName(chapter.getChapterName())
                            .chapterDescription(chapter.getChapterDescription())
                            .listLesson(lessonDTOs)
                            .chapterTests(chapterTestDTOs)
                            .build();
                })
                .collect(Collectors.toList());

        // Lấy bài kiểm tra môn học (test_category_id = 3)
        List<Test> subjectTests = testRepository.findByTestCategoryTestCategoryIdAndIsOpenAndSubjectSubjectId(3L, true, subjectId);
        List<LearningTestDTO> subjectTestDTOs = subjectTests.stream()
                .map(test -> {
                    List<UserTest> userTests = userTestRepository.findByTestIdUserId(test.getTestId(), userId).stream().sorted(Comparator.comparing(UserTest::getUserTestId).reversed()).collect(Collectors.toList());

                    Optional<UserTest> userTestOpt = userTests.stream().findFirst();
//                    Optional<UserTest> userTestOpt = userTestRepository.findByTestIdUserId(test.getTestId(), userId).stream().findFirst();
                    return LearningTestDTO.builder()
                            .testId(test.getTestId())
                            .userTestId(userTestOpt.map(UserTest::getUserTestId).orElse(test.getTestId()))
                            .testName(test.getTestName())
                            .durationTime(test.getDurationTime())
                            .testCategoryName(test.getTestCategory() != null ? test.getTestCategory().getName() : "N/A")
                            .isCompleted(userTestOpt.isPresent() && userTestOpt.get().getTimeEnd() != null)
                            .startAt(test.getStartAt())
                            .endAt(test.getEndAt())
                            .build();
                })
                .collect(Collectors.toList());

        // Tìm bài học và chương mặc định
        LearningLessonDTO defaultLesson = null;
        LearningChapterDTO defaultChapter = null;
        for (LearningChapterDTO chapterDTO : chapterDTOs) {
            for (LearningLessonDTO lessonDTO : chapterDTO.getListLesson()) {
                if (!lessonDTO.getIsCompleted()) {
                    defaultLesson = lessonDTO;
                    defaultChapter = chapterDTO;
                    break;
                }
            }
            if (defaultLesson != null) {
                break;
            }
        }
        // Nếu không có bài học chưa hoàn thành, lấy bài học đầu tiên của chương đầu tiên
        if (defaultLesson == null && !chapterDTOs.isEmpty() && !chapterDTOs.get(0).getListLesson().isEmpty()) {
            defaultChapter = chapterDTOs.get(0);
            defaultLesson = defaultChapter.getListLesson().get(0);
        }

        return LearningPageDataDTO.builder()
                .subjectId(subject.getSubjectId())
                .subjectName(subject.getSubjectName())
                .userId(userId)
                .packageId(packageId)
                .chapters(chapterDTOs)
                .defaultLesson(defaultLesson)
                .defaultChapter(defaultChapter)
                .subjectTests(subjectTestDTOs)
                .build();
    }

    // --- Hàm ánh xạ DTO ---

    private Subject toSubjectEntity(SubjectFormDTO dto) {
        Subject subject = Subject.builder()
                .subjectId(dto.getSubjectId())
                .subjectName(dto.getSubjectName())
                .subjectDescription(dto.getSubjectDescription())
                .subjectImage(dto.getSubjectImage())
                .isActive(dto.getIsActive())
                .build();
        if (dto.getGradeId() != null) {
            Grade grade = new Grade();
            grade.setGradeId(dto.getGradeId());
            subject.setGrade(grade);
        }
        return subject;
    }

    private SubjectFormDTO toSubjectFormDTO(Subject subject) {
        return SubjectFormDTO.builder()
                .subjectId(subject.getSubjectId())
                .subjectName(subject.getSubjectName())
                .subjectDescription(subject.getSubjectDescription())
                .subjectImage(subject.getSubjectImage())
                .isActive(subject.getIsActive())
                .gradeId(subject.getGrade() != null ? subject.getGrade().getGradeId() : null)
                .build();
    }

    private SubjectListDTO toSubjectListDTO(Subject subject) {
        Optional<SubjectAssignment> assignmentOpt = subjectAssignmentRepository.findBySubjectSubjectId(subject.getSubjectId());
        Optional<SubjectStatusHistory> statusOpt = statusHistoryRepository.findBySubjectSubjectId(subject.getSubjectId());

        SubjectListDTO.SubjectListDTOBuilder builder = SubjectListDTO.builder()
                .subjectId(subject.getSubjectId())
                .subjectName(subject.getSubjectName())
                .subjectDescription(subject.getSubjectDescription())
                .subjectImage(subject.getSubjectImage())
                .isActive(subject.getIsActive())
                .gradeName(subject.getGrade() != null ? subject.getGrade().getGradeName() : null)
                .createdAt(subject.getCreatedAt() != null ? subject.getCreatedAt().format(formatter) : null)
                .updatedAt(subject.getUpdatedAt() != null ? subject.getUpdatedAt().format(formatter) : null)
                .status(statusOpt.map(subjectStatusHistory -> subjectStatusHistory.getStatus().name()).orElse(null));

        assignmentOpt.ifPresent(subjectAssignment -> builder.assignedAt(subjectAssignment.getAssignedAt() != null ? subjectAssignment.getAssignedAt().format(formatter) : null)
                .assignedToFullName(subjectAssignment.getUser() != null ? subjectAssignment.getUser().getFullName() : null));

        if (statusOpt.isPresent()) {
            SubjectStatusHistory status = statusOpt.get();
            builder.submittedByFullName(status.getSubmittedBy() != null ? status.getSubmittedBy().getFullName() : null)
                    .feedback(status.getFeedback());
            builder.submittedAt(status.getChangedAt() != null ? status.getChangedAt().format(formatter):null);
            if (status.getStatus() == SubjectStatusHistory.SubjectStatus.DRAFT && status.getReviewer() != null) {
                builder.assignedByFullName(status.getReviewer().getFullName());
            } else {
                builder.assignedByFullName(null);
            }
        }

        return builder.build();
    }

    private SubjectAssignDTO toSubjectAssignDTO(Subject subject) {
        return SubjectAssignDTO.builder()
                .subjectId(subject.getSubjectId())
                .subjectName(subject.getSubjectName())
                .build();
    }

    private UserAssignDTO toUserAssignDTO(User user) {
        return UserAssignDTO.builder()
                .userId(user.getUserId())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .build();
    }

    private SubjectReviewDTO toSubjectReviewDTO(Subject subject, SubjectStatusHistory statusHistory) {
        return SubjectReviewDTO.builder()
                .subjectId(subject.getSubjectId())
                .subjectName(subject.getSubjectName())
                .submittedByFullName(statusHistory.getSubmittedBy() != null ? statusHistory.getSubmittedBy().getFullName() : null)
                .submittedAt(statusHistory.getChangedAt())
                .status(statusHistory.getStatus().name())
                .build();
    }

    @Transactional
    public void cancelSubmission(Long subjectId, Long userId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));

        if (!"STAFF".equals(user.getRole().getRoleName())) {
            throw new IllegalArgumentException("Chỉ có STAFF mới có thể hủy nộp duyệt môn học!");
        }

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findBySubjectSubjectId(subjectId);
        if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.PENDING) {
            throw new IllegalArgumentException("Chỉ có thể hủy nộp môn học ở trạng thái PENDING!");
        }

        Optional<SubjectAssignment> assignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        if (assignment.isEmpty() || !assignment.get().getUser().getUserId().equals(userId)) {
            throw new IllegalArgumentException("Chỉ có STAFF được giao môn học này mới có thể hủy nộp duyệt!");
        }

        SubjectStatusHistory statusHistory = latestStatus.get();
        statusHistory.setStatus(SubjectStatusHistory.SubjectStatus.DRAFT);
        statusHistory.setChangedAt(LocalDateTime.now());
        statusHistory.setFeedback("Hủy nộp duyệt bởi " + user.getFullName());
        statusHistory.setReviewer(null);
        statusHistoryRepository.save(statusHistory);

        subjectRepository.save(subject);
    }
}