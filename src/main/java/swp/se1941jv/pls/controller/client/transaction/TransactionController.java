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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Transaction;
import swp.se1941jv.pls.entity.TransactionStatus;
import swp.se1941jv.pls.entity.User;
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

    public TransactionController(UploadService uploadService, UserService userService, PackageService packageService,
            TransactionService transactionService) {
        this.uploadService = uploadService;
        this.userService = userService;
        this.packageService = packageService;
        this.transactionService = transactionService;
    }

    @GetMapping("/parent/checkout")
    public String showPaymentPage(Model model, @RequestParam("price") Double price,
            @RequestParam("packages") List<Long> packageIds, HttpSession session) {
        long userId = (long) session.getAttribute("id");
        String bankCode = "TECHCOMBANK";
        String accountNumber = "6365210105";
        String accountName = "NGUYEN BA MINH";
        Double amount = price;

        String dateTime = new SimpleDateFormat("yyMMddHHmmss ").format(new Date());

        String addInfo = "PLS " + userId + " " + dateTime
                + " " + UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        String amountFormatted;
        if (amount % 1 == 0) {
            amountFormatted = String.format("%.0f", amount); // Không có phần thập phân
        } else {
            amountFormatted = String.format("%.2f", amount); // Có phần thập phân, hiển thị 2 chữ số
        }

        String qrUrl = String.format(
                "https://img.vietqr.io/image/%s-%s-compact2.png?amount=%s&addInfo=%s&accountName=%s",
                bankCode, accountNumber, amountFormatted, addInfo, accountName.replace(" ", "%20"));

        model.addAttribute("qrUrl", qrUrl);
        model.addAttribute("amount", amountFormatted);
        model.addAttribute("addInfo", addInfo);
        model.addAttribute("packageIds", packageIds);
        return "client/checkout/payment"; // sẽ trỏ đến: /WEB-INF/views/payment.jsp
    }

    @Transactional
    @PostMapping("/parent/checkout")
    public String handleCheckout(Model model, @RequestParam("transferCode") String transferCode,
            @RequestParam(value = "note", required = false) String note,
            @RequestParam("evidenceImage") MultipartFile evidenceImage,
            @RequestParam("amount") BigDecimal amount,
            @RequestParam("packageIds") List<Long> packageIds,
            @RequestParam("addInfo") String addInfo,
            HttpSession session) {

        // Validation
        if (transferCode == null || transferCode.trim().isEmpty()) {
            model.addAttribute("error", "Mã chuyển khoản không được để trống!");
            return "client/checkout/payment";
        }
        if (transactionService.isExistsByTransferCode(transferCode)) {
            model.addAttribute("error", "Mã chuyển khoản đã tồn tại!");
            return "client/checkout/payment";
        }

        String contentType = evidenceImage.getContentType();
        if (!evidenceImage.isEmpty() && !isImageFile(contentType)) {
            model.addAttribute("fileError", "Chỉ được chọn ảnh định dạng PNG, JPG, JPEG!");
            return "client/checkout/payment";
        }

        long userId = (long) session.getAttribute("id");
        User user = this.userService.getUserById(userId);
        Transaction transaction = new Transaction();

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
            return "client/checkout/payment";
        }
        transaction.setPackages(packages);

        String image = this.uploadService.handleSaveUploadFile(evidenceImage, "transaction");
        if (!image.isEmpty()) {
            transaction.setEvidenceImage(image);
        }

        if (note != null && !note.isEmpty()) {
            transaction.setNote(note);
        }

        transaction.setTransferCode(transferCode);
        transaction.setUser(user);
        transaction.setAmount(amount);
        transaction.setAddInfo(addInfo);
        transaction.setStatus(TransactionStatus.PENDING);
        this.transactionService.save(transaction);
        return "";
    }

    private boolean isImageFile(String contentType) {
        return contentType != null &&
                (contentType.equals("image/png") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/jpeg"));
    }
}
