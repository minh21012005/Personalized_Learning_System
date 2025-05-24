package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "role")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Role {
    @Id
    @Column(name = "role_name")
    String roleName;

    @Column(name = "role_description", columnDefinition = "NVARCHAR(255)")
    String roleDescription;

    @OneToMany(mappedBy = "role")
    List<User> users;
}