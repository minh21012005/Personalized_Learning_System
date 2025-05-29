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

    /**
     * Retrieves all subjects with optional filtering by name and grade ID.
     *
     * @param filterName   Optional subject name filter (case-insensitive).
     * @param filterGradeId Optional grade ID filter.
     * @param pageable     Pagination information.
     * @return Page of filtered subjects.
     */
    public Page<Subject> getAllSubjects(String filterName, Long filterGradeId, Pageable pageable) {
        String searchName = (filterName != null && filterName.trim().isEmpty()) ? null : filterName;
        return subjectRepository.findByFilter(searchName, filterGradeId, pageable);
    }

    /**
     * Retrieves a subject by its ID.
     *
     * @param id The ID of the subject.
     * @return Optional containing the subject if found, or empty if not.
     */
    public Optional<Subject> getSubjectById(Long id) {
        return subjectRepository.findById(id);
    }

    /**
     * Retrieves subjects by grade ID and active status.
     *
     * @param gradeId  The ID of the grade.
     * @param isActive Whether to retrieve active (true) or inactive (false) subjects.
     * @return List of matching subjects.
     */
    public List<Subject> getSubjectsByGradeId(Long gradeId, boolean isActive) {
        return subjectRepository.findByGradeIdAndIsActive(gradeId, isActive);
    }

    /**
     * Retrieves a paginated list of subjects by grade ID, active status, and optional keyword.
     *
     * @param gradeId  The ID of the grade.
     * @param isActive Whether to retrieve active (true) or inactive (false) subjects.
     * @param keyword  Optional keyword to filter by subject name (case-insensitive).
     * @param pageable Pagination information.
     * @return Page of matching subjects.
     */
    public Page<Subject> getSubjectsByGradeId(Long gradeId, boolean isActive, String keyword, Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return subjectRepository.findByGradeGradeIdAndIsActiveAndSubjectNameContainingIgnoreCase(
                    gradeId, isActive, keyword, pageable);
        }
        return subjectRepository.findByGradeGradeIdAndIsActive(gradeId, isActive, pageable);
    }

    /**
     * Retrieves a paginated list of pending subjects (no assigned grade) by active status and optional keyword.
     *
     * @param isActive Whether to retrieve active (true) or inactive (false) subjects.
     * @param keyword  Optional keyword to filter by subject name (case-insensitive).
     * @param pageable Pagination information.
     * @return Page of pending subjects.
     */
    public Page<Subject> getPendingSubjects(boolean isActive, String keyword, Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return subjectRepository.findByGradeIsNullAndIsActiveAndSubjectNameContainingIgnoreCase(
                    isActive, keyword, pageable);
        }
        return subjectRepository.findByGradeIsNullAndIsActive(isActive, pageable);
    }

    /**
     * Saves a new subject or updates an existing one using the subject object's fields.
     * Use this method when the subject object is fully constructed (e.g., from a REST API).
     *
     * @param subject The subject to save.
     * @return The saved subject.
     * @throws IllegalArgumentException If the subject or subject name is null, empty, or already exists.
     */
    public Subject saveSubject(Subject subject) {
        if (subject == null || subject.getSubjectName() == null || subject.getSubjectName().trim().isEmpty()) {
            throw new IllegalArgumentException("Subject or subject name cannot be null or empty.");
        }
        if (subjectRepository.existsBySubjectName(subject.getSubjectName())) {
            throw new IllegalArgumentException("Môn học '" + subject.getSubjectName() + "' đã tồn tại.");
        }
        return subjectRepository.save(subject);
    }

    /**
     * Saves a new subject or updates an existing one with the specified name and active status.
     * Use this method when the subject name and active status are provided separately (e.g., from a form).
     *
     * @param subject The subject entity to save.
     * @param name    The name of the subject.
     * @param active  The active status of the subject.
     * @return The saved subject.
     * @throws IllegalArgumentException If the name is null, empty, or already exists.
     */
    public Subject saveSubject(Subject subject, String name, boolean active) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Subject name cannot be null or empty.");
        }
        if (subjectRepository.existsBySubjectName(name)) {
            throw new IllegalArgumentException("Môn học: '" + name + "' đã tồn tại.");
        }
        subject.setSubjectName(name);
        subject.setActive(active);
        return subjectRepository.save(subject);
    }

    /**
     * Deletes a subject by its ID.
     *
     * @param id The ID of the subject to delete.
     * @throws IllegalArgumentException If the subject does not exist.
     */
    public void deleteSubjectById(Long id) {
        if (!subjectRepository.existsById(id)) {
            throw new IllegalArgumentException("Subject with ID " + id + " does not exist.");
        }
        subjectRepository.deleteById(id);
    }

    /**
     * Updates the grade associated with a subject.
     *
     * @param subjectId The ID of the subject to update.
     * @param gradeId   The ID of the grade to associate, or null to remove the association.
     * @throws IllegalArgumentException If the subject does not exist.
     */
    public void updateSubjectGrade(Long subjectId, Long gradeId) {
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Subject with ID " + subjectId + " not found"));
        if (gradeId != null) {
            Grade grade = new Grade();
            grade.setGradeId(gradeId); // Note: Ideally, fetch Grade from GradeRepository
            subject.setGrade(grade);
        } else {
            subject.setGrade(null);
        }
        subjectRepository.save(subject);
    }
}