package swp.se1941jv.pls.controller.content_manager;

import java.util.Collections;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.SubjectService;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Sort;

 @PreAuthorize("hasAnyRole('ADMIN', 'CONTENT_MANAGER')")
@Controller
public class GradeController {
    private final GradeService gradeService;
    private final SubjectService subjectService;

    public GradeController(GradeService gradeService, SubjectService subjectService) {
        this.gradeService = gradeService;
        this.subjectService = subjectService;

    }

    // @GetMapping("/admin/grade")
    // public String getGradePage(Model model) {
    // List<Grade> grades = this.gradeService.getAllGrades();
    // model.addAttribute("grades", grades);
    // return "admin/grade/show";
    // }
    @GetMapping("/admin/grade")
    public String getGradePage(Model model,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String isActive) {
        Pageable pageable = PageRequest.of(page, 10, Sort.by("gradeId").descending());
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        Page<Grade> gradePage = this.gradeService.getFilteredGrades(keyword, isActive, pageable);

        model.addAttribute("grades", gradePage.getContent());
        model.addAttribute("currentPage", gradePage.getNumber());
        model.addAttribute("totalPages", gradePage.getTotalPages());
        model.addAttribute("totalItems", gradePage.getTotalElements());

        return "admin/grade/show";
    }

    @RequestMapping("/admin/grade/create")
    public String getCreateUserPage(Model model) {

        model.addAttribute("newGrade", new Grade());
        return "admin/grade/create";
    }

    @PostMapping("/admin/grade/create")
    public String postCreateUserPage(Model model, @ModelAttribute("newGrade") Grade newGrade) {
        String name = newGrade.getGradeName();

        if (name == null || name.trim().isEmpty()) {
            model.addAttribute("error", "Tên không được để trống hoặc toàn khoảng trắng.");
            return "admin/grade/create";
        }
        if (!name.matches("[\\p{L}0-9\\s]+")) {
            model.addAttribute("error", "Tên chỉ được chứa chữ cái, số và khoảng trắng.");
            return "admin/grade/create";
        }

        try {
            newGrade.setGradeName(newGrade.getGradeName().trim());
            this.gradeService.saveGrade(newGrade);
            return "redirect:/admin/grade";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "admin/grade/create";
        }

    }

