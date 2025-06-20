package swp.se1941jv.pls.controller.admin;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import swp.se1941jv.pls.entity.Transaction;
import swp.se1941jv.pls.service.PackageService;
import swp.se1941jv.pls.service.TransactionService;

@Controller
public class PaymentController {

    private final TransactionService transactionService;
    private final PackageService packageService;

    public PaymentController(TransactionService transactionService, PackageService packageService) {
        this.transactionService = transactionService;
        this.packageService = packageService;
    }

    @GetMapping("/admin/transaction")
    public String getTransactionPage(
            @RequestParam(required = false) String transferCode,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String studentEmail,
            @RequestParam(required = false) List<Long> packages,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate createdAt,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        Sort sortOption = Sort.by("createdAt").descending();

        if ("priceAsc".equals(sort)) {
            sortOption = Sort.by("amount").ascending();
        } else if ("priceDesc".equals(sort)) {
            sortOption = Sort.by("amount").descending();
        } else if ("createdAtAsc".equals(sort)) {
            sortOption = Sort.by("createdAt").ascending();
        } else if ("createdAtDesc".equals(sort)) {
            sortOption = Sort.by("createdAt").descending();
        }

        Pageable pageable = PageRequest.of(page - 1, size, sortOption);

        Page<Transaction> transactions = transactionService.getFilteredTransactions(
                transferCode, email, studentEmail, packages, status, createdAt, pageable);

        model.addAttribute("transactions", transactions.getContent());
        model.addAttribute("totalPage", transactions.getTotalPages());
        model.addAttribute("currentPage", page);
        model.addAttribute("packageList", packageService.getActivePackages());
        Map<String, Object> param = new HashMap<>();
        param.put("transferCode", transferCode);
        param.put("email", email);
        param.put("studentEmail", studentEmail);
        param.put("packages", packages);
        param.put("status", status);
        param.put("sort", sort);
        param.put("createdAt", createdAt != null ? createdAt.toString() : "");

        model.addAttribute("param", param);
        return "admin/transaction/show";
    }

    @GetMapping("/admin/transaction/{id}")
    public String getDetailTransactionPage(Model model, @PathVariable long id) {
        Optional<Transaction> transactionOptional = this.transactionService.findById(id);
        if (!transactionOptional.isPresent()) {
            return "error/404";
        }
        model.addAttribute("transaction", transactionOptional.get());
        return "admin/transaction/detail";
    }

    // @GetMapping("/admin/transaction/confirm/{id}")
    // public String confirmTransaction(Model model, @PathVariable long id){

    // }
}
