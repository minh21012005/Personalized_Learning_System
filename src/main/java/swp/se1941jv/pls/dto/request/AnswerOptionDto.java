package swp.se1941jv.pls.dto.request;

import lombok.Data;

@Data
public class AnswerOptionDto {
    private String text;
    private boolean isCorrect;
}