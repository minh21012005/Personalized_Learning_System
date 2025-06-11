package swp.se1941jv.pls.service;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.exception.Chapter.ChapterNotFoundException;
import swp.se1941jv.pls.exception.Chapter.DuplicateChapterNameException;
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

    /**
     * Lưu hoặc cập nhật một chương.
     *
     * @param chapter Chương cần lưu
     * @param subject Môn học liên quan
     * @throws DuplicateChapterNameException nếu tên chương đã tồn tại
     * @throws ChapterNotFoundException      nếu chương không tồn tại khi cập nhật
     */
    @Transactional
    public void saveChapter(Chapter chapter, Subject subject) {
        if (chapter.getChapterId() == null) {
            // Tạo mới
            if (existsByChapterNameAndSubject(chapter.getChapterName(), subject)) {
                throw new DuplicateChapterNameException("Tên chương đã tồn tại cho môn học này");
            }
            chapter.setSubject(subject);
            chapter.setStatus(true);
        } else {
            // Cập nhật
            Chapter existingChapter = findChapterById(chapter.getChapterId())
                    .orElseThrow(() -> new ChapterNotFoundException("Chương không tồn tại"));
            if (!existingChapter.getChapterName().equals(chapter.getChapterName()) &&
                    existsByChapterNameAndSubject(chapter.getChapterName(), subject)) {
                throw new DuplicateChapterNameException("Tên chương đã tồn tại cho môn học này");
            }
            existingChapter.setChapterName(chapter.getChapterName());
            existingChapter.setChapterDescription(chapter.getChapterDescription());
            chapterRepository.save(existingChapter);
            return;
        }
        chapterRepository.save(chapter);
    }

    /**
     * Đổi trạng thái (true/false) của nhiều chương.
     *
     * @param chapterIds Danh sách ID của các chương
     */
    @Transactional
    public void toggleChaptersStatus(List<Long> chapterIds) {
        List<Chapter> chapters = chapterRepository.findAllById(chapterIds);
        for (Chapter chapter : chapters) {
            chapter.setStatus(!chapter.getStatus());
        }
        chapterRepository.saveAll(chapters);
    }

    /**
     * Kiểm tra xem tên chương đã tồn tại cho một môn học chưa.
     *
     * @param chapterName Tên chương
     * @param subject Môn học
     * @return true nếu tên chương đã tồn tại, false nếu không
     */
    public boolean existsByChapterNameAndSubject(String chapterName, Subject subject) {
        return chapterRepository.existsByChapterNameAndSubject(chapterName, subject);
    }

    /**
     * Lọc danh sách chương theo subjectId, chapterName, và status.
     *
     * @param subjectId ID của môn học
     * @param chapterName Tên chương
     * @param status Trạng thái (true/false)
     * @return Danh sách chương phù hợp
     */
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




    public List<Chapter> getChaptersBySubjectIdAndStatusTrue(Long subjectId) {
        return chapterRepository.findBySubjectSubjectIdAndStatusTrue(subjectId);
    }
}
