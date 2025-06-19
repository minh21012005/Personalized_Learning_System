package swp.se1941jv.pls.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Transaction;
import swp.se1941jv.pls.repository.TransactionRepository;

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
}
