package swp.se1941jv.pls.controller.staff;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.SubjectService;

import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/staff/subject")
public class SubjectStaffController {

    private final SubjectService subjectService;
    private final GradeService gradeService;

    private static final String STAFFF_LAYOUT_VIEW = "staff/subject/show";
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
            @RequestParam(name = "sortField", defaultValue = "createdAt") String sortField,
            @RequestParam(name = "sortDir", defaultValue = "desc") String sortDir) {
        Sort.Direction direction = sortDir.equalsIgnoreCase(Sort.Direction.ASC.name()) ? Sort.Direction.ASC
                : Sort.Direction.DESC;
        Sort sortOrder = Sort.by(direction, sortField);
        Pageable pageable = PageRequest.of(page, size, sortOrder);
        Page<Subject> subjectPage = subjectService.getAllSubjects(filterName, filterGradeId, pageable);

        model.addAttribute("subjectPage", subjectPage);
        model.addAttribute("subjects", subjectPage.getContent());
        model.addAttribute("viewName", "list_content");
        model.addAttribute("filterName", filterName);
        model.addAttribute("filterGradeId", filterGradeId);
        addGradesToModelForFilter(model); // Grades cho filter dropdown
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
        model.addAttribute("customDateFormatter", formatter);
        model.addAttribute("subjectImageFolder", SUBJECT_IMAGE_TARGET_FOLDER);
        return STAFFF_LAYOUT_VIEW;
    }



}