    @GetMapping(value = "/admin/grade/view/{gradeId}")
    public String viewSubjectsByGrade(Model model,
            @RequestParam(defaultValue = "0") int page,
            @PathVariable Long gradeId,
            @RequestParam(required = false) String keyword) {
        Pageable pageable = PageRequest.of(page, 10);
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        try {
            Grade grade = this.gradeService.findById(gradeId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khối lớp"));
            Page<Subject> subjectPage = this.subjectService.getSubjectsByGradeId(gradeId, true, keyword, pageable);

            if (!grade.isActive()) {
                model.addAttribute("warning", "⚠ Khối lớp này đã ngừng hoạt động. Dữ liệu chỉ để tham khảo.");
            }

            model.addAttribute("grade", grade);
            model.addAttribute("subjects", subjectPage.getContent());
            model.addAttribute("currentPage", subjectPage.getNumber());
            model.addAttribute("totalPages", subjectPage.getTotalPages());
            model.addAttribute("totalItems", subjectPage.getTotalElements());
            model.addAttribute("pageable", pageable);
            model.addAttribute("keyword", keyword);
        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("subjects", java.util.Collections.emptyList());
        }
        return "admin/grade/view";
    }

    private String loadGradeUpdatePage(Model model, Grade grade, int page, int pendingPage, String keyword,
            String pendingKeyword) {
        Pageable pageable = PageRequest.of(page, 10);
        Pageable pendingPageable = PageRequest.of(pendingPage, 10);
        Page<Subject> subjectPage = subjectService.getSubjectsByGradeId(grade.getGradeId(), true, keyword, pageable);
        Page<Subject> pendingSubjectPage = subjectService.getPendingSubjects(true, pendingKeyword, pendingPageable);

        model.addAttribute("grade", grade);
        model.addAttribute("subjects", subjectPage.getContent());
        model.addAttribute("currentPage", subjectPage.getNumber());
        model.addAttribute("totalPages", subjectPage.getTotalPages());
        model.addAttribute("totalItems", subjectPage.getTotalElements());
        model.addAttribute("keyword", keyword);
        model.addAttribute("pendingSubjects", pendingSubjectPage.getContent());
        model.addAttribute("pendingCurrentPage", pendingSubjectPage.getNumber());
        model.addAttribute("pendingTotalPages", pendingSubjectPage.getTotalPages());
        model.addAttribute("pendingTotalItems", pendingSubjectPage.getTotalElements());
        model.addAttribute("pendingKeyword", pendingKeyword);

        return "admin/grade/update";
    }

    @GetMapping("/admin/grade/update/{gradeId}")
    public String getUpdateGradePage(Model model, @PathVariable Long gradeId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "0") int pendingPage,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String pendingKeyword) {
        try {
            Grade grade = gradeService.findById(gradeId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khối lớp"));
            if (!grade.isActive()) {
                model.addAttribute("warning",
                        "⚠ Khối lớp này đã ngừng hoạt động. Không thể chỉnh sửa danh sách môn học.");
            }
            return loadGradeUpdatePage(model, grade, page, pendingPage, keyword, pendingKeyword);
        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("subjects", java.util.Collections.emptyList());
            model.addAttribute("pendingSubjects", java.util.Collections.emptyList());
            return "admin/grade/update";
        }
    }

    @PostMapping("/admin/grade/update")
    public String postUpdateGrade(
            Model model,
            @ModelAttribute("grade") Grade grade,
            @RequestParam(required = false) List<Long> removeSubjectIds,
            @RequestParam(required = false) List<Long> addSubjectIds,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "0") int pendingPage,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String pendingKeyword) {
        try {
            Grade existingGrade = gradeService.findById(grade.getGradeId())
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khối lớp"));

            existingGrade.setGradeName(grade.getGradeName());
            existingGrade.setActive(grade.isActive());
            gradeService.saveGrade(existingGrade);

            if (existingGrade.isActive()) {
                if (removeSubjectIds != null && !removeSubjectIds.isEmpty()) {
                    for (Long subjectId : removeSubjectIds) {
                        subjectService.updateSubjectGrade(subjectId, null);
                    }
                }
                if (addSubjectIds != null && !addSubjectIds.isEmpty()) {
                    for (Long subjectId : addSubjectIds) {
                        subjectService.updateSubjectGrade(subjectId, grade.getGradeId());
                    }
                }
            } else if ((removeSubjectIds != null && !removeSubjectIds.isEmpty()) ||
                    (addSubjectIds != null && !addSubjectIds.isEmpty())) {
                model.addAttribute("error", "Không thể chỉnh sửa danh sách môn học cho khối lớp không hoạt động.");
                return loadGradeUpdatePage(model, existingGrade, page, pendingPage, keyword, pendingKeyword);
            }

            return "redirect:/admin/grade/update/" + grade.getGradeId() +
                    "?page=" + page +
                    "&pendingPage=" + pendingPage +
                    (keyword != null ? "&keyword=" + keyword : "") +
                    (pendingKeyword != null ? "&pendingKeyword=" + pendingKeyword : "");
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return loadGradeUpdatePage(model, grade, page, pendingPage, keyword, pendingKeyword);
        } catch (org.springframework.dao.IncorrectResultSizeDataAccessException e) {
            model.addAttribute("error", "Tên khối lớp '" + grade.getGradeName()
                    + "' đã tồn tại trong cơ sở dữ liệu. Vui lòng chọn tên khác.");
            return loadGradeUpdatePage(model, grade, page, pendingPage, keyword, pendingKeyword);
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi cập nhật khối lớp: " + e.getMessage());
            return loadGradeUpdatePage(model, grade, page, pendingPage, keyword, pendingKeyword);
        }

    }

}
