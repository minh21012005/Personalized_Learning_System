package swp.se1941jv.pls.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import swp.se1941jv.pls.entity.PackageSubject;
import swp.se1941jv.pls.entity.Review;
import swp.se1941jv.pls.entity.ReviewStatus;
import swp.se1941jv.pls.entity.UserPackage;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
        Boolean existsByUser_UserIdAndPkg_PackageId(Long userId, Long packageId);

        List<Review> findByPkg_PackageId(Long packageId);

        List<Review> findBySubject_SubjectId(Long subjectId);

        List<Review> findByUser_UserIdAndPkg_PackageId(Long userId, Long packageId);

        List<Review> findByUser_UserIdAndSubject_SubjectId(Long userId, Long subjectId);

        @Modifying
        @Query("UPDATE Review r SET r.usefulCount = r.usefulCount + 1 WHERE r.reviewId = :reviewId")
        void incrementUsefulCount(Long reviewId);

        @EntityGraph(attributePaths = { "user" })
        List<Review> findByPkg_PackageIdAndStatus(Long packageId, ReviewStatus status);

        @EntityGraph(attributePaths = { "user" })
        List<Review> findByPkg_PackageIdAndStatusAndCommentContainingIgnoreCase(Long packageId, ReviewStatus status,
                        String comment);

        @EntityGraph(attributePaths = { "user" })
        List<Review> findByPkg_PackageIdAndStatusAndCommentContainingIgnoreCaseAndRating(Long packageId,
                        ReviewStatus status, String comment, Integer rating);

        @EntityGraph(attributePaths = { "user" })
        List<Review> findByPkg_PackageIdAndStatusAndRating(Long packageId, ReviewStatus status, Integer rating);

        // Phương thức để lấy review mới nhất (hoặc duy nhất) của người dùng cho một
        // package
        Review findTopByUser_UserIdAndPkg_PackageIdOrderByCreatedAtDesc(Long userId, Long packageId);

        Optional<Review> findByUser_UserIdAndSubject_SubjectIdAndStatus(Long userId, Long subjectId,
                        ReviewStatus status);

        Optional<Review> findTopByUser_UserIdAndSubject_SubjectIdOrderByCreatedAtDesc(Long userId, Long subjectId);

        List<Review> findBySubject_SubjectIdAndStatus(Long subjectId, ReviewStatus status);

        List<Review> findBySubject_SubjectIdAndStatusAndRating(Long subjectId, ReviewStatus status, Integer rating);

        List<Review> findBySubject_SubjectIdAndStatusAndCommentContainingIgnoreCase(Long subjectId, ReviewStatus status,
                        String comment);

        List<Review> findBySubject_SubjectIdAndStatusAndCommentContainingIgnoreCaseAndRating(Long subjectId,
                        ReviewStatus status, String comment, Integer rating);

        @EntityGraph(attributePaths = { "user" })
        Page<Review> findByPkg_PackageIdAndStatus(Long packageId, ReviewStatus status, Pageable pageable);

        @EntityGraph(attributePaths = { "user" })
        Page<Review> findByPkg_PackageIdAndStatusAndCommentContainingIgnoreCase(Long packageId, ReviewStatus status,
                        String comment, Pageable pageable);

        @EntityGraph(attributePaths = { "user" })
        Page<Review> findByPkg_PackageIdAndStatusAndRating(Long packageId, ReviewStatus status, Integer rating,
                        Pageable pageable);

        @EntityGraph(attributePaths = { "user" })
        Page<Review> findByPkg_PackageIdAndStatusAndCommentContainingIgnoreCaseAndRating(Long packageId,
                        ReviewStatus status, String comment, Integer rating, Pageable pageable);

        @EntityGraph(attributePaths = { "user" })
        Page<Review> findBySubject_SubjectIdAndStatus(Long subjectId, ReviewStatus status, Pageable pageable);

        @EntityGraph(attributePaths = { "user" })
        Page<Review> findBySubject_SubjectIdAndStatusAndCommentContainingIgnoreCase(Long subjectId, ReviewStatus status,
                        String comment, Pageable pageable);

        @EntityGraph(attributePaths = { "user" })
        Page<Review> findBySubject_SubjectIdAndStatusAndRating(Long subjectId, ReviewStatus status, Integer rating,
                        Pageable pageable);

        @EntityGraph(attributePaths = { "user" })
        Page<Review> findBySubject_SubjectIdAndStatusAndCommentContainingIgnoreCaseAndRating(Long subjectId,
                        ReviewStatus status, String comment, Integer rating, Pageable pageable);

}