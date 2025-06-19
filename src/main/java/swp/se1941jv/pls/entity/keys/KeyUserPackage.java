package swp.se1941jv.pls.entity.keys;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Embeddable
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class KeyUserPackage implements Serializable {
    @Column(name = "user_id")
    private Long userId;

    @Column(name = "package_id")
    private Long packageId;
}