package swp.se1941jv.pls.dto.response.practice;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.util.List;
import java.util.Map;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class QuestionGenerationConfigDto {

    @JsonProperty("rules")
    private List<Rule> rules;

    @Data
    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Rule {
        @JsonProperty("correct_count_min")
        private Integer correctCountMin;

        @JsonProperty("correct_count_max")
        private Integer correctCountMax;

        @JsonProperty("levels")
        private Map<String, Integer> levels; // e.g., {"EASY": 4, "MEDIUM": 1, "HARD": 0}
    }
}