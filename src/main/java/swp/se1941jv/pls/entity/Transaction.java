package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "transaction")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Transaction extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "transaction_id")
    Long transactionId;

    @Column(name = "notes", columnDefinition = "NVARCHAR(255)")
    String notes;

    @Column(name = "status")
    String status;

    @Column(name = "amount")
    Double amount;

    @OneToMany(mappedBy = "transaction")
    List<TransactionHistory> transactionHistories;
}