package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "lessons")
@Data
@EqualsAndHashCode(callSuper = true)
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Lesson extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "lesson_id")
    Long lessonId;

    @Column(name = "lesson_name", columnDefinition = "NVARCHAR(255)")
    String lessonName;

    @Column(name = "lesson_description", columnDefinition = "NVARCHAR(255)")
    String lessonDescription;

    @Column(name = "status", columnDefinition = "BOOLEAN DEFAULT TRUE")
    Boolean status;

    @Column(name = "video_src")
    String videoSrc;

    @Column(name = "materials_json", columnDefinition = "TEXT")
    String materialsJson;

    @Transient
    List<String> materials;

    @ManyToOne
    @JoinColumn(name = "chapter_id")
    Chapter chapter;

    @ManyToOne
    @JoinColumn(name = "test_id")
    Test test;

    @OneToMany(mappedBy = "lesson")
    List<QuestionBank> questions;

    @OneToMany(mappedBy = "lesson")
    List<SubjectTest> subjectTests;

    // Chuyển đổi materialsJson thành List<String> sau khi load từ DB
    @PostLoad
    private void deserializeMaterials() {
        try {
            if (materialsJson != null && !materialsJson.isEmpty()) {
                ObjectMapper mapper = new ObjectMapper();
                materials = mapper.readValue(materialsJson, new TypeReference<List<String>>() {});
            } else {
                materials = new ArrayList<>();
            }
        } catch (Exception e) {
            materials = new ArrayList<>();
        }
    }

    // Chuyển đổi List<String> thành materialsJson trước khi lưu vào DB
    @PrePersist
    @PreUpdate
    private void serializeMaterials() {
        try {
            ObjectMapper mapper = new ObjectMapper();
            materialsJson = mapper.writeValueAsString(materials != null ? materials : new ArrayList<>());
        } catch (Exception e) {
            materialsJson = "[]";
        }
    }
}