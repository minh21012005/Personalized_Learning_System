package swp.se1941jv.pls.controller.client.transaction;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import swp.se1941jv.pls.entity.Cart;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Transaction;
import swp.se1941jv.pls.entity.TransactionStatus;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.CartService;
import swp.se1941jv.pls.service.PackageService;
import swp.se1941jv.pls.service.TransactionService;
import swp.se1941jv.pls.service.UploadService;
import swp.se1941jv.pls.service.UserService;

@Controller
public class TransactionController {

    private final UploadService uploadService;
    private final UserService userService;
    private final PackageService packageService;
    private final TransactionService transactionService;
    private final CartService cartService;

    public TransactionController(UploadService uploadService, UserService userService, PackageService packageService,
            TransactionService transactionService, CartService cartService) {
        this.uploadService = uploadService;
        this.userService = userService;
        this.packageService = packageService;
        this.transactionService = transactionService;
        this.cartService = cartService;
    }

    @GetMapping("/parent/checkout")
    public String showPaymentPage(Model model, @RequestParam("price") Double price,
            @RequestParam("packages") List<Long> packageIds, HttpSession session) {
        long userId = (long) session.getAttribute("id");
        User user = this.userService.getUserById(userId);
        List<User> students = user.getChildren();
        String bankCode = "TECHCOMBANK";
        String accountNumber = "6365210105";
        String accountName = "NGUYEN BA MINH";
        Double amount = price;

        String dateTime = new SimpleDateFormat("yyMMddHHmmss ").format(new Date());

        String addInfo = "PLS " + userId + " " + dateTime
                + " " + UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        String amountFormatted;
        if (amount % 1 == 0) {
            amountFormatted = String.format("%.0f", amount);
        } else {
            amountFormatted = String.format("%.2f", amount);
        }

        String qrUrl = String.format(
                "https://img.vietqr.io/image/%s-%s-compact2.png?amount=%s&addInfo=%s&accountName=%s",
                bankCode, accountNumber, amountFormatted, addInfo, accountName.replace(" ", "%20"));

        model.addAttribute("qrUrl", qrUrl);
        model.addAttribute("amount", amountFormatted);
        model.addAttribute("addInfo", addInfo);
        model.addAttribute("packageIds", packageIds);
        model.addAttribute("students", students);
        model.addAttribute("transaction", new Transaction());
        return "client/checkout/payment";
    }

    @Transactional
    @PostMapping("/parent/checkout")
    public String handleCheckout(Model model,
            @RequestParam("image") MultipartFile evidenceImage,
            @RequestParam("packageIds") List<Long> packageIds,
            @RequestParam(value = "studentId", required = false) Long studentId,
            @ModelAttribute("transaction") @Valid Transaction transaction,
            BindingResult bindingResult,
            @RequestParam("qrUrl") String qrUrl,
            HttpSession session) {

        long userId = (long) session.getAttribute("id");
        User user = this.userService.getUserById(userId);
        List<User> students = user.getChildren();

        if (studentId == null) {
            model.addAttribute("studentIdError", "Vui lòng chọn học sinh!");
        }

        if (this.transactionService.isExistsByTransferCode(transaction.getTransferCode())) {
            bindingResult.rejectValue("transferCode", "error.transferCode", "Mã giao dịch đã tồn tại!");
        }

        if (bindingResult.hasErrors() || studentId == null) {
            model.addAttribute("qrUrl", qrUrl);
            model.addAttribute("amount", transaction.getAmount());
            model.addAttribute("addInfo", transaction.getAddInfo());
            model.addAttribute("packageIds", packageIds);
            model.addAttribute("students", students);
            return "client/checkout/payment";

        }

        String contentType = evidenceImage.getContentType();
        if (!evidenceImage.isEmpty() && !isImageFile(contentType)) {
            model.addAttribute("fileError", "Chỉ được chọn ảnh định dạng PNG, JPG, JPEG!");
            model.addAttribute("qrUrl", qrUrl);
            model.addAttribute("amount", transaction.getAmount());
            model.addAttribute("addInfo", transaction.getAddInfo());
            model.addAttribute("packageIds", packageIds);
            model.addAttribute("students", students);
            return "client/checkout/payment";
        }

        if (transaction.getPackages() == null) {
            transaction.setPackages(new ArrayList<>());
        }

        // Xử lý packages
        List<Package> packages = new ArrayList<>();
        for (Long pkgId : packageIds) {
            Optional<Package> pkgOptional = this.packageService.findById(pkgId);
            if (pkgOptional.isPresent()) {
                packages.add(pkgOptional.get());
            }
        }
        if (packages.isEmpty()) {
            model.addAttribute("error", "Không tìm thấy khóa hợp lệ!");
            model.addAttribute("qrUrl", qrUrl);
            model.addAttribute("amount", transaction.getAmount());
            model.addAttribute("addInfo", transaction.getAddInfo());
            model.addAttribute("packageIds", packageIds);
            model.addAttribute("students", students);
            return "client/checkout/payment";
        }
        transaction.setPackages(packages);

        String image = this.uploadService.handleSaveUploadFile(evidenceImage, "transaction");
        if (!image.isEmpty()) {
            transaction.setEvidenceImage(image);
        }

        if (transaction.getNote() != null && transaction.getNote().trim().isEmpty()) {
            transaction.setNote(null);
        }

        User student = this.userService.getUserById(studentId);
        transaction.setStudent(student);
        transaction.setUser(user);
        transaction.setStatus(TransactionStatus.PENDING);
        this.transactionService.save(transaction);
        Cart cart = this.cartService.getCartByUser(user);
        user.setCart(null);
        this.cartService.deleteCart(cart);
        return "client/checkout/confirm";
    }

    private boolean isImageFile(String contentType) {
        return contentType != null &&
                (contentType.equals("image/png") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/jpeg"));
    }
}
