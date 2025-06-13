package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.CreationTimestamp;
import swp.se1941jv.pls.entity.keys.KeyTransactionHistory;

import java.time.LocalDateTime;

@Entity
@Table(name = "transaction_history")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TransactionHistory {
    @EmbeddedId
    KeyTransactionHistory id;

    @ManyToOne
    @MapsId("transactionId")
    @JoinColumn(name = "transaction_id")
    Transaction transaction;

    @ManyToOne
    @MapsId("statusId")
    @JoinColumn(name = "status_id")
    TransactionStatus status;

    @CreationTimestamp
    @Column(name = "created_at")
    LocalDateTime createdAt;
}