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
public class KeyPackageSubject implements Serializable {
    @Column(name = "package_id")
    private Long packageId;

    @Column(name = "subject_id")
    private Long subjectId;
}