package swp.se1941jv.pls.controller.client.subject;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.SubjectService;

@Controller
public class ClientSubjectController {

    private final SubjectService subjectService;

    public ClientSubjectController(SubjectService subjectService) {
        this.subjectService = subjectService;
    }

    @GetMapping("/subject/detail/{id}")
    public String getDetailSubjectPage(Model model, @PathVariable("id") long id) {
        Optional<Subject> subject = this.subjectService.findById(id);
        if (subject.isEmpty()) {
            return "error/404";
        }
        List<Chapter> chapters = subject.get().getChapters().stream()
                .filter(chapter -> Boolean.TRUE.equals(chapter.getStatus()))
                .collect(Collectors.toList());
        model.addAttribute("totalChapter", chapters.size());
        model.addAttribute("chapters", chapters);
        model.addAttribute("subject", subject.get());
        return "client/subject/detail";
    }
}
