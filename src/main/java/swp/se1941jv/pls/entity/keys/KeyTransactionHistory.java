package swp.se1941jv.pls.entity.keys;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Embeddable
@Data
@AllArgsConstructor
@NoArgsConstructor
public class KeyTransactionHistory implements Serializable {
    @Column(name = "transaction_id")
    private Long transactionId;

    @Column(name = "status_id")
    private Long statusId;
}