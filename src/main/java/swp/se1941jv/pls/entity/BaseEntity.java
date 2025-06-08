package swp.se1941jv.pls.entity;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.servlet.http.HttpSession;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.LastModifiedBy;
import swp.se1941jv.pls.config.SecurityUtils;
// import swp.se1941jv.pls.configuration.SecurityUtils;

import java.time.LocalDateTime;

@MappedSuperclass
@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PROTECTED)
public abstract class BaseEntity {
    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    LocalDateTime updatedAt;

    @CreatedBy
    @Column(name = "user_created", updatable = false)
    Long userCreated;

    @LastModifiedBy
    @Column(name = "user_updated")
    Long userUpdated;

    @PrePersist
    @PreUpdate
    protected void onPrePersistOrUpdate() {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId != null) {
            if (this.createdAt == null) { // Chỉ thiết lập userCreated khi là lần lưu mới
                this.userCreated = currentUserId;
            }
            this.userUpdated = currentUserId;
        }

        // Kiểm tra và serialize materials nếu entity có trường materialsJson (dùng instanceof Lesson)
        if (this instanceof Lesson) {
            Lesson lesson = (Lesson) this;
            try {
                ObjectMapper mapper = new ObjectMapper();
                lesson.setMaterialsJson(mapper.writeValueAsString(lesson.getMaterials() != null ? lesson.getMaterials() : new ArrayList<>()));
            } catch (Exception e) {
                lesson.setMaterialsJson("[]");
            }
        }
    }
}