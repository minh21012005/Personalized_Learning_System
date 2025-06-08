package swp.se1941jv.pls.controller.admin;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.SubjectService;
import swp.se1941jv.pls.service.UploadService;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.PackageService;

@Controller
public class PackageController {
    private final SubjectService subjectService;
    private final PackageService packageService;
    private final GradeService gradeService;
    private final UploadService uploadService;

    public PackageController(SubjectService subjectService, PackageService packageService, GradeService gradeService,
            UploadService uploadService) {
        this.subjectService = subjectService;
        this.packageService = packageService;
        this.gradeService = gradeService;
        this.uploadService = uploadService;

    }

    @GetMapping("/admin/package")
    public String getPackagePage(Model model,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String isActive,
            @RequestParam(required = false) Long gradeId) {

        Pageable pageable = PageRequest.of(page, 10, Sort.by(Sort.Direction.DESC, "packageId"));
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }

        Page<Package> packagePage = this.packageService.getFilteredPackage(keyword, isActive, gradeId, pageable);
        List<Grade> grades = this.gradeService.getAllGradesIsActive();
        model.addAttribute("grades", grades);
        model.addAttribute("packages", packagePage.getContent());
        model.addAttribute("currentPage", packagePage.getNumber());
        model.addAttribute("totalPages", packagePage.getTotalPages());
        model.addAttribute("totalItems", packagePage.getTotalElements());

        return "admin/package/show";

    }

    @GetMapping("/admin/package/create")
    public String getCreatePackage(Model model) {
        List<Subject> subjects = Collections.emptyList();
        List<Grade> grades = this.gradeService.getAllGradesIsActive();
        model.addAttribute("grades", grades);
        model.addAttribute("subjects", subjects);
        model.addAttribute("newPackage", new Package());
        return "admin/package/create";
    }

    @PostMapping("/admin/package/create")
    public String createPackage(
            @ModelAttribute("newPackage") @Valid Package newPackage,
            BindingResult bindingResult,
            @RequestParam(value = "subjects", required = false) List<Long> subjectIds,
            @RequestParam("file") MultipartFile file,
            Model model) {
        List<Grade> grades = this.gradeService.getAllGradesIsActive();
        Long gradeId = newPackage.getGrade() != null ? newPackage.getGrade().getGradeId() : null;
        List<Subject> subjects = gradeId != null ? this.subjectService.getSubjectsByGradeId(gradeId, true)
                : Collections.emptyList();

        // Gắn danh sách môn học và khối lớp vào model để hiển thị lại
        model.addAttribute("grades", grades);
        model.addAttribute("subjects", subjects);

        if (bindingResult.hasErrors()) {
            model.addAttribute("subjects", subjects);
            return "admin/package/create";
        }
        if (this.packageService.existsByName(newPackage.getName())) {
            model.addAttribute("subjects", subjects);
            bindingResult.rejectValue("name", "error.newPackage", "Tên đã được sử dụng!");
            return "admin/package/create";
        }
        // Kiểm tra chọn môn học
        if (subjectIds == null || subjectIds.isEmpty()) {
            bindingResult.reject("subjectsError", "Phải chọn ít nhất một môn học!");

            return "admin/package/create";
        }
        String contentType = file.getContentType();
        if (!file.isEmpty() && !isImageFile(contentType)) {
            bindingResult.rejectValue("image", "error.newPackage", "Chỉ được chọn ảnh định dạng PNG, JPG,JPEG!!");

            return "admin/package/create";
        }
        if (file.isEmpty()) {

            bindingResult.rejectValue("image", "error.newPackage", "Không được bỏ trống ảnh");
        }
        List<Long> validSubjectIds = subjects.stream().map(Subject::getSubjectId).collect(Collectors.toList());
        if (subjectIds.stream().anyMatch(id -> !validSubjectIds.contains(id))) {
            bindingResult.reject("subjectsError", "Một hoặc nhiều môn học không hợp lệ!");

            return "admin/user/create";
        }
        if (gradeId == null) {
            bindingResult.rejectValue("grade.gradeId", "error.newPackage", "Phải chọn một khối lớp!");
            return "admin/package/create";
        }

        Optional<Grade> grade = this.gradeService.getGradeById(gradeId);
        if (grade == null) {
            bindingResult.rejectValue("grade.gradeId", "error.newPackage", "Khối lớp không hợp lệ!");
            return "admin/package/create";
        }
        String packageImage = this.uploadService.handleSaveUploadFile(file, "package");
        // Lưu Package và mối quan hệ Package-Subject
        newPackage.setImage(packageImage);
        this.packageService.savePackageWithSubjects(newPackage, subjectIds);

        return "redirect:/admin/grade";
    }

    // Hàm kiểm tra content type của file có phải là ảnh hợp lệ
    private boolean isImageFile(String contentType) {
        return contentType != null &&
                (contentType.equals("image/png") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/jpeg"));
    }

}