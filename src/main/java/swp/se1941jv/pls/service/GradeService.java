package swp.se1941jv.pls.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.repository.GradeRepository;

@Service
public class GradeService {
    private final GradeRepository gradeRepository;

    public GradeService(GradeRepository gradeRepository) {
        this.gradeRepository = gradeRepository;
    }

    /**
     * Retrieves all grades from the repository.
     *
     * @return List of all grades.
     */
    public List<Grade> getAllGrades() {
        return gradeRepository.findAll();
    }

    /**
     * Retrieves a paginated list of all grades.
     *
     * @param pageable Pagination information.
     * @return Page of grades.
     */
    public Page<Grade> getAllGrades(Pageable pageable) {
        return gradeRepository.findAll(pageable);
    }

    /**
     * Retrieves a grade by its ID.
     *
     * @param id The ID of the grade.
     * @return Optional containing the grade if found, or empty if not.
     */
    public Optional<Grade> getGradeById(Long id) {
        return gradeRepository.findById(id);
    }

    /**
     * Retrieves grades based on their active status.
     *
     * @param isActive Whether to retrieve active (true) or inactive (false) grades.
     * @return List of grades matching the active status.
     */
    public List<Grade> getByStatus(boolean isActive) {
        return gradeRepository.findByIsActive(isActive);
    }

    /**
     * Retrieves only active grades.
     *
     * @return List of active grades.
     */
    public List<Grade> getActiveGrades() {
        return gradeRepository.findByIsActiveTrue();
    }

    /**
     * Saves a new grade or updates an existing one with the specified name and active status.
     * Use this method when the grade name and active status are provided separately (e.g., from a form).
     *
     * @param grade  The grade entity to save.
     * @param name   The name of the grade.
     * @param active The active status of the grade.
     * @return The saved grade.
     * @throws IllegalArgumentException If the name is null, empty, or already exists.
     */
    public Grade saveGrade(Grade grade, String name, boolean active) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Grade name cannot be null or empty.");
        }
        if (gradeRepository.existsByGradeName(name)) {
            throw new IllegalArgumentException("Khối lớp: '" + name + "' đã tồn tại.");
        }
        grade.setGradeName(name);
        grade.setActive(active);
        return gradeRepository.save(grade);
    }

    /**
     * Saves a new grade or updates an existing one using the grade object's fields.
     * Use this method when the grade object is fully constructed (e.g., from a REST API or internal logic).
     *
     * @param grade The grade to save.
     * @return The saved grade.
     * @throws IllegalArgumentException If the grade name is null, empty, or already exists.
     */
    public Grade saveGrade(Grade grade) {
        if (grade == null || grade.getGradeName() == null || grade.getGradeName().trim().isEmpty()) {
            throw new IllegalArgumentException("Grade or grade name cannot be null or empty.");
        }
        if (gradeRepository.existsByGradeName(grade.getGradeName())) {
            throw new IllegalArgumentException("Khối lớp '" + grade.getGradeName() + "' đã tồn tại.");
        }
        return gradeRepository.save(grade);
    }

    /**
     * Deletes a grade by its ID.
     *
     * @param id The ID of the grade to delete.
     * @throws IllegalArgumentException If the grade does not exist.
     */
    public void deleteGradeById(Long id) {
        if (!gradeRepository.existsById(id)) {
            throw new IllegalArgumentException("Grade with ID " + id + " does not exist.");
        }
        gradeRepository.deleteById(id);
    }

    /**
     * Retrieves a paginated list of grades filtered by keyword and/or active status.
     *
     * @param keyword  Optional keyword to filter by grade name (case-insensitive).
     * @param isActive Optional active status filter ("true", "false", or null).
     * @param pageable Pagination information.
     * @return Page of filtered grades.
     */
    public Page<Grade> getFilteredGrades(String keyword, String isActive, Pageable pageable) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasIsActive = isActive != null && !isActive.isEmpty();

        if (hasKeyword && hasIsActive) {
            return gradeRepository.findByGradeNameContainingIgnoreCaseAndIsActive(
                    keyword, Boolean.parseBoolean(isActive), pageable);
        } else if (hasKeyword) {
            return gradeRepository.findByGradeNameContainingIgnoreCase(keyword, pageable);
        } else if (hasIsActive) {
            return gradeRepository.findByIsActive(Boolean.parseBoolean(isActive), pageable);
        }
        return gradeRepository.findAll(pageable);
    }
}