package swp.se1941jv.pls.controller.client;

import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.request.CreateStudentRequest;
import swp.se1941jv.pls.service.UserService;
import swp.se1941jv.pls.service.UploadService;

@Controller
@RequestMapping("/parent")
public class ParentController {
    private final UserService userService;
    private final UploadService uploadService;

    public ParentController(UserService userService, UploadService uploadService) {
        this.userService = userService;
        this.uploadService = uploadService;
    }

    @GetMapping("/create-student")
    public String showCreateStudentForm(Model model) {
        model.addAttribute("studentRequest", new CreateStudentRequest());
        return "client/parent/create_student_form";
    }

    @PostMapping("/create-student")
    public String handleCreateStudent(
            @Valid @ModelAttribute("studentRequest") CreateStudentRequest studentRequest,
            BindingResult bindingResult,
            Authentication authentication,
            RedirectAttributes redirectAttributes,
            @RequestParam("avatarFile") MultipartFile avatarFile,
            Model model) {

        if (bindingResult.hasErrors()) {
            return "client/parent/create_student_form";
        }

        String avatarFileName = null;
        if (!avatarFile.isEmpty()) {
            if (!isImageFile(avatarFile.getContentType())) {
                model.addAttribute("fileError", "Chỉ được chọn ảnh định dạng PNG, JPG, JPEG!");
                return "client/parent/create_student_form";
            }
            avatarFileName = this.uploadService.handleSaveUploadFile(avatarFile, "avatar");
        }

        try {
            String parentEmail = authentication.getName();
            userService.createStudentByParent(studentRequest, parentEmail, avatarFileName);
            redirectAttributes.addFlashAttribute("successMessage", "Tạo tài khoản cho học sinh thành công!");
            return "redirect:/parent/create-student";

        } catch (RuntimeException e) {
            if (e.getMessage().toLowerCase().contains("email")) {
                bindingResult.rejectValue("email", "error.studentRequest", e.getMessage());
            } else if (e.getMessage().toLowerCase().contains("số điện thoại")) {
                bindingResult.rejectValue("phoneNumber", "error.studentRequest", e.getMessage());
            } else {
                model.addAttribute("errorMessage", e.getMessage());
            }
            return "client/parent/create_student_form";
        }
    }

    @GetMapping("/homepage/show")
    public String showHomepage() {
        return "client/homepage/show";
    }

    private boolean isImageFile(String contentType) {
        return contentType != null &&
                (contentType.equals("image/png") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/jpeg"));
    }
}
