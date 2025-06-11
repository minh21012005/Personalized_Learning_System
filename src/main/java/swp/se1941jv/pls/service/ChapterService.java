package swp.se1941jv.pls.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.repository.ChapterRepository;
import swp.se1941jv.pls.service.specification.ChapterSpecifications;

import java.util.List;
import java.util.Optional;

@Service
public class ChapterService {
    private final ChapterRepository chapterRepository;
    public ChapterService(ChapterRepository chapterRepository) {
        this.chapterRepository = chapterRepository;
    }

    /**
     * Tìm một chương theo ID.
     *
     * @param chapterId ID của chương
     * @return Optional chứa chương nếu tìm thấy
     */
    public Optional<Chapter> findChapterById(Long chapterId) {
        return chapterRepository.findById(chapterId);
    }

    public boolean existsByChapterNameAndSubject(String chapterName, Subject subject) {
        return chapterRepository.existsByChapterNameAndSubject(chapterName, subject);
    }

    public void saveChapter(Chapter chapter){
        this.chapterRepository.save(chapter);
    }



    // SỬA MỚI: Thay Page<Chapter> bằng List<Chapter> và nạp lessons
    public List<Chapter> findChapters(Long subjectId, String chapterName, Boolean status) {
        Specification<Chapter> spec = Specification.where(null);
        if (subjectId != null) {
            spec = spec.and(ChapterSpecifications.hasSubjectId(subjectId));
        }

        if (chapterName != null && !chapterName.isEmpty()) {
            spec = spec.and(ChapterSpecifications.hasName(chapterName));
        }

        if (status != null) {
            spec = spec.and(ChapterSpecifications.hasStatus(status));
        }
        return chapterRepository.findAll(spec);
    }
    // /SỬA MỚI

    public void updateChaptersStatus(List<Long> chapterIds) {
        List<Chapter> chapters = chapterRepository.findAllById(chapterIds);
        for (Chapter chapter : chapters) {
            chapter.setStatus(!chapter.getStatus()); // Đảo trạng thái
        }
        chapterRepository.saveAll(chapters);
    }

    public Optional<Chapter> getChapterByChapterIdAndStatusTrue(Long chapterId) {
        return chapterRepository.findByChapterIdAndStatusTrue(chapterId);
    }

    public List<Chapter> getChaptersBySubjectIdAndStatusTrue(Long subjectId) {
        return chapterRepository.findBySubjectSubjectIdAndStatusTrue(subjectId);
    }
}
