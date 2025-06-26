package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "config")
@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Config extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Column(name = "config_key", nullable = false, unique = true)
    String configKey;

    @Column(name = "config_value", columnDefinition = "TEXT", nullable = false)
    String configValue;

    @Column(name = "description", columnDefinition = "TEXT")
    String description;
}