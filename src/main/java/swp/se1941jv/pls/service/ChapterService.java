package swp.se1941jv.pls.service;

import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.repository.ChapterRepository;

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
}
