package swp.se1941jv.pls.controller.content_manager;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.PackageStatus;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.PackageService;
import swp.se1941jv.pls.service.SubjectService;

import java.util.Collections;
import java.util.List;

@Controller
public class ManagerController {
    private final PackageService packageService;
    private final GradeService gradeService;
    private final SubjectService subjectService;

    public ManagerController(PackageService packageService, GradeService gradeService, SubjectService subjectService) {
        this.packageService = packageService;
        this.gradeService = gradeService;
        this.subjectService = subjectService;
    }

    // Danh sách gói học
    @GetMapping("/admin/package")
    public String getPackagePage(Model model,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long gradeId) {
        // Sắp xếp theo createdAt tăng dần
        Pageable pageable = PageRequest.of(page, 10, Sort.by(Sort.Direction.ASC, "createdAt"));
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
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("gradeId", gradeId);
        return "content-manager/package/show";
    }

    // Xem chi tiết gói học
    @GetMapping("/admin/package/view/{id}")
    public String viewPackage(Model model,
            @PathVariable("id") Long packageId,
            @RequestParam(required = false) String keyword) {
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        try {
            Package pkg = this.packageService.findById(packageId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy gói học"));
            List<Subject> subjects = this.packageService.findSubjectsByPackageIdAndKeyword(packageId, keyword);
            Long count = this.packageService.getAmountOfUsersRegistor(packageId);
            if (pkg.getStatus() == PackageStatus.PENDING) {
                model.addAttribute("warning", "Gói này đang chờ duyệt.");
            } else if (pkg.getStatus() == PackageStatus.REJECTED) {
                model.addAttribute("warning", "Gói này đã bị từ chối.");
            }
            model.addAttribute("count", count);
            model.addAttribute("subjects", subjects);
            model.addAttribute("pkg", pkg);
            model.addAttribute("keyword", keyword);
        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("subjects", Collections.emptyList());
        }
        return "content-manager/package/view";
    }

    // Duyệt gói học
    @PostMapping("/admin/package/approve/{id}")
    public String approvePackage(@PathVariable("id") Long packageId) {
        Package pkg = this.packageService.findById(packageId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy gói học"));
        if (pkg.getStatus() != PackageStatus.PENDING) {
            throw new IllegalStateException("Chỉ có thể duyệt gói ở trạng thái PENDING");
        }
        pkg.setStatus(PackageStatus.APPROVED);
        pkg.setActive(true);
        this.packageService.savePackage(pkg);
        return "redirect:/admin/package";

    }

    // Từ chối gói học
    @PostMapping("/admin/package/reject/{id}")
    public String rejectPackage(@PathVariable("id") Long packageId) {
        Package pkg = this.packageService.findById(packageId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy gói học"));
        if (pkg.getStatus() != PackageStatus.PENDING) {
            throw new IllegalStateException("Chỉ có thể từ chối gói ở trạng thái PENDING");
        }
        pkg.setStatus(PackageStatus.REJECTED);
        pkg.setActive(false);
        this.packageService.savePackage(pkg);
        return "redirect:/admin/package";

    }

    // Toggle trạng thái active
    @PostMapping("/admin/package/edit/{id}")
    public String toggleActive(@PathVariable("id") Long packageId) {
        Package pkg = this.packageService.findById(packageId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy gói học"));
        if (pkg.getStatus() != PackageStatus.APPROVED) {
            throw new IllegalStateException("Chỉ có thể chỉnh sửa trạng thái active cho gói APPROVED");
        }
        pkg.setActive(!pkg.isActive());

        this.packageService.savePackage(pkg);
        return "redirect:/admin/package";

    }
}