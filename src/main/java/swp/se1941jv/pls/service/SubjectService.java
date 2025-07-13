package swp.se1941jv.pls.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.dto.response.learningPageData.LearningChapterDTO;
import swp.se1941jv.pls.dto.response.learningPageData.LearningLessonDTO;
import swp.se1941jv.pls.dto.response.learningPageData.LearningPageDataDTO;
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
    private final ChapterService chapterService;
    private final UserPackageRepository userPackageRepository;
    private final PackageSubjectRepository packageSubjectRepository;
    private final ObjectMapper objectMapper;
    private final LessonProgressRepository lessonProgressRepository;
    private final PackageRepository packageRepository;
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");

    public SubjectService(SubjectRepository subjectRepository,
                          SubjectAssignmentRepository subjectAssignmentRepository,
                          SubjectStatusHistoryRepository statusHistoryRepository, UserRepository userRepository,
                          ChapterService chapterService, UserPackageRepository userPackageRepository,
                          PackageSubjectRepository packageSubjectRepository, ObjectMapper objectMapper,
                          LessonProgressRepository lessonProgressRepository, PackageRepository packageRepository) {
        this.subjectRepository = subjectRepository;
        this.subjectAssignmentRepository = subjectAssignmentRepository;
        this.statusHistoryRepository = statusHistoryRepository;
        this.userRepository = userRepository;
        this.chapterService = chapterService;
        this.userPackageRepository = userPackageRepository;
        this.packageSubjectRepository = packageSubjectRepository;
        this.objectMapper = objectMapper;
        this.lessonProgressRepository = lessonProgressRepository;
        this.packageRepository = packageRepository;
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

    @Transactional
    public Subject saveSubject(Subject subject) {
        if (subject.getSubjectId() == null) {
            subject.setIsActive(false);
            subject = subjectRepository.save(subject);
            // Ghi trạng thái DRAFT ban đầu
            SubjectStatusHistory statusHistory = SubjectStatusHistory.builder()
                    .subject(subject)
                    .status(SubjectStatusHistory.SubjectStatus.DRAFT)
                    .changedAt(LocalDateTime.now())
                    .build();
            statusHistoryRepository.save(statusHistory);
        } else {
            subject = subjectRepository.save(subject);
        }
        return subject;
    }

    public void deleteSubjectById(Long id) {
        subjectRepository.deleteById(id);
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



//    public SubjectResponseDTO getSubjectResponseById(Long subjectId) {
//
//
//        if (subjectId == null || subjectId <= 0) {
//            throw new IllegalArgumentException("ID môn học không hợp lệ");
//        }
//
//        try {
//            Subject subject =  subjectRepository.findById(subjectId)
//                    .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));
//            return SubjectResponseDTO.builder()
//                    .subjectId(subject.getSubjectId())
//                    .subjectName(subject.getSubjectName())
//                    .listChapter(chapterService.findChaptersBySubjectId(subjectId,null,null))
//                    .build();
//        } catch (Exception e) {
//            throw new RuntimeException("Lỗi khi lấy thông tin môn học");
//        }
//    }

//    public Boolean hasAccessSubjectInPackage(Long packageId, Long userId, Long subjectId) {
//        return userPackageRepository.existsByUser_UserIdAndPkg_PackageIdAndPkg_PackageSubjects_Subject_SubjectIdAndEndDateAfter(userId, packageId, subjectId, LocalDateTime.now());
//    }
//
//    public LearningPageDataDTO getLearningPageData(Long subjectId, Long packageId, Long userId) {
//        // 1. Tải Subject, Chapters, Lessons đã được tối ưu hóa bằng phương thức riêng
//        // Bây giờ bạn gọi phương thức mới: findByIdWithChaptersAndLessons
//        Subject subject = subjectRepository.findBySubjectId(subjectId)
//                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));
//
//        // 2. Lấy User và Package một lần duy nhất
//        User user = userRepository.findById(userId)
//                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại"));
//        Package packageEntity = packageRepository.findById(packageId)
//                .orElseThrow(() -> new IllegalArgumentException("Gói học không tồn tại"));
//
//        // 3. Lấy tất cả LessonProgress cho User, Subject, Package này trong một truy vấn
//        List<LessonProgress> allLessonProgresses = lessonProgressRepository
//                .findByUserAndSubjectAndPackageEntity(user, subject, packageEntity);
//
//        // Tạo Map để tra cứu trạng thái hoàn thành nhanh chóng
//        Map<Long, Boolean> lessonCompletionMap = allLessonProgresses.stream()
//                .collect(Collectors.toMap(
//                        lp -> lp.getLesson().getLessonId(),
//                        LessonProgress::getIsCompleted,
//                        (existing, replacement) -> replacement
//                ));
//
//        // 4. Ánh xạ từ Entity sang DTO mới
//        List<LearningChapterDTO> learningChapters = subject.getChapters().stream()
//                .filter(chapter -> chapter.getStatus() && chapter.getChapterStatus() == Chapter.ChapterStatus.APPROVED)
//                .map(chapter -> mapToLearningChapterDTO(chapter, lessonCompletionMap))
//                .toList();
//
//        // 5. Xác định lesson và chapter mặc định
//        LearningLessonDTO defaultLesson = learningChapters.stream()
//                .filter(chapterDto -> chapterDto.getListLesson() != null && !chapterDto.getListLesson().isEmpty())
//                .findFirst()
//                .flatMap(chapterDto -> chapterDto.getListLesson().stream().findFirst())
//                .orElse(null);
//
//        LearningChapterDTO defaultChapter = learningChapters.stream()
//                .filter(chapterDto -> chapterDto.getListLesson() != null && chapterDto.getListLesson().contains(defaultLesson))
//                .findFirst()
//                .orElse(null);
//
//        // 6. Xây dựng và trả về LearningPageDataDTO
//        return LearningPageDataDTO.builder()
//                .subjectId(subject.getSubjectId())
//                .subjectName(subject.getSubjectName())
//                .userId(userId)
//                .packageId(packageId)
//                .chapters(learningChapters)
//                .defaultLesson(defaultLesson)
//                .defaultChapter(defaultChapter)
//                .build();
//    }
//
//    private LearningChapterDTO mapToLearningChapterDTO(Chapter chapter, Map<Long, Boolean> lessonCompletionMap) {
//        List<LearningLessonDTO> learningLessons = chapter.getLessons().stream()
//                .filter(lesson -> lesson.getStatus() && lesson.getLessonStatus() == Lesson.LessonStatus.APPROVED)
//                .map(lesson -> mapToLearningLessonDTO(lesson, lessonCompletionMap.getOrDefault(lesson.getLessonId(), false)))
//                .toList();
//
//        return LearningChapterDTO.builder()
//                .chapterId(chapter.getChapterId())
//                .chapterName(chapter.getChapterName())
//                .chapterDescription(chapter.getChapterDescription())
//                .listLesson(learningLessons)
//                .build();
//    }

//    private LearningLessonDTO mapToLearningLessonDTO(Lesson lesson, boolean isCompleted) {
//        List<String> materials;
//        try {
//            materials = objectMapper.readValue(lesson.getMaterialsJson(), new TypeReference<List<String>>() {});
//        } catch (Exception e) {
//            materials = Collections.emptyList();
//        }
//
//        return LearningLessonDTO.builder()
//                .lessonId(lesson.getLessonId())
//                .lessonName(lesson.getLessonName())
//                .lessonDescription(lesson.getLessonDescription())
//                .videoSrc(lesson.getVideoSrc())
//                .videoTime(lesson.getVideoTime())
//                .materials(materials)
//                .isCompleted(isCompleted)
//                .build();
//    }

    @Transactional
    public void assignSubject(Long subjectId, Long userId, Long contentManagerId) {
        // Validate Subject
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subjectId);
        if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT) {
            throw new IllegalArgumentException("Chỉ có thể giao môn học ở trạng thái DRAFT!");
        }

        if (subjectAssignmentRepository.existsBySubjectSubjectId(subjectId)) {
            throw new IllegalArgumentException("Môn học đã được giao cho nhân viên khác!");
        }

        // Validate User
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

        // Tạo SubjectAssignment
        SubjectAssignment assignment = SubjectAssignment.builder()
                .subject(subject)
                .user(user)
                .assignedAt(LocalDateTime.now())
                .build();

        subjectAssignmentRepository.save(assignment);

        SubjectStatusHistory statusHistory = SubjectStatusHistory.builder()
                .subject(subject)
                .status(SubjectStatusHistory.SubjectStatus.DRAFT)
                .changedAt(LocalDateTime.now())
                .feedback("Được giao bởi " + contentManager.getFullName())
                .reviewer(contentManager)
                .build();
        statusHistoryRepository.save(statusHistory);
    }

    @Transactional
    public void submitForReview(Long subjectId, Long userId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));

        if (!"STAFF".equals(user.getRole().getRoleName())) {
            throw new IllegalArgumentException("Chỉ có STAFF mới có thể nộp duyệt môn học!");
        }

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subjectId);
        if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT) {
            throw new IllegalArgumentException("Chỉ có thể nộp môn học ở trạng thái DRAFT!");
        }

        Optional<SubjectAssignment> assignment = subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
        if (assignment.isEmpty() || !assignment.get().getUser().getUserId().equals(userId)) {
            throw new IllegalArgumentException("Chỉ có STAFF được giao môn học này mới có thể nộp duyệt!");
        }

        if (subject.getChapters().isEmpty()) {
            throw new IllegalArgumentException("Môn học phải có ít nhất một chương!");
        }

        for (Chapter chapter : subject.getChapters()) {
            if (chapter.getLessons().isEmpty()) {
                throw new IllegalArgumentException("Chương " + chapter.getChapterName() + " phải có ít nhất một bài học!");
            }

        }

        SubjectStatusHistory statusHistory = SubjectStatusHistory.builder()
                .subject(subject)
                .status(SubjectStatusHistory.SubjectStatus.PENDING)
                .changedAt(LocalDateTime.now())
                .submittedBy(user)
                .feedback("Nộp duyệt bởi STAFF")
                .build();
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

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subjectId);
        if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.PENDING) {
            throw new IllegalArgumentException("Chỉ có thể duyệt môn học ở trạng thái PENDING!");
        }

        SubjectStatusHistory.SubjectStatus newStatus = SubjectStatusHistory.SubjectStatus.valueOf(status);
        if (newStatus == SubjectStatusHistory.SubjectStatus.REJECTED && (feedback == null || feedback.trim().isEmpty())) {
            throw new IllegalArgumentException("Phải cung cấp phản hồi khi từ chối môn học!");
        }

        // Ghi trạng thái mới
        SubjectStatusHistory statusHistory = SubjectStatusHistory.builder()
                .subject(subject)
                .status(newStatus)
                .changedAt(LocalDateTime.now())
                .reviewer(reviewer)
                .feedback(newStatus == SubjectStatusHistory.SubjectStatus.REJECTED ? feedback : null)
                .build();
        statusHistoryRepository.save(statusHistory);

        subjectRepository.save(subject);
    }

    @Transactional
    public void publishSubject(Long subjectId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subjectId);
        if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.APPROVED) {
            throw new IllegalArgumentException("Chỉ có thể xuất bản môn học ở trạng thái APPROVED!");
        }

