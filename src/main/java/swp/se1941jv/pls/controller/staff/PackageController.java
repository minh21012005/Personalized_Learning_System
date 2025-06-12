package swp.se1941jv.pls.controller.staff;

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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.PackageStatus;
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

    @GetMapping("/staff/package")
    public String getPackagePage(Model model,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long gradeId) {

        Pageable pageable = PageRequest.of(page, 10, Sort.by(Sort.Direction.DESC, "packageId"));
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }

        Page<Package> packagePage = this.packageService.getFilteredPackage(keyword, status, gradeId, pageable);
        List<Grade> grades = this.gradeService.getAllGradesIsActive();
        model.addAttribute("grades", grades);
        model.addAttribute("packages", packagePage.getContent());
        model.addAttribute("currentPage", packagePage.getNumber());
        model.addAttribute("totalPages", packagePage.getTotalPages());
        model.addAttribute("totalItems", packagePage.getTotalElements());

        return "staff/package/show";

    }

    @GetMapping("/staff/package/create")
    public String getCreatePackage(Model model) {
        List<Subject> subjects = Collections.emptyList();
        List<Grade> grades = this.gradeService.getAllGradesIsActive();
        model.addAttribute("grades", grades);
        model.addAttribute("subjects", subjects);
        model.addAttribute("newPackage", new Package());

        return "staff/package/create";
    }

    @PostMapping("/staff/package/create")
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
            return "staff/package/create";
        }
        if (this.packageService.existsByName(newPackage.getName())) {
            model.addAttribute("subjects", subjects);
            bindingResult.rejectValue("name", "error.newPackage", "Tên đã được sử dụng!");
            return "staff/package/create";
        }
        // Kiểm tra chọn môn học
        if (subjectIds == null || subjectIds.isEmpty()) {
            bindingResult.reject("subjectsError", "Phải chọn ít nhất một môn học!");

            return "staff/package/create";
        }
        String contentType = file.getContentType();
        if (!file.isEmpty() && !isImageFile(contentType)) {
            bindingResult.rejectValue("image", "error.newPackage", "Chỉ được chọn ảnh định dạng PNG, JPG,JPEG!!");

            return "staff/package/create";
        }
        if (file.isEmpty()) {

            bindingResult.rejectValue("image", "error.newPackage", "Không được bỏ trống ảnh");
        }
        List<Long> validSubjectIds = subjects.stream().map(Subject::getSubjectId).collect(Collectors.toList());
        if (subjectIds.stream().anyMatch(id -> !validSubjectIds.contains(id))) {
            bindingResult.reject("subjectsError", "Một hoặc nhiều môn học không hợp lệ!");

            return "staff/package/create";
        }
        if (gradeId == null) {
            bindingResult.rejectValue("grade.gradeId", "error.newPackage", "Phải chọn một khối lớp!");
            return "staff/package/create";
        }

        Optional<Grade> grade = this.gradeService.getGradeById(gradeId);
        if (grade == null) {
            bindingResult.rejectValue("grade.gradeId", "error.newPackage", "Khối lớp không hợp lệ!");
            return "staff/package/create";
        }
        String packageImage = this.uploadService.handleSaveUploadFile(file, "package");
        // Lưu Package và mối quan hệ Package-Subject
        newPackage.setImage(packageImage);
        newPackage.setStatus(PackageStatus.PENDING);
        newPackage.setActive(false);
        this.packageService.savePackageWithSubjects(newPackage, subjectIds);

        return "redirect:/staff/package";
    }

    // Hàm kiểm tra content type của file có phải là ảnh hợp lệ
    private boolean isImageFile(String contentType) {
        return contentType != null &&
                (contentType.equals("image/png") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/jpeg"));
    }

    @GetMapping(value = "/staff/package/view/{packageId}")
    public String viewDetailPackage(Model model,

            @PathVariable Long packageId,
            @RequestParam(required = false) String keyword) {

        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        try {
            Package pkg = this.packageService.findById(packageId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy gói lớp"));

            List<Subject> subjects = this.packageService.findSubjectsByPackageIdAndKeyword(packageId, keyword);
            Long count = this.packageService.getAmountOfUsersRegistor(packageId);
            if (pkg.getStatus() == PackageStatus.PENDING) {
                model.addAttribute("warning", "⚠ Gói này đang được xét duyệt. Dữ liệu chỉ để tham khảo.");
            }
            if (pkg.getStatus() == PackageStatus.REJECTED) {
                model.addAttribute("warning", "⚠ Gói này đã bị từ chối. Dữ liệu chỉ để tham khảo.");
            }

            model.addAttribute("count", count);
            model.addAttribute("subjects", subjects);
            model.addAttribute("pkg", pkg);

            model.addAttribute("keyword", keyword);
        } catch (IllegalArgumentException ex) {

            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("subjects", java.util.Collections.emptyList());
        }
        return "staff/package/view";
    }

    @GetMapping("/staff/package/update/{packageId}")
    public String getUpdatePackagePage(Model model, @PathVariable Long packageId) {
        try {

            Package pkg = this.packageService.findById(packageId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khối lớp"));
            if (pkg.getStatus() == PackageStatus.APPROVED) {
                model.addAttribute("errorMessage", "Không được chỉnh sửa gói đã duyệt");
                return "staff/package/view";
            }
            Long gradeId = pkg.getGrade() != null ? pkg.getGrade().getGradeId() : null;
            List<Subject> subjects = gradeId != null ? this.subjectService.getSubjectsByGradeId(gradeId, true)
                    : Collections.emptyList();
            List<Grade> grades = this.gradeService.getAllGradesIsActive();
            if (!pkg.isActive()) {
                model.addAttribute("warning",
                        "⚠ Gói học này đã ngừng hoạt động. Không thể chỉnh sửa danh sách gói học.");
            }
            model.addAttribute("grades", grades);
            model.addAttribute("subjects", subjects);
            model.addAttribute("pkg", pkg);

        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("subjects", java.util.Collections.emptyList());

        }
        return "staff/package/update";
    }

    @PostMapping("/staff/package/update")
    public String updatePackage(
            @ModelAttribute("pkg") @Valid Package pkg,
            BindingResult bindingResult,
            @RequestParam(value = "subjects", required = false) List<Long> subjectIds,
            @RequestParam("file") MultipartFile file,
            Model model) {
        List<Grade> grades = this.gradeService.getAllGradesIsActive();
        Long gradeId = pkg.getGrade() != null ? pkg.getGrade().getGradeId() : null;
        List<Subject> subjects = gradeId != null ? this.subjectService.getSubjectsByGradeId(gradeId, true)
                : Collections.emptyList();
        model.addAttribute("grades", grades);
        model.addAttribute("subjects", subjects);

        if (bindingResult.hasErrors()) {
            model.addAttribute("selectedSubjectIds", subjectIds);
            return "staff/package/update";
        }

        Package existingPackage = this.packageService.findById(pkg.getPackageId()).orElse(null);
        if (existingPackage.getStatus() == PackageStatus.APPROVED) {
            bindingResult.reject("statusError", "Không được chỉnh sửa gói đã duyệt");
            model.addAttribute("selectedSubjectIds", subjectIds);
            return "staff/package/update";
        }
        if (existingPackage == null) {
            model.addAttribute("error", "Gói học không tồn tại!");
            model.addAttribute("selectedSubjectIds", subjectIds);
            return "staff/package/update";
        }

        if (!existingPackage.getName().equals(pkg.getName()) && this.packageService.existsByName(pkg.getName())) {
            bindingResult.rejectValue("name", "error.pkg", "Tên gói đã được sử dụng!");
            model.addAttribute("selectedSubjectIds", subjectIds);
            return "staff/package/update";
        }

        if (subjectIds == null || subjectIds.isEmpty()) {
            bindingResult.reject("subjectsError", "Phải chọn ít nhất một môn học!");
            model.addAttribute("selectedSubjectIds", subjectIds);
            return "staff/package/update";
        }
        List<Long> validSubjectIds = subjects.stream().map(Subject::getSubjectId).collect(Collectors.toList());
        if (subjectIds.stream().anyMatch(id -> !validSubjectIds.contains(id))) {
            bindingResult.reject("subjectsError", "Một hoặc nhiều môn học không hợp lệ!");
            model.addAttribute("selectedSubjectIds", subjectIds);
            return "staff/package/update";
        }

        if (gradeId == null) {
            bindingResult.rejectValue("grade.gradeId", "error.pkg", "Phải chọn một khối lớp!");
            model.addAttribute("selectedSubjectIds", subjectIds);
            return "staff/package/update";
        }
        Optional<Grade> grade = this.gradeService.getGradeById(gradeId);
        if (!grade.isPresent()) {
            bindingResult.rejectValue("grade.gradeId", "error.pkg", "Khối lớp không hợp lệ!");
            model.addAttribute("selectedSubjectIds", subjectIds);
            return "staff/package/update";
        }

        String packageImage = existingPackage.getImage();
        if (!file.isEmpty()) {
            String contentType = file.getContentType();
            if (!isImageFile(contentType)) {
                bindingResult.rejectValue("image", "error.pkg", "Chỉ được chọn ảnh định dạng PNG, JPG, JPEG!");
                model.addAttribute("selectedSubjectIds", subjectIds);
                return "staff/package/update";
            }
            packageImage = this.uploadService.handleSaveUploadFile(file, "package");
        }

        pkg.setStatus(PackageStatus.PENDING);
        pkg.setActive(false);
        pkg.setImage(packageImage);

        this.packageService.savePackageWithSubjects(pkg, subjectIds);

        return "redirect:/staff/package";
    }

}