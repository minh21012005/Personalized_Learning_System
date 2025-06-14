package swp.se1941jv.pls.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.exception.*;
import swp.se1941jv.pls.repository.ChapterRepository;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.service.specification.ChapterSpecifications;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChapterService {

    private final ChapterRepository chapterRepository;
    private final SubjectRepository subjectRepository;
    private final LessonService lessonService;

    /**
     * Lưu hoặc cập nhật chương từ entity.
     *
     * @param chapter Entity chứa thông tin chương
     * @throws ValidationException nếu dữ liệu đầu vào không hợp lệ
     * @throws DuplicateNameException nếu tên chương đã tồn tại
     * @throws NotFoundException nếu môn học hoặc chương không tồn tại
     */
    @Transactional
    public void saveChapter(Chapter chapter) {
        if (chapter == null) {
            throw new ValidationException("Dữ liệu chương không được để trống");
        }
        if (chapter.getSubject() == null || chapter.getSubject().getSubjectId() == null) {
            throw new ValidationException("ID môn học không hợp lệ");
        }

        Long subjectId = chapter.getSubject().getSubjectId();
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new NotFoundException("Môn học không tồn tại"));

        if (chapterRepository.existsByChapterNameAndSubject(chapter.getChapterName(), subject)) {
            if (chapter.getChapterId() == null ||
                    !chapterRepository.findById(chapter.getChapterId())
                            .map(c -> c.getChapterName().equals(chapter.getChapterName()))
                            .orElse(false)) {
                throw new DuplicateNameException("Tên chương đã tồn tại cho môn học này");
            }
        }

        if (chapter.getChapterId() != null && !chapterRepository.existsById(chapter.getChapterId())) {
            throw new NotFoundException("Chương không tồn tại");
        }

        if (chapter.getChapterId() == null) {
            chapter.setStatus(true);
        }

        try {
            chapterRepository.save(chapter);
            log.info("Chapter saved: chapterId={}", chapter.getChapterId());
        } catch (Exception e) {
            log.error("Failed to save chapter: {}", e.getMessage(), e);
            throw new ApplicationException("SAVE_ERROR", "Lỗi khi lưu chương", e);
        }
    }

    /**
     * Cập nhật trạng thái của nhiều chương.
     *
     * @param chapterIds Danh sách ID chương
     * @throws ValidationException nếu danh sách chapterIds không hợp lệ
     * @throws NotFoundException nếu không tìm thấy chương
     */
    @Transactional
    public void toggleChaptersStatus(List<Long> chapterIds) {
        if (chapterIds == null || chapterIds.isEmpty()) {
            throw new ValidationException("Danh sách ID chương không được để trống");
        }
        if (chapterIds.stream().anyMatch(id -> id == null || id <= 0)) {
            throw new ValidationException("ID chương không hợp lệ trong danh sách");
        }

        List<Chapter> chapters = chapterRepository.findAllById(chapterIds);
        if (chapters.isEmpty()) {
            throw new NotFoundException("Không tìm thấy chương nào trong danh sách");
        }

        try {
            chapters.forEach(chapter -> chapter.setStatus(!chapter.getStatus()));
            chapterRepository.saveAll(chapters);
            log.info("Updated status for chapters: {}", chapterIds);
        } catch (Exception e) {
            log.error("Failed to update chapter status: {}", e.getMessage(), e);
            throw new ApplicationException("UPDATE_ERROR", "Lỗi khi cập nhật trạng thái chương", e);
        }
    }

    /**
     * Lọc danh sách chương theo subjectId, tên, và trạng thái với dữ liệu cơ bản.
     *
     * @param subjectId ID của môn học
     * @param chapterName Tên chương (tùy chọn)
     * @param status Trạng thái (tùy chọn)
     * @return Danh sách ChapterResponseDTO với dữ liệu cơ bản
     * @throws ValidationException nếu subjectId không hợp lệ
     * @throws NotFoundException nếu môn học không tồn tại
     */
    public List<ChapterResponseDTO> findChaptersBySubjectId(Long subjectId, String chapterName, Boolean status) {
        if (subjectId == null || subjectId <= 0) {
            throw new ValidationException("ID môn học không hợp lệ");
        }
        if (!subjectRepository.existsById(subjectId)) {
            throw new NotFoundException("Môn học không tồn tại");
        }

        Specification<Chapter> spec = Specification.where(ChapterSpecifications.hasSubjectId(subjectId));
        if (chapterName != null && !chapterName.trim().isEmpty()) {
            spec = spec.and(ChapterSpecifications.hasName(chapterName));
        }
        if (status != null) {
            spec = spec.and(ChapterSpecifications.hasStatus(status));
        }

        try {
            return chapterRepository.findAll(spec).stream()
                    .map(chapter -> ChapterResponseDTO.builder()
                            .chapterId(chapter.getChapterId())
                            .chapterName(chapter.getChapterName())
                            .status(chapter.getStatus())
                            .listLesson(lessonService.findLessonsByChapterId(chapter.getChapterId(), null, null))
                            .build())
                    .toList();
        } catch (Exception e) {
            log.error("Failed to fetch chapters: {}", e.getMessage(), e);
            throw new ApplicationException("FETCH_ERROR", "Lỗi khi lấy danh sách chương", e);
        }
    }

    /**
     * Lấy thông tin chương theo ID dưới dạng entity.
     *
     * @param chapterId ID của chương
     * @return Optional chứa Chapter entity
     */
    public Optional<Chapter> getChapterById(Long chapterId) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
        }
        return chapterRepository.findById(chapterId);
    }

    /**
     * Lấy thông tin chương dưới dạng DTO đầy đủ.
     *
     * @param chapterId ID của chương
     * @param subjectId ID của môn học
     * @return ChapterResponseDTO
     * @throws NotFoundException nếu chương không tồn tại
     * @throws RelationshipException nếu chương không thuộc môn học
     * @throws ValidationException nếu chapterId hoặc subjectId không hợp lệ
     */
    public ChapterResponseDTO getChapterResponseById(Long chapterId, Long subjectId) {
        if (chapterId == null || chapterId <= 0) {
            throw new ValidationException("ID chương không hợp lệ");
        }
        if (subjectId == null || subjectId <= 0) {
            throw new ValidationException("ID môn học không hợp lệ");
        }

        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new NotFoundException("Chương không tồn tại"));
        if (!chapter.getSubject().getSubjectId().equals(subjectId)) {
            throw new RelationshipException("Chương không thuộc môn học này");
        }
        return ChapterResponseDTO.builder()
                .chapterId(chapter.getChapterId())
                .chapterName(chapter.getChapterName())
                .chapterDescription(chapter.getChapterDescription())
                .status(chapter.getStatus())
                .listLesson(new ArrayList<>())
                .build();
    }
}