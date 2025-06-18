package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "transactions")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Transaction extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long transactionId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    User user;

    @ManyToMany
    @JoinTable(name = "transaction_package", joinColumns = @JoinColumn(name = "transaction_id"), inverseJoinColumns = @JoinColumn(name = "package_id"))
    List<Package> packages;

    @NotNull
    BigDecimal amount;

    @NotNull
    @Column(unique = true)
    String transferCode;

    @Column(name = "add_info", nullable = false)
    String addInfo;

    String evidenceImage;

    @Enumerated(EnumType.STRING)
    TransactionStatus status;

    @Column(columnDefinition = "TEXT")
    String note;

    LocalDateTime confirmedAt; // Thời điểm xác nhận SUCCESS

    LocalDateTime rejectedAt; // Thời điểm từ chối REJECTED

    @ManyToOne
    @JoinColumn(name = "processed_by")
    User processedBy; // Người xử lý (SUCCESS hoặc REJECTED)

    @Column(columnDefinition = "TEXT")
    String rejectionReason;
}
