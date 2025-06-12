package swp.se1941jv.pls.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.SubjectResponseDTO;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.exception.subject.SubjectNotFoundException;
import swp.se1941jv.pls.repository.SubjectRepository;

@Service
public class SubjectService {
    private final SubjectRepository subjectRepository;
    private final ChapterService chapterService;
    public SubjectService(SubjectRepository subjectRepository, ChapterService chapterService) {
        this.subjectRepository = subjectRepository;
        this.chapterService = chapterService;
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

    // Phương thức mới
    public SubjectResponseDTO getSubjectResponseById(Long subjectId) {
        Subject subject = getSubjectById(subjectId).orElse(null);
        if (subject == null) {
            throw new SubjectNotFoundException("Môn học không tồn tại");
        }
        List<ChapterResponseDTO> chapters = chapterService.getChaptersResponseBySubjectId(subjectId);
        return SubjectResponseDTO.builder()
                .subjectId(subject.getSubjectId())
                .subjectName(subject.getSubjectName())
                .subjectDescription(subject.getSubjectDescription())
                .subjectImage(subject.getSubjectImage())
                .isActive(subject.getIsActive())
                .listChapter(chapters)
                .build();
    }
}