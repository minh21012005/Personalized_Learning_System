package swp.se1941jv.pls.controller.staff;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.response.subject.SubjectListDTO;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.SubjectAssignment;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.SubjectService;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/staff/subject")
public class SubjectStaffController {
    private static final Logger logger = LoggerFactory.getLogger(SubjectStaffController.class);

    private final SubjectService subjectService;
    private final GradeService gradeService;

    private static final String STAFF_LAYOUT_VIEW = "staff/subject/show";
    private static final String SUBJECT_IMAGE_TARGET_FOLDER = "subjectImg";

    public SubjectStaffController(SubjectService subjectService, GradeService gradeService) {
        this.subjectService = subjectService;
        this.gradeService = gradeService;
    }

    private void addGradesToModelForFilter(Model model) {
        List<Grade> grades = gradeService.getAllGrades();
        model.addAttribute("gradesForFilter", grades);
    }

    @GetMapping
    public String listSubjects(Model model,
                               @RequestParam(name = "filterName", required = false) String filterName,
                               @RequestParam(name = "filterGradeId", required = false) Long filterGradeId,
                               @RequestParam(name = "page", defaultValue = "0") int page,
                               @RequestParam(name = "size", defaultValue = "10") int size,
                               @RequestParam(name = "sortField", defaultValue = "assignedAt") String sortField,
                               @RequestParam(name = "sortDir", defaultValue = "desc") String sortDir,
                               HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                model.addAttribute("errorMessage", "Vui lòng đăng nhập để xem danh sách môn học!");
                return STAFF_LAYOUT_VIEW;
            }

            // Validate and adjust sortField
            String adjustedSortField = sortField;
            if ("subjectId".equals(sortField)) {
                adjustedSortField = "subject.subjectId";
            } else if ("subjectName".equals(sortField)) {
                adjustedSortField = "subject.subjectName";
            } else if ("assignedByFullName".equals(sortField)) {
                adjustedSortField = "subject.reviewer.fullName"; // Assuming SubjectStatusHistory.reviewer
            } else if (!"assignedAt".equals(sortField)) {
                adjustedSortField = "assignedAt"; // Default to assignedAt
            }

            Sort.Direction direction = sortDir.equalsIgnoreCase(Sort.Direction.ASC.name()) ? Sort.Direction.ASC : Sort.Direction.DESC;
            Sort sortOrder = Sort.by(direction, adjustedSortField);
            Pageable pageable = PageRequest.of(page, size, sortOrder);
            Page<SubjectListDTO> subjectPage = subjectService.getAssignedSubjectsForStaff(userId, filterName, filterGradeId, pageable);

            model.addAttribute("subjectPage", subjectPage);
            model.addAttribute("subjects", subjectPage.getContent());
            model.addAttribute("viewName", "list_content");
            model.addAttribute("filterName", filterName);
            model.addAttribute("filterGradeId", filterGradeId);
            addGradesToModelForFilter(model);
            model.addAttribute("currentPage", page);
            model.addAttribute("pageSize", size);
            model.addAttribute("sortField", sortField);
            model.addAttribute("sortDir", sortDir);
            model.addAttribute("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
            model.addAttribute("customDateFormatter", formatter);
            model.addAttribute("subjectImageFolder", SUBJECT_IMAGE_TARGET_FOLDER);
            return STAFF_LAYOUT_VIEW;
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return STAFF_LAYOUT_VIEW;
        } catch (Exception e) {
            logger.error("Lỗi khi lấy danh sách môn học cho STAFF: {}", e.getMessage(), e);
            model.addAttribute("errorMessage", "Có lỗi xảy ra khi lấy danh sách môn học!");
            return STAFF_LAYOUT_VIEW;
        }
    }



    @PostMapping("/submit/{id}")
    public String submitSubjectForReview(@PathVariable("id") Long id,
                                         @RequestParam(value = "submissionFeedback", required = false) String submissionFeedback,
                                         HttpSession session,
                                         RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng đăng nhập để nộp duyệt môn học!");
                return "redirect:/staff/subject";
            }

            subjectService.submitForReview(id, userId, submissionFeedback);
            redirectAttributes.addFlashAttribute("successMessage", "subject.message.submitted.success");
            return "redirect:/staff/subject";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject";
        } catch (Exception e) {
            logger.error("Lỗi khi nộp duyệt môn học ID {}: {}", id, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.error.submit");
            return "redirect:/staff/subject";
        }
    }
}