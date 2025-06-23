package swp.se1941jv.pls.service.specification;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.data.jpa.domain.Specification;

import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Predicate;
import swp.se1941jv.pls.entity.Transaction;
import swp.se1941jv.pls.entity.TransactionStatus;
import swp.se1941jv.pls.entity.User;

public class TransactionSpecification {

    public static Specification<Transaction> filterTransactions(
            String transferCode,
            String email,
            String studentEmail,
            List<Long> packageIds,
            String status,
            LocalDate createdAt) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (transferCode != null && !transferCode.isEmpty()) {
                predicates.add(
                        cb.like(cb.lower(root.get("transferCode")), "%" + transferCode.trim().toLowerCase() + "%"));
            }

            if (email != null && !email.isEmpty()) {
                predicates
                        .add(cb.like(cb.lower(root.get("user").get("email")), "%" + email.trim().toLowerCase() + "%"));
            }

            if (studentEmail != null && !studentEmail.isEmpty()) {
                predicates.add(
                        cb.like(
                                cb.lower(root.get("student").get("email")),
                                "%" + studentEmail.trim().toLowerCase() + "%"));
            }

            if (packageIds != null && !packageIds.isEmpty()) {
                Join<Transaction, Package> joinPackages = root.join("packages", JoinType.INNER);
                predicates.add(joinPackages.get("packageId").in(packageIds));
                query.distinct(true);
            }

            if (status != null && !status.isEmpty()) {
                predicates.add(cb.equal(root.get("status"), TransactionStatus.valueOf(status)));
            }

            if (createdAt != null) {
                LocalDateTime start = createdAt.atStartOfDay();
                LocalDateTime end = createdAt.atTime(LocalTime.MAX);
                predicates.add(cb.between(root.get("createdAt"), start, end));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    public static Specification<Transaction> filterForUser(User user, String transferCode, String status,
            LocalDate fromDate, LocalDate toDate) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("user"), user));

            if (transferCode != null && !transferCode.isBlank()) {
                predicates.add(
                        cb.like(cb.lower(root.get("transferCode")), "%" + transferCode.toLowerCase().trim() + "%"));
            }

            if (status != null && !status.isBlank()) {
                predicates.add(cb.equal(root.get("status"), TransactionStatus.valueOf(status)));
            }

            if (fromDate != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("createdAt"), fromDate.atStartOfDay()));
            }

            if (toDate != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("createdAt"), toDate.atTime(23, 59, 59)));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
