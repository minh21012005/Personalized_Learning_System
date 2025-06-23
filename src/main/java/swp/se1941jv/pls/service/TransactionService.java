package swp.se1941jv.pls.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Transaction;
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
            String status, LocalDate createdAt, Pageable pageable) {
        Specification<Transaction> spec = TransactionSpecification.filterTransactions(
                transferCode, email, studentEmail, packageIds, status, createdAt);
        return transactionRepository.findAll(spec, pageable);
    }
}
