package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
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

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    User student;

    @ManyToMany
    @JoinTable(name = "transaction_package", joinColumns = @JoinColumn(name = "transaction_id"), inverseJoinColumns = @JoinColumn(name = "package_id"))
    List<Package> packages;

    @NotNull
    BigDecimal amount;

    @NotBlank(message = "Mã giao dịch không được để trống!")
    @Size(min = 8, max = 20, message = "Mã giao dịch phải từ 8 đến 20 ký tự!")
    @Pattern(regexp = "^[A-Za-z0-9]+$", message = "Mã giao dịch chỉ được chứa chữ in hoa, chữ thường và số!")
    @Column(unique = true)
    String transferCode;

    @Column(name = "add_info", nullable = false)
    String addInfo;

    String evidenceImage;

    @Enumerated(EnumType.STRING)
    TransactionStatus status;

    @Size(max = 1000, message = "Ghi chú không được vượt quá 1000 ký tự!")
    @Column(columnDefinition = "TEXT")
    String note;

    LocalDateTime confirmedAt; // Thời điểm xác nhận SUCCESS

    LocalDateTime rejectedAt; // Thời điểm từ chối REJECTED

    @ManyToOne
    @JoinColumn(name = "processed_by")
    User processedBy; // Người xử lý (SUCCESS hoặc REJECTED)

    @Column(columnDefinition = "TEXT")
    @Size(min = 5, max = 1000, message = "Lý do từ chối phải từ 5 đến 1000 ký tự")
    String rejectionReason;

}
