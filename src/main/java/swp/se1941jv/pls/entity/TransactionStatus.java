package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "transaction_status")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TransactionStatus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "transaction_status_id")
    Long transactionStatusId;

    @Column(name = "transaction_status_name", columnDefinition = "NVARCHAR(255)")
    String transactionStatusName;

    @Column(name = "transaction_description", columnDefinition = "NVARCHAR(255)")
    String transactionDescription;

    @OneToMany(mappedBy = "status")
    List<TransactionHistory> transactionHistories;
}