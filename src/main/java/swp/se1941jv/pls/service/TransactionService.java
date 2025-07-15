package swp.se1941jv.pls.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.TreeMap;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Transaction;
import swp.se1941jv.pls.entity.TransactionStatus;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.TransactionRepository;
import swp.se1941jv.pls.service.specification.TransactionSpecification;

@Service
public class TransactionService {

    private final TransactionRepository transactionRepository;

    public TransactionService(TransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    public void save(Transaction transaction) {
        this.transactionRepository.save(transaction);
    }

    public boolean isExistsByTransferCode(String code) {
        return this.transactionRepository.existsByTransferCode(code);
    }

    public List<Transaction> fetchAllTransactions() {
        return this.transactionRepository.findAll();
    }

    public Optional<Transaction> findById(Long id) {
        return this.transactionRepository.findById(id);
    }

    public Page<Transaction> getFilteredTransactions(String transferCode, String email, String studentEmail,
            List<Long> packageIds,
            String status, LocalDate fromDate, LocalDate toDate, Pageable pageable) {
        Specification<Transaction> spec = TransactionSpecification.filterTransactions(
                transferCode, email, studentEmail, packageIds, status, fromDate, toDate);
        return transactionRepository.findAll(spec, pageable);
    }

    public Page<Transaction> filterUserTransactions(User user, String transferCode, String status, LocalDate fromDate,
            LocalDate toDate, Pageable pageable) {
        Specification<Transaction> spec = TransactionSpecification.filterForUser(user, transferCode, status, fromDate,
                toDate);
        return transactionRepository.findAll(spec, pageable);
    }

    public BigDecimal getTotalRevenue() {
        List<Transaction> transactions = this.fetchAllTransactions();
        List<Transaction> lastList = transactions.stream()
                .filter(t -> t.getStatus().equals(TransactionStatus.APPROVED)).toList();

        BigDecimal total = BigDecimal.ZERO;
        for (Transaction transaction : lastList) {
            total = total.add(transaction.getAmount());
        }
        return total;
    }

    public List<Map<String, Object>> getMonthlyRevenue() {
        // Lấy thời điểm cách đây 6 tháng
        LocalDateTime sixMonthsAgo = LocalDateTime.now().minusMonths(6);

        // Lấy giao dịch có status = APPROVED và confirmedAt sau sixMonthsAgo
        List<Transaction> approvedTransactions = transactionRepository.findByStatusAndConfirmedAtAfter(
                TransactionStatus.APPROVED, sixMonthsAgo);

        // Nhóm theo tháng và tính tổng amount
        Map<String, BigDecimal> monthlyRevenue = new TreeMap<>();
        DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("yyyy-MM");
        DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("MMMM yyyy", new Locale("vi"));

        for (Transaction transaction : approvedTransactions) {
            LocalDateTime confirmedAt = transaction.getConfirmedAt();
            if (confirmedAt != null) {
                String monthKey = confirmedAt.format(monthFormatter);
                monthlyRevenue.merge(monthKey, transaction.getAmount(), BigDecimal::add);
            }
        }

        // Chuyển thành danh sách, giới hạn 6 tháng gần nhất
        List<Map<String, Object>> revenueData = new ArrayList<>();
        monthlyRevenue.entrySet().stream()
                .sorted(Map.Entry.comparingByKey()) // Sắp xếp theo tháng
                .limit(6) // Giới hạn 6 tháng
                .forEach(entry -> {
                    Map<String, Object> data = new HashMap<>();
                    // Chuyển yyyy-MM thành "Tháng X yyyy"
                    LocalDateTime date = LocalDateTime.parse(entry.getKey() + "-01T00:00:00");
                    String monthDisplay = date.format(displayFormatter);
                    data.put("month", monthDisplay);
                    data.put("amount", entry.getValue());
                    revenueData.add(data);
                });

        return revenueData;
    }
}
