package swp.se1941jv.pls.service;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.exception.chapter.ChapterNotFoundException;
import swp.se1941jv.pls.exception.chapter.DuplicateChapterNameException;
import swp.se1941jv.pls.exception.chapter.InvalidChapterException;
import swp.se1941jv.pls.repository.ChapterRepository;
import swp.se1941jv.pls.service.specification.ChapterSpecifications;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ChapterService {
    private final ChapterRepository chapterRepository;
    private final LessonService lessonService;
    public ChapterService(ChapterRepository chapterRepository, LessonService lessonService) {
        this.chapterRepository = chapterRepository;
        this.lessonService = lessonService;
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
    public List<Chapter> findChaptersBySsubjectId(Long subjectId, String chapterName, Boolean status) {
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



    public ChapterResponseDTO getChapterResponseById(Long chapterId, Long subjectId) {
        Chapter chapter = chapterRepository.findByChapterIdAndStatusTrue(chapterId).orElse(null);
        if (chapter == null) {
            throw new ChapterNotFoundException("Chương không tồn tại");
        }
        if (!chapter.getSubject().getSubjectId().equals(subjectId)) {
            throw new InvalidChapterException("Chương không thuộc môn học này");
        }
        List<LessonResponseDTO> lessons = lessonService.getActiveLessonsResponseByChapterId(chapterId);
        return ChapterResponseDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .status(chapter.getStatus())
                .listLesson(lessons)
                .build();
    }

    public List<ChapterResponseDTO> getChaptersResponseBySubjectId(Long subjectId) {
        List<Chapter> chapters =chapterRepository.findBySubjectSubjectIdAndStatusTrue(subjectId);
        return chapters.stream()
                .map(chapter -> ChapterResponseDTO.builder()
                        .chapterId(chapter.getChapterId())
                        .chapterName(chapter.getChapterName())
                        .chapterDescription(chapter.getChapterDescription())
                    .build())
                .toList();

    }

}
