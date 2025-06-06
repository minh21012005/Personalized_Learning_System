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

    public boolean existsByChapterNameAndSubject(String chapterName, Subject subject) {
        return chapterRepository.existsByChapterNameAndSubject(chapterName, subject);
    }

    public void saveChapter(Chapter chapter){
        this.chapterRepository.save(chapter);
    }

    public List<Chapter> getChaptersBySubject(Subject subject) {
        return chapterRepository.findBySubject(subject);
    }

    public Optional<Chapter> getChapterByChapterId(Long chapterId) {
        return chapterRepository.getChapterByChapterId(chapterId);
    }

    public Page<Chapter> findChapters(Long subjectId, String chapterName, Boolean status, Pageable pageable) {
        Specification<Chapter> spec = Specification.where(null);
        if(subjectId != null){
            spec = spec.and(ChapterSpecifications.hasSubjectId(subjectId));
        }

        if (chapterName != null && !chapterName.isEmpty()) {
            spec = spec.and(ChapterSpecifications.hasName(chapterName));

        }

        if (status != null) {
            spec = spec.and(ChapterSpecifications.hasStatus(status));
        }
        return chapterRepository.findAll(spec, pageable);
    }
}