//        boolean allApproved = subject.getChapters().stream()
//                .allMatch(chapter -> chapter.getChapterStatus() == Chapter.ChapterStatus.APPROVED
//                        && chapter.getLessons().stream()
//                        .allMatch(lesson -> lesson.getLessonStatus() == Lesson.LessonStatus.APPROVED));
//
//        if (!allApproved) {
//            throw new IllegalArgumentException("Chưa tất cả chương và bài học được phê duyệt!");
//        }

        subject.setIsActive(true);
        subjectRepository.save(subject);
    }

    //Lấy thông tin giao việc của một Subject để hiển thị trong danh sách.
    public Optional<SubjectAssignment> getAssignmentBySubjectId(Long subjectId) {
        return subjectAssignmentRepository.findBySubjectSubjectId(subjectId);
    }

    //Lấy trạng thái mới nhất của Subject để hiển thị và validate.
    public Optional<SubjectStatusHistory> getLatestSubjectStatus(Long subjectId) {
        return statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subjectId);
    }

    public List<User> getStaff() {
        return userRepository.findByRole_RoleNameAndIsActive("STAFF", true);
    }

//    public Page<Subject> getPendingSubjects(Pageable pageable) {
//        return subjectRepository.findAll(pageable).map(subject -> {
//            Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subject.getSubjectId());
//            if (latestStatus.isPresent() && latestStatus.get().getStatus() == SubjectStatusHistory.SubjectStatus.PENDING) {
//                return subject;
//            }
//            return null;
//        }).filter(s -> s != null);
//    }

    // --- Hàm mới sử dụng DTO ---
    public Page<SubjectListDTO> getAllSubjectsWithDTO(String filterName, Long filterGradeId, Pageable pageable) {
        String searchName = (filterName != null && filterName.trim().isEmpty()) ? null : filterName;
        return subjectRepository.findByFilter(searchName, filterGradeId, pageable)
                .map(this::toSubjectListDTO);
    }

    public Optional<SubjectAssignDTO> getSubjectAssignDTOById(Long id) {
        return subjectRepository.findById(id).map(this::toSubjectAssignDTO);
    }

    public Optional<SubjectReviewDTO> getSubjectReviewDTOById(Long id) {
        Optional<Subject> subjectOpt = subjectRepository.findById(id);
        Optional<SubjectStatusHistory> statusOpt = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(id);
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
            Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(dto.getSubjectId());
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

        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subjectId);
        if (latestStatus.isEmpty()) {
            throw new IllegalArgumentException("Không tìm thấy lịch sử trạng thái của môn học!");
        }

        if (latestStatus.get().getStatus() == SubjectStatusHistory.SubjectStatus.DRAFT) {
            throw new IllegalArgumentException("Môn học đã ở trạng thái DRAFT!");
        }

        // Nếu môn học đã xuất bản, hủy xuất bản
        if (subject.getIsActive()) {
            subject.setIsActive(false);
            subjectRepository.save(subject);
        }

        // Ghi log chuyển trạng thái
        SubjectStatusHistory statusHistory = SubjectStatusHistory.builder()
                .subject(subject)
                .status(SubjectStatusHistory.SubjectStatus.DRAFT)
                .changedAt(LocalDateTime.now())
                .feedback("Chuyển về DRAFT bởi Content Manager")
                .build();
        statusHistoryRepository.save(statusHistory);
    }

    @Transactional
    public void deleteSubjectByIdWithChecks(Long subjectId, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));

        // Kiểm tra vai trò CONTENT_MANAGER
        if (!"CONTENT_MANAGER".equals(user.getRole().getRoleName())) {
            throw new IllegalArgumentException("Chỉ có Content Manager mới có thể xóa môn học!");
        }

        if (!subjectRepository.existsById(subjectId)){
            throw new IllegalArgumentException("Môn học không tồn tại");
        }

        // Kiểm tra trạng thái DRAFT
        Optional<SubjectStatusHistory> latestStatus = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subjectId);
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
        Optional<SubjectStatusHistory> statusOpt = statusHistoryRepository.findTopBySubjectSubjectIdOrderByChangedAtDesc(subject.getSubjectId());

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
            // Lấy người giao từ SubjectStatusHistory (giả định có bản ghi DRAFT với reviewer là người giao)
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
}