package swp.se1941jv.pls.service;

import java.time.LocalDateTime;
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

import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.dto.response.learningPageData.LearningChapterDTO;
import swp.se1941jv.pls.dto.response.learningPageData.LearningLessonDTO;
import swp.se1941jv.pls.dto.response.learningPageData.LearningPageDataDTO;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.keys.KeyPackageSubject;
import swp.se1941jv.pls.entity.keys.KeyUserPackage;
import swp.se1941jv.pls.repository.*;

@Service
public class SubjectService {
    private final SubjectRepository subjectRepository;
    private final ChapterService chapterService;
    private final UserPackageRepository userPackageRepository;
    private final PackageSubjectRepository packageSubjectRepository;
    private final ObjectMapper objectMapper;
    private final LessonProgressRepository lessonProgressRepository;
    private final UserRepository userRepository;
    private final PackageRepository packageRepository;

    public SubjectService(SubjectRepository subjectRepository, ChapterService chapterService, UserPackageRepository userPackageRepository, PackageSubjectRepository packageSubjectRepository, ObjectMapper objectMapper, LessonProgressRepository lessonProgressRepository, UserRepository userRepository, PackageRepository packageRepository) {
        this.subjectRepository = subjectRepository;
        this.chapterService = chapterService;
        this.userPackageRepository = userPackageRepository;
        this.packageSubjectRepository = packageSubjectRepository;
        this.objectMapper = objectMapper;
        this.lessonProgressRepository = lessonProgressRepository;
        this.userRepository = userRepository;
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

    public Subject saveSubject(Subject subject) {
        return subjectRepository.save(subject);
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



    public SubjectResponseDTO getSubjectResponseById(Long subjectId) {


        if (subjectId == null || subjectId <= 0) {
            throw new IllegalArgumentException("ID môn học không hợp lệ");
        }

        try {
            Subject subject =  subjectRepository.findById(subjectId)
                    .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));
            return SubjectResponseDTO.builder()
                    .subjectId(subject.getSubjectId())
                    .subjectName(subject.getSubjectName())
                    .listChapter(chapterService.findChaptersBySubjectId(subjectId,null,null))
                    .build();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi lấy thông tin môn học");
        }
    }

    public Boolean hasAccessSubjectInPackage(Long packageId, Long userId, Long subjectId) {
        return userPackageRepository.existsByUser_UserIdAndPkg_PackageIdAndPkg_PackageSubjects_Subject_SubjectIdAndEndDateAfter(userId, packageId, subjectId, LocalDateTime.now());
    }

    public LearningPageDataDTO getLearningPageData(Long subjectId, Long packageId, Long userId) {
        // 1. Tải Subject, Chapters, Lessons đã được tối ưu hóa bằng phương thức riêng
        // Bây giờ bạn gọi phương thức mới: findByIdWithChaptersAndLessons
        Subject subject = subjectRepository.findBySubjectId(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tồn tại"));

        // 2. Lấy User và Package một lần duy nhất
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại"));
        Package packageEntity = packageRepository.findById(packageId)
                .orElseThrow(() -> new IllegalArgumentException("Gói học không tồn tại"));

        // 3. Lấy tất cả LessonProgress cho User, Subject, Package này trong một truy vấn
        List<LessonProgress> allLessonProgresses = lessonProgressRepository
                .findByUserAndSubjectAndPackageEntity(user, subject, packageEntity);

        // Tạo Map để tra cứu trạng thái hoàn thành nhanh chóng
        Map<Long, Boolean> lessonCompletionMap = allLessonProgresses.stream()
                .collect(Collectors.toMap(
                        lp -> lp.getLesson().getLessonId(),
                        LessonProgress::getIsCompleted,
                        (existing, replacement) -> replacement
                ));

        // 4. Ánh xạ từ Entity sang DTO mới
        List<LearningChapterDTO> learningChapters = subject.getChapters().stream()
                .filter(chapter -> chapter.getStatus() && chapter.getChapterStatus() == Chapter.ChapterStatus.APPROVED)
                .map(chapter -> mapToLearningChapterDTO(chapter, lessonCompletionMap))
                .toList();

        // 5. Xác định lesson và chapter mặc định
        LearningLessonDTO defaultLesson = learningChapters.stream()
                .filter(chapterDto -> chapterDto.getListLesson() != null && !chapterDto.getListLesson().isEmpty())
                .findFirst()
                .flatMap(chapterDto -> chapterDto.getListLesson().stream().findFirst())
                .orElse(null);

        LearningChapterDTO defaultChapter = learningChapters.stream()
                .filter(chapterDto -> chapterDto.getListLesson() != null && chapterDto.getListLesson().contains(defaultLesson))
                .findFirst()
                .orElse(null);

        // 6. Xây dựng và trả về LearningPageDataDTO
        return LearningPageDataDTO.builder()
                .subjectId(subject.getSubjectId())
                .subjectName(subject.getSubjectName())
                .userId(userId)
                .packageId(packageId)
                .chapters(learningChapters)
                .defaultLesson(defaultLesson)
                .defaultChapter(defaultChapter)
                .build();
    }

    private LearningChapterDTO mapToLearningChapterDTO(Chapter chapter, Map<Long, Boolean> lessonCompletionMap) {
        List<LearningLessonDTO> learningLessons = chapter.getLessons().stream()
                .filter(lesson -> lesson.getStatus() && lesson.getLessonStatus() == Lesson.LessonStatus.APPROVED)
                .map(lesson -> mapToLearningLessonDTO(lesson, lessonCompletionMap.getOrDefault(lesson.getLessonId(), false)))
                .toList();

        return LearningChapterDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .listLesson(learningLessons)
                .build();
    }

    private LearningLessonDTO mapToLearningLessonDTO(Lesson lesson, boolean isCompleted) {
        List<String> materials;
        try {
            materials = objectMapper.readValue(lesson.getMaterialsJson(), new TypeReference<List<String>>() {});
        } catch (Exception e) {
            materials = Collections.emptyList();
        }

        return LearningLessonDTO.builder()
                .lessonId(lesson.getLessonId())
                .lessonName(lesson.getLessonName())
                .lessonDescription(lesson.getLessonDescription())
                .videoSrc(lesson.getVideoSrc())
                .videoTime(lesson.getVideoTime())
                .materials(materials)
                .isCompleted(isCompleted)
                .build();
    }
}