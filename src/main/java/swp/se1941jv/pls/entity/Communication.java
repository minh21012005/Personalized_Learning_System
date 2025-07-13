package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
import java.util.List;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "Communication")
@Data
@EqualsAndHashCode(callSuper = true, exclude = {"parentComment", "replies","user"})
@ToString(callSuper = true, exclude = {"parentComment", "replies","user"})
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)

public class Communication extends BaseEntity{

    @Getter
    public enum CommentStatus {
        PENDING("Chờ xử lý"),
        APPROVED("Chấp nhận"),
        REJECTED("Từ chối"),
        HIDDEN("Đã ẩn");

        private final String description;

        CommentStatus(String description) {
            this.description = description;
        }
      }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id", nullable = false)
    Lesson lesson;

    @Column(name = "content", nullable = false, columnDefinition = "TEXT")
    String content;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_comment_id")
    Communication parentComment;

    @OneToMany(mappedBy = "parentComment", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<Communication> replies;

    @ManyToOne(fetch = FetchType.LAZY)
     @JoinColumn(
            name = "user_created",
            referencedColumnName = "user_id",
            insertable = false,
            updatable = false
     )
     private User user;

    @Enumerated(EnumType.STRING)
    @Column(name = "comment_status", columnDefinition = "VARCHAR(20) DEFAULT 'PENDING' NOT NULL")
    CommentStatus commentStatus;

    @Column(name = "last_activity_at")
    private LocalDateTime lastActivityAt;

    @PrePersist
    public void prePersistDefaultValues() {
        if (this.commentStatus == null) {
            this.commentStatus = CommentStatus.PENDING;
        }
        if (this.lastActivityAt == null) {
        this.lastActivityAt = LocalDateTime.now();
        }
    }
}
