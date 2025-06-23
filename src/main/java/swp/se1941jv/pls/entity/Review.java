package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "review", uniqueConstraints = {
        @UniqueConstraint(columnNames = { "user_id", "package_id" }),
        @UniqueConstraint(columnNames = { "user_id", "subject_id" })
})
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Review extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "review_id")
    Long reviewId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    @NotNull(message = "Người dùng không được để trống!")
    User user;

    @ManyToOne
    @JoinColumn(name = "package_id")
    Package pkg;

    @ManyToOne
    @JoinColumn(name = "subject_id")
    Subject subject;

    @Column(name = "rating", nullable = false)
    @NotNull(message = "Số sao không được để trống!")
    @Min(value = 1, message = "Số sao phải từ 1 đến 5!")
    @Max(value = 5, message = "Số sao phải từ 1 đến 5!")
    Integer rating;

    @Column(name = "comment", columnDefinition = "NVARCHAR(500)")
    @Size(max = 500, message = "Bình luận không được vượt quá 500 ký tự!")
    String comment;

    @Column(name = "status", nullable = false)
    @NotNull(message = "Trạng thái không được để trống!")
    @Enumerated(EnumType.STRING)
    ReviewStatus status;

    @Column(name = "useful_count")
    @Builder.Default
    private Integer usefulCount = 0;

    @PrePersist
    @PreUpdate
    public void validatePackageOrSubject() {
        if ((pkg == null && subject == null) || (pkg != null && subject != null)) {
            throw new IllegalStateException("Đánh giá phải liên kết với đúng một package hoặc một subject!");
        }
    }
}