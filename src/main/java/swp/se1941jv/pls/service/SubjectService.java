package swp.se1941jv.pls.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Subject;

import swp.se1941jv.pls.repository.SubjectRepository;

@Service
public class SubjectService {
    private final SubjectRepository subjectRepository;

    public SubjectService(SubjectRepository subjectRepository) {
        this.subjectRepository = subjectRepository;
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
}