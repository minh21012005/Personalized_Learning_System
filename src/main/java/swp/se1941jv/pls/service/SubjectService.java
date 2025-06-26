package swp.se1941jv.pls.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.entity.keys.KeyPackageSubject;
import swp.se1941jv.pls.entity.keys.KeyUserPackage;
import swp.se1941jv.pls.exception.ApplicationException;
import swp.se1941jv.pls.exception.NotFoundException;
import swp.se1941jv.pls.exception.ValidationException;
import swp.se1941jv.pls.exception.subject.SubjectNotFoundException;
import swp.se1941jv.pls.repository.PackageSubjectRepository;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.repository.UserPackageRepository;

@Service
public class SubjectService {
    private final SubjectRepository subjectRepository;
    private final ChapterService chapterService;
    private final UserPackageRepository userPackageRepository;
    private final PackageSubjectRepository packageSubjectRepository;
    private final ObjectMapper objectMapper;

    public SubjectService(SubjectRepository subjectRepository, ChapterService chapterService, UserPackageRepository userPackageRepository, PackageSubjectRepository packageSubjectRepository, ObjectMapper objectMapper) {
        this.subjectRepository = subjectRepository;
        this.chapterService = chapterService;
        this.userPackageRepository = userPackageRepository;
        this.packageSubjectRepository = packageSubjectRepository;
        this.objectMapper = objectMapper;
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

    public List<SubjectResponseDTO> getSubjectsResponse() {
        List<Subject> subjects = subjectRepository.findByIsActiveTrue();
        if (subjects.isEmpty()) {
            throw new SubjectNotFoundException("Không có môn học nào tồn tại");
        }
        return subjects.stream()
                .map(subject -> SubjectResponseDTO.builder()
                        .subjectId(subject.getSubjectId())
                        .subjectName(subject.getSubjectName())
                        .subjectDescription(subject.getSubjectDescription())
                        .subjectImage(subject.getSubjectImage())
                        .build())
                .toList();
    }

    public SubjectResponseDTO getSubjectResponseById(Long subjectId) {


        if (subjectId == null || subjectId <= 0) {
            throw new ValidationException("ID môn học không hợp lệ");
        }

        try {
            Subject subject =  subjectRepository.findById(subjectId)
                    .orElseThrow(() -> new NotFoundException("Môn học không tồn tại"));
            return SubjectResponseDTO.builder()
                    .subjectId(subject.getSubjectId())
                    .subjectName(subject.getSubjectName())
                    .listChapter(chapterService.findChaptersBySubjectId(subjectId,null,null))
                    .build();
        } catch (Exception e) {
            throw new ApplicationException("FETCH_ERROR", "Lỗi khi lấy thông tin môn học", e);
        }
    }

    public Boolean hasAccessSubjectInPackage(Long packageId, Long subjectId, Long userId) {



        KeyUserPackage keyUserPackage = KeyUserPackage.builder()
                .userId(userId)
                .packageId(packageId)
                .build();

        UserPackage userPackage = userPackageRepository.findById(keyUserPackage)
                .orElse(null);

        if (userPackage != null ) {
            KeyPackageSubject keyPackageSubject = KeyPackageSubject.builder()
                    .packageId(packageId)
                    .subjectId(subjectId)
                    .build();

            PackageSubject packageSubject = packageSubjectRepository.findById(keyPackageSubject).orElse(null);
            return packageSubject != null;
        }
        return false;
    }

    public SubjectResponseDTO getSubjectResponseDTOById(Long subjectId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new NotFoundException("Môn học không tồn tại"));
        return mapToSubjectResponseDTO(subject);
    }

    private SubjectResponseDTO mapToSubjectResponseDTO(Subject subject) {
        List<ChapterResponseDTO> chapters = subject.getChapters().stream()
                .filter(chapter -> chapter.getStatus() && chapter.getChapterStatus() == Chapter.ChapterStatus.APPROVED)
                .map(this::mapToChapterResponseDTO)
                .toList();

        return SubjectResponseDTO.builder()
                .subjectId(subject.getSubjectId())
                .subjectName(subject.getSubjectName())
                .listChapter(chapters)
                .build();
    }

    private ChapterResponseDTO mapToChapterResponseDTO(Chapter chapter) {
        List<LessonResponseDTO> lessons = chapter.getLessons().stream()
                .filter(lesson -> lesson.getStatus() && lesson.getLessonStatus() == Lesson.LessonStatus.APPROVED)
                .map(this::mapToLessonResponseDTO)
                .toList();

        return ChapterResponseDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .listLesson(lessons)
                .build();
    }

    private LessonResponseDTO mapToLessonResponseDTO(Lesson lesson) {
        List<String> materials;
        try {
            materials = objectMapper.readValue(lesson.getMaterialsJson(), new TypeReference<List<String>>() {});
        } catch (Exception e) {
            materials = Collections.emptyList();
        }

        return LessonResponseDTO.builder()
                .lessonId(lesson.getLessonId())
                .lessonName(lesson.getLessonName())
                .lessonDescription(lesson.getLessonDescription())
                .videoSrc(lesson.getVideoSrc())
                .videoTime(lesson.getVideoTime())
                .status(lesson.getStatus())
                .lessonStatus(LessonResponseDTO.LessonStatusDTO.builder()
                        .statusCode(lesson.getLessonStatus().name())
                        .description(lesson.getLessonStatus().getDescription())
                        .build())
                .materials(materials)
                .build();
    }
}