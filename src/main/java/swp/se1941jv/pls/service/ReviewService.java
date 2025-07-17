package swp.se1941jv.pls.service;

import swp.se1941jv.pls.entity.Review;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.UserPackage;

import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.ReviewStatus;
import swp.se1941jv.pls.entity.TransactionStatus;
import swp.se1941jv.pls.repository.ReviewRepository;
import swp.se1941jv.pls.repository.UserPackageRepository;
import swp.se1941jv.pls.repository.UserRepository;
import swp.se1941jv.pls.repository.PackageSubjectRepository;
import swp.se1941jv.pls.repository.TransactionRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.criteria.Predicate;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.ArrayList;

@Service
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserPackageRepository userPackageRepository;
    private final PackageSubjectRepository packageSubjectRepository;
    private final TransactionRepository transactionRepository;
        private final UserRepository userRepository;
    
    @Autowired
    private UserService userService;

    public ReviewService(ReviewRepository reviewRepository, UserPackageRepository userPackageRepository,
            PackageSubjectRepository packageSubjectRepository, TransactionRepository transactionRepository,UserRepository userRepository) {
        this.reviewRepository = reviewRepository;
        this.userPackageRepository = userPackageRepository;
        this.packageSubjectRepository = packageSubjectRepository;
        this.transactionRepository = transactionRepository;
        this.userRepository =userRepository;
    }

    public List<Review> getReviewsByPackage(Long packageId) {
        return reviewRepository.findByPkg_PackageIdAndStatus(packageId, ReviewStatus.APPROVED);
    }

    public List<Review> getReviewsBySubject(Long subjectId) {
        return reviewRepository.findBySubject_SubjectId(subjectId);
    }

    public boolean canUserReviewPackage(Long userId, Long packageId) {
        if (userId == null || packageId == null) {
            return false;
        }
        return transactionRepository.existsByUserOrStudentIdAndPackageAndStatus(userId, packageId,
                TransactionStatus.APPROVED);
    }

    public boolean canUserReviewSubject(Long userId, Long subjectId) {
        if (userId == null || subjectId == null) {
            return false;
        }

        List<UserPackage> userPackages = userPackageRepository.findByUser_UserId(userId);
        LocalDateTime now = LocalDateTime.now();

        for (UserPackage userPackage : userPackages) {
            System.out.println("Now: " + now);
            System.out.println("Start: " + userPackage.getStartDate());
            System.out.println("End: " + userPackage.getEndDate());
            if (userPackage.getStartDate() != null && userPackage.getEndDate() != null &&
                    now.isAfter(userPackage.getStartDate()) && now.isBefore(userPackage.getEndDate())) {
                boolean subjectInPackage = packageSubjectRepository
                        .findByPkg_PackageIdAndSubject_SubjectId(userPackage.getPkg().getPackageId(), subjectId)
                        .isPresent();
                if (subjectInPackage) {
                    return true;
                }
            }
        }
        return false;
    }

    public List<Review> getReviewsByPackageAndFilters(Long packageId, String comment, Integer rating) {
        if (comment != null && !comment.isEmpty() && rating != null) {
            return reviewRepository.findByPkg_PackageIdAndStatusAndCommentContainingIgnoreCaseAndRating(
                    packageId, ReviewStatus.APPROVED, comment, rating);
        } else if (comment != null && !comment.isEmpty()) {
            return reviewRepository.findByPkg_PackageIdAndStatusAndCommentContainingIgnoreCase(
                    packageId, ReviewStatus.APPROVED, comment);
        } else if (rating != null) {
            return reviewRepository.findByPkg_PackageIdAndStatusAndRating(
                    packageId, ReviewStatus.APPROVED, rating);
        }
        return getReviewsByPackage(packageId);
    }

    public Review saveReview(Review review, User user, Package pkg, Subject subject) {
        if (user == null || (pkg == null && subject == null) || (pkg != null && subject != null)) {
            throw new IllegalArgumentException("Invalid review data");
        }
        review.setUser(user);
        review.setPkg(pkg);
        review.setSubject(subject);
        review.setStatus(ReviewStatus.PENDING);
        return reviewRepository.save(review);
    }
// public Review saveReview(Review review, Long userId, Package pkg, Subject subject) {
//         if (userId == null || (pkg == null && subject == null) || (pkg != null && subject != null)) {
//             throw new IllegalArgumentException("Invalid review data");
//         }

