package swp.se1941jv.pls.controller.client.course;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.PackageSubject;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.PackageService;
import swp.se1941jv.pls.service.SubjectService;

@Controller
public class CourseController {

    private final PackageService packageService;
    private final GradeService gradeService;
    private final SubjectService subjectService;

    public CourseController(PackageService packageService, GradeService gradeService, SubjectService subjectService) {
        this.packageService = packageService;
        this.gradeService = gradeService;
        this.subjectService = subjectService;
    }

    @GetMapping("/parent/course")
    public String getListCoursesPage(
            Model model,
            @RequestParam Optional<String> page,
            @RequestParam Optional<String> course,
            @RequestParam Optional<String> grades,
            @RequestParam Optional<String> subjects,
            @RequestParam Optional<String> sort) {
        int pageNumber;
        try {
            pageNumber = page.map(Integer::parseInt).orElse(1);
            if (pageNumber <= 0) {
                return "error/404";
            }
        } catch (Exception e) {
            pageNumber = 1;
        }

        int pageSize = 6;
        String courseFilter = course.orElse(null);
        String gradesFilter = grades.orElse(null);
        String subjectsFilter = subjects.orElse(null);
        String sortFilter = sort.orElse(null);

        // Create Sort object based on sortFilter
        Sort sortObj = Sort.by(Sort.Direction.DESC, "packageId"); // Default sort
        if ("increase".equals(sortFilter)) {
            sortObj = Sort.by(Sort.Direction.ASC, "price");
        } else if ("decrease".equals(sortFilter)) {
            sortObj = Sort.by(Sort.Direction.DESC, "price");
        }

        List<String> selectedGrades = gradesFilter != null && !gradesFilter.isEmpty()
                ? Arrays.asList(gradesFilter.split(","))
                : new ArrayList<>();
        List<String> selectedSubjects = subjectsFilter != null && !subjectsFilter.isEmpty()
                ? Arrays.asList(subjectsFilter.split(","))
                : new ArrayList<>();

        Pageable pageable = PageRequest.of(pageNumber - 1, pageSize, sortObj);
        Page<Package> pagePackage = this.packageService.findWithFilterPagination(courseFilter, selectedGrades,
                selectedSubjects,
                pageable);

        int totalPage = pagePackage.getTotalPages();
        if (pageNumber > totalPage && totalPage > 0) {
            return "error/404";
        }

        List<Package> packages = pagePackage.getContent();
        List<Grade> gradeList = this.gradeService.getAllGradesIsActive();
        List<Subject> subjectList = this.subjectService.fetchAllSubjects();

        model.addAttribute("packages", packages);
        model.addAttribute("gradeList", gradeList);
        model.addAttribute("subjectList", subjectList);
        model.addAttribute("currentPage", pageNumber);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("paramName", courseFilter);
        model.addAttribute("grades", gradesFilter);
        model.addAttribute("subjects", subjectsFilter);
        model.addAttribute("sort", sortFilter);
        return "client/course/show";
    }

    @GetMapping("/parent/course/detail/{id}")
    public String getDetailCoursePage(Model model, @PathVariable("id") long id) {
        Optional<Package> pkg = this.packageService.findById(id);
        if (pkg.isEmpty()) {
            return "error/404";
        }

        List<Subject> subjects = pkg.get().getPackageSubjects().stream()
                .map(PackageSubject::getSubject)
                .filter(subject -> Boolean.TRUE.equals(subject.getIsActive()))
                .collect(Collectors.toList());
        model.addAttribute("subjects", subjects);
        model.addAttribute("pkg", pkg.get());
        return "client/course/detail";
    }
}
