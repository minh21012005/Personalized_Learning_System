package swp.se1941jv.pls.controller.admin;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import swp.se1941jv.pls.entity.Package;
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
    public String getTransactionPage(@RequestParam(required = false) String transferCode,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) List<Long> packages,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate createdAt,
            Model model) {
        List<Transaction> transactions = this.transactionService.fetchAllTransactions();
        List<Package> packageList = this.packageService.getActivePackages();
        model.addAttribute("packageList", packageList);
        model.addAttribute("transactions", transactions);
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
}
