package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "package")
@Data

@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Package extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "package_id")
    Long packageId;

    @Column(name = "name", columnDefinition = "NVARCHAR(255)")
    @Size(min = 3, max = 255, message = "Tên gói phải từ 3 đến 255 ký tự")
    @Pattern(regexp = "^[\\p{L}0-9\\s\\-+]+$", message = "Tên gói không được chứa ký tự đặc biệt")
    @NotBlank(message = "Tên gói không được để trống")
    String name;

    @Column(name = "description", columnDefinition = "NVARCHAR(255)")
    @Size(max = 255, message = "Mô tả không được vượt quá 255 ký tự")
    @NotBlank(message = "Mô tả không được để trống")
    String description;
    @Column(name = "image")
    String image;

    @Column(name = "price")
    @Min(value = 1000, message = "Giá phải lớn hơn 0")
    @NotNull(message = "Giá không được để trống")
    Double price;

    @Column(name = "duration_days")
    @NotNull(message = "Số ngày hiệu lực không được để trống")
    @Min(value = 1, message = "Số ngày hiệu lực phải từ 1 ngày trở lên")
    @Max(value = 365, message = "Số ngày hiệu lực không được vượt quá 365 ngày")
    Integer durationDays;

    @Column(name = "is_active")
    boolean isActive;

    @OneToMany(mappedBy = "pkg")
    List<UserPackage> userPackages;

    @OneToMany(mappedBy = "pkg")
    List<PackageSubject> packageSubjects;

    @OneToMany(mappedBy = "pkg")
    List<CartPackage> cartPackages;

    @ManyToOne()
    @JoinColumn(name = "grade_id")
    Grade grade;

    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    @NotNull(message = "Trạng thái không được để trống")
    private PackageStatus status;
}