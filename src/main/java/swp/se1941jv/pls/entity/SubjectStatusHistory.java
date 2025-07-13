package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Entity
@Table(name = "subject_status_history")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class SubjectStatusHistory {
    public enum SubjectStatus {
        DRAFT("Bản nháp"),
        PENDING("Chờ xử lý"),
        APPROVED("Chấp nhận"),
        REJECTED("Từ chối");

        private final String description;

        SubjectStatus(String description) {
            this.description = description;
        }

        public String getDescription() {
            return description;
        }
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "status_history_id")
    Long statusHistoryId;

    @ManyToOne
    @JoinColumn(name = "subject_id", nullable = false)
    Subject subject;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    SubjectStatus status;

    @Column(name = "changed_at", nullable = false)
    LocalDateTime changedAt;

    @ManyToOne
    @JoinColumn(name = "submitted_by")
    User submittedBy; // Người nộp nội dung (Content Creator)

    @ManyToOne
    @JoinColumn(name = "reviewer_id")
    User reviewer; // Người duyệt (Content Manager/Admin)

    @Column(name = "feedback", columnDefinition = "TEXT")
    String feedback; // Phản hồi khi từ chối
}