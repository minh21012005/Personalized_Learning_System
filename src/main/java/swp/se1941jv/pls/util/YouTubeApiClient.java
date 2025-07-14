package swp.se1941jv.pls.util;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Helper class để xử lý các tác vụ liên quan đến YouTube API.
 */
@Component
@RequiredArgsConstructor
public class YouTubeApiClient {

    private static final String YOUTUBE_API_KEY = "AIzaSyAa9qz9xeYVePrsXLVIJJuA3qAhW4YXwqY";
    private static final String YOUTUBE_API_URL = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails,snippet&id={videoId}&key={apiKey}";
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    /**
     * Trích xuất video ID từ URL YouTube.
     *
     * @param videoSrc URL của video
     * @return Video ID hoặc null nếu không hợp lệ
     */
    public String extractVideoId(String videoSrc) {
        if (videoSrc == null || videoSrc.isEmpty()) {
            return null;
        }
        Pattern pattern = Pattern.compile("youtube\\.com/embed/([a-zA-Z0-9_-]{11})");
        Matcher matcher = pattern.matcher(videoSrc);
        return matcher.find() ? matcher.group(1) : null;
    }

    /**
     * Lấy thời lượng video từ YouTube API.
     *
     * @param videoId ID của video
     * @return Thời lượng video định dạng "X tiếng Y phút Z giây" hoặc null nếu lỗi
     */
    public String getVideoDuration(String videoId) {
        try {
            String url = YOUTUBE_API_URL.replace("{videoId}", videoId).replace("{apiKey}", YOUTUBE_API_KEY);
            String response = restTemplate.getForObject(url, String.class);

            JsonNode jsonNode = objectMapper.readTree(response);
            JsonNode items = jsonNode.get("items");

            if (items == null || items.size() == 0) {
                return null;
            }

            String duration = items.get(0).get("contentDetails").get("duration").asText();
            return formatDuration(duration);
        } catch (Exception e) {
            System.out.printf("Error fetching video duration for ID %s: %s%n", videoId, e.getMessage());
            return null;
        }
    }

    /**
     * Lấy tiêu đề video từ YouTube API.
     *
     * @param videoId ID của video
     * @return Tiêu đề video hoặc null nếu lỗi
     */
    public String getVideoTitle(String videoId) {
        try {
            String url = YOUTUBE_API_URL.replace("{videoId}", videoId).replace("{apiKey}", YOUTUBE_API_KEY);
            String response = restTemplate.getForObject(url, String.class);

            JsonNode jsonNode = objectMapper.readTree(response);
            JsonNode items = jsonNode.get("items");

            if (items == null || items.size() == 0) {
                return null;
            }

            return items.get(0).get("snippet").get("title").asText();
        } catch (Exception e) {
            System.out.printf("Error fetching video title for ID %s: %s%n", videoId, e.getMessage());
            return null;
        }
    }

    /**
     * Lấy URL thumbnail của video từ YouTube API.
     *
     * @param videoId ID của video
     * @return URL thumbnail (maxresdefault) hoặc null nếu lỗi
     */
    public String getThumbnailUrl(String videoId) {
        try {
            String url = YOUTUBE_API_URL.replace("{videoId}", videoId).replace("{apiKey}", YOUTUBE_API_KEY);
            String response = restTemplate.getForObject(url, String.class);

            JsonNode jsonNode = objectMapper.readTree(response);
            JsonNode items = jsonNode.get("items");

            if (items == null || items.size() == 0) {
                return null;
            }

            return items.get(0).get("snippet").get("thumbnails").get("maxres").get("url").asText();
        } catch (Exception e) {
            System.out.printf("Error fetching thumbnail URL for ID %s: %s%n", videoId, e.getMessage());
            return null;
        }
    }

    private String formatDuration(String duration) {
        Pattern pattern = Pattern.compile("PT(?:(\\d+)H)?(?:(\\d+)M)?(?:(\\d+)S)?");
        Matcher matcher = pattern.matcher(duration);
        if (!matcher.matches()) {
            return null;
        }

        int hours = matcher.group(1) != null ? Integer.parseInt(matcher.group(1)) : 0;
        int minutes = matcher.group(2) != null ? Integer.parseInt(matcher.group(2)) : 0;
        int seconds = matcher.group(3) != null ? Integer.parseInt(matcher.group(3)) : 0;

        StringBuilder formatted = new StringBuilder();
        if (hours > 0) {
            formatted.append(hours).append(" tiếng ");
        }
        if (minutes > 0 || hours > 0) {
            formatted.append(minutes).append(" phút ");
        }
        if (seconds > 0 || (hours == 0 && minutes == 0)) {
            formatted.append(seconds).append(" giây");
        }
        return formatted.toString().trim();
    }
}