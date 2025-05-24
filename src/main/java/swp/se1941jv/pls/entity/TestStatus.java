package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "test_status")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TestStatus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "test_status_id")
    Long testStatusId;

    @Column(name = "test_status_name", columnDefinition = "NVARCHAR(255)")
    String testStatusName;

    @Column(name = "description", columnDefinition = "NVARCHAR(255)")
    String description;

    @OneToMany(mappedBy = "testStatus")
    List<Test> tests;
}