//         UserDTO userDTO = userRepository.findUserDTOById(userId)
//                 .orElseThrow(() -> new RuntimeException("User not found"));
//         // Tạo User entity từ DTO (chỉ cần userId để set vào Review)
//         User user = new User();
//         user.setUserId(userDTO.getUserId()); // Chỉ set userId, các trường khác không cần
//         review.setUser(user);
//         review.setPkg(pkg);
//         review.setSubject(subject);
//         review.setStatus(ReviewStatus.PENDING);
//         return reviewRepository.save(review);
//     }

    @Transactional
    public void toggleUsefulCount(Long reviewId) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new RuntimeException("Review not found"));
        if (review.getUsefulCount() > 0) {
            review.setUsefulCount(review.getUsefulCount() - 1);
        } else {
            review.setUsefulCount(review.getUsefulCount() + 1);
        }
        reviewRepository.save(review);
    }

    public boolean hasUserReviewedPackage(Long userId, Long packageId) {
        return reviewRepository.existsByUser_UserIdAndPkg_PackageId(userId, packageId);
    }

    public boolean hasPendingOrApprovedReview(Long userId, Long packageId) {
        List<Review> reviews = reviewRepository.findByUser_UserIdAndPkg_PackageId(userId, packageId);
        return reviews.stream().anyMatch(
                review -> review.getStatus() == ReviewStatus.PENDING || review.getStatus() == ReviewStatus.APPROVED);
    }

    public ReviewStatus getLatestReviewStatusForUser(Long userId, Long packageId) {
        Review review = reviewRepository.findTopByUser_UserIdAndPkg_PackageIdOrderByCreatedAtDesc(userId, packageId);
        return (review != null) ? review.getStatus() : null;
    }

    public boolean hasUserReviewedSubject(Long userId, Long subjectId) {
        boolean hasApproved = reviewRepository
                .findByUser_UserIdAndSubject_SubjectIdAndStatus(userId, subjectId, ReviewStatus.APPROVED).isPresent();
        boolean hasPending = reviewRepository
                .findByUser_UserIdAndSubject_SubjectIdAndStatus(userId, subjectId, ReviewStatus.PENDING).isPresent();
        return hasApproved || hasPending;
    }

    public List<Review> getReviewsBySubjectAndFilters(Long subjectId, String comment, Integer rating) {
        try {
            if (comment != null && !comment.isEmpty() && rating != null) {
                return reviewRepository.findBySubject_SubjectIdAndStatusAndCommentContainingIgnoreCaseAndRating(
                        subjectId, ReviewStatus.APPROVED, comment, rating);
            } else if (comment != null && !comment.isEmpty()) {
                return reviewRepository.findBySubject_SubjectIdAndStatusAndCommentContainingIgnoreCase(
                        subjectId, ReviewStatus.APPROVED, comment);
            } else if (rating != null) {
                return reviewRepository.findBySubject_SubjectIdAndStatusAndRating(
                        subjectId, ReviewStatus.APPROVED, rating);
            }
            return reviewRepository.findBySubject_SubjectIdAndStatus(subjectId, ReviewStatus.APPROVED);
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    public ReviewStatus getLatestReviewStatusForUserAndSubject(Long userId, Long subjectId) {
        try {
            Optional<Review> latestReview = reviewRepository
                    .findTopByUser_UserIdAndSubject_SubjectIdOrderByCreatedAtDesc(userId, subjectId);
            return latestReview.map(Review::getStatus).orElse(null);
        } catch (Exception e) {
            return null;
        }
    }

    public Page<Review> filterReviews(String type, Long packageId, Long subjectId, ReviewStatus status, Integer rating,
            String comment, Pageable pageable) {
        Specification<Review> spec = (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Xử lý type (Package hoặc Subject)
            if (type != null && !type.isEmpty()) {
                if ("Package".equals(type)) {
                    if (packageId != null) {
                        predicates.add(criteriaBuilder.equal(root.get("pkg").get("packageId"), packageId));
                    } else {
                        predicates.add(criteriaBuilder.isNotNull(root.get("pkg")));
                    }
                } else if ("Subject".equals(type)) {
                    if (subjectId != null) {
                        predicates.add(criteriaBuilder.equal(root.get("subject").get("subjectId"), subjectId));
                    } else {
                        predicates.add(criteriaBuilder.isNotNull(root.get("subject")));
                    }
                }
            }

            // Lọc theo trạng thái (không mặc định là APPROVED)
            if (status != null) {
                predicates.add(criteriaBuilder.equal(root.get("status"), status));
            }

            // Lọc theo rating
            if (rating != null) {
                predicates.add(criteriaBuilder.equal(root.get("rating"), rating));
            }

            // Lọc theo bình luận (không phân biệt hoa thường)
            if (comment != null && !comment.isEmpty()) {
                predicates.add(criteriaBuilder.like(
                        criteriaBuilder.lower(root.get("comment")),
                        "%" + comment.toLowerCase() + "%"));
            }

            // Kết hợp các điều kiện với AND
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

        return reviewRepository.findAll(spec, pageable);
    }

    public int getRate(int value) {
        List<Review> list = this.reviewRepository.findAll().stream()
                .filter(r -> r.getStatus().equals(ReviewStatus.APPROVED))
                .toList();
        List<Review> reviews = list.stream().filter(r -> r.getRating().intValue() == value).toList();
        return reviews.size();
    }
}