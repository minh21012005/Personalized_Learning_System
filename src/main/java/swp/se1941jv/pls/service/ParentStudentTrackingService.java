package swp.se1941jv.pls.service;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.dto.response.parentTracking.ParentChildOverviewDTO;
import swp.se1941jv.pls.dto.response.studentProgress.DailyOnlineTimeDTO;
import swp.se1941jv.pls.dto.response.studentProgress.LearningProgressDTO;
import swp.se1941jv.pls.dto.response.studentProgress.RecentLessonDTO;
import swp.se1941jv.pls.dto.response.studentProgress.RecentTestDTO;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.LessonProgressRepository;
import swp.se1941jv.pls.repository.UserPackageRepository;
import swp.se1941jv.pls.repository.UserRepository;
import swp.se1941jv.pls.repository.UserTestRepository;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ParentStudentTrackingService {

    private final LessonProgressRepository lessonProgressRepository;
    private final UserTestRepository userTestRepository;
    private final UserPackageRepository userPackageRepository;
    private final UserRepository userRepository;
    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public ParentStudentTrackingService(LessonProgressRepository lessonProgressRepository,
                                        UserTestRepository userTestRepository,
                                        UserPackageRepository userPackageRepository,
                                        UserRepository userRepository) {
        this.lessonProgressRepository = lessonProgressRepository;
        this.userTestRepository = userTestRepository;
        this.userPackageRepository = userPackageRepository;
        this.userRepository = userRepository;
    }

    public List<ParentChildOverviewDTO> getChildrenOverview(Long parentId) {
        User parent = userRepository.findById(parentId)
                .orElseThrow(() -> new RuntimeException("Phụ huynh không tồn tại"));
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd:MM:yy"); // Định dạng dd:MM:yy
        return parent.getChildren().stream()
                .map(child -> ParentChildOverviewDTO.builder()
                        .userId(child.getUserId())
                        .fullName(child.getFullName())
                        .dob(child.getDob() != null ? child.getDob().format(formatter) : "") // Định dạng trong service
                        .avatar(child.getAvatar())
                        .build())
                .collect(Collectors.toList());
    }

    // API: /api/parent/recent-lessons (Bài học gần đây)
    public List<RecentLessonDTO> getRecentLessons(Long childId, int page, int size) {
        PageRequest pageRequest = PageRequest.of(page, size);
        List<LessonProgress> recentActivities = lessonProgressRepository.findByUserUserIdOrderByUpdatedAtDesc(childId, pageRequest)
                .getContent();
        return recentActivities.stream()
                .map(lp -> RecentLessonDTO.builder()
                        .lessonId(lp.getLesson().getLessonId())
                        .lessonName(lp.getLesson().getLessonName())
                        .lastUpdated(lp.getUpdatedAt() != null ? lp.getUpdatedAt().format(dateTimeFormatter) : null)
                        .isCompleted(lp.getIsCompleted())
                        .build())
                .collect(Collectors.toList());
    }

    public long getTotalActivities(Long childId) {
        return lessonProgressRepository.countByUserUserId(childId);
    }

    // API: /api/parent/daily-online-time
    public List<DailyOnlineTimeDTO> getDailyOnlineTime(Long childId, String startDate, String endDate, String timeRange) {
        LocalDate start = (startDate != null && !startDate.isEmpty()) ? LocalDate.parse(startDate) : LocalDate.now().minusDays(6);
        LocalDate end = (endDate != null && !endDate.isEmpty()) ? LocalDate.parse(endDate) : LocalDate.now();

        // Điều chỉnh start và end theo timeRange
        if ("month".equalsIgnoreCase(timeRange)) {
            start = start.withDayOfMonth(1);
            end = end.with(TemporalAdjusters.lastDayOfMonth());
        } else if ("year".equalsIgnoreCase(timeRange)) {
            start = start.withDayOfYear(1);
            end = end.withDayOfYear(1).plusYears(1).minusDays(1);
        }

        List<LessonProgress> progressData = lessonProgressRepository.findByUserIdAndLastUpdatedBetween(childId, start.atStartOfDay(), end.atTime(23, 59, 59));

        Map<LocalDate, Long> groupedData;
        switch (timeRange != null ? timeRange.toLowerCase() : "day") {
            case "month":
                groupedData = progressData.stream()
                        .collect(Collectors.groupingBy(
                                lp -> lp.getUpdatedAt().toLocalDate().withDayOfMonth(1),
                                Collectors.summingLong(lp -> lp.getWatchedTime() != null ? lp.getWatchedTime() : 0L)
                        ));
                break;
            case "year":
                groupedData = progressData.stream()
                        .collect(Collectors.groupingBy(
                                lp -> lp.getUpdatedAt().toLocalDate().withDayOfYear(1),
                                Collectors.summingLong(lp -> lp.getWatchedTime() != null ? lp.getWatchedTime() : 0L)
                        ));
                break;
            default: // day
                groupedData = progressData.stream()
                        .collect(Collectors.groupingBy(
                                lp -> lp.getUpdatedAt().toLocalDate(),
                                Collectors.summingLong(lp -> lp.getWatchedTime() != null ? lp.getWatchedTime() : 0L)
                        ));
        }

        // Tạo danh sách ngày/tháng/năm đầy đủ
        List<DailyOnlineTimeDTO> result = new ArrayList<>();
        LocalDate currentDate = start;
        LocalDate endDateObj = end;
        DateTimeFormatter dateFormatter;
        switch (timeRange != null ? timeRange.toLowerCase() : "day") {
            case "month":
                dateFormatter = DateTimeFormatter.ofPattern("MM-yyyy");
                Map<LocalDate, Long> monthlyData = progressData.stream()
                        .collect(Collectors.groupingBy(
                                lp -> lp.getUpdatedAt().toLocalDate().withDayOfMonth(1),
                                Collectors.summingLong(lp -> lp.getWatchedTime() != null ? lp.getWatchedTime() : 0L)
                        ));
                while (!currentDate.isAfter(endDateObj)) {
                    LocalDate monthStart = currentDate.withDayOfMonth(1);
                    long totalSeconds = monthlyData.getOrDefault(monthStart, 0L);
                    long totalMinutes = Math.round(totalSeconds / 60.0);
                    long hours = totalMinutes / 60;
                    long minutes = totalMinutes % 60;
                    String formattedDate = monthStart.format(dateFormatter);
                    result.add(DailyOnlineTimeDTO.builder()
                            .date(formattedDate)
                            .timeFormatted(String.format("%02d:%02d", hours, minutes))
                            .totalMinutes(totalMinutes)
                            .build());
                    currentDate = currentDate.plusMonths(1).withDayOfMonth(1);
                }
                break;
            case "year":
                dateFormatter = DateTimeFormatter.ofPattern("yyyy");
                Map<LocalDate, Long> yearlyData = progressData.stream()
                        .collect(Collectors.groupingBy(
                                lp -> lp.getUpdatedAt().toLocalDate().withDayOfYear(1),
                                Collectors.summingLong(lp -> lp.getWatchedTime() != null ? lp.getWatchedTime() : 0L)
                        ));
                while (!currentDate.isAfter(endDateObj)) {
                    LocalDate yearStart = currentDate.withDayOfYear(1);
                    long totalSeconds = yearlyData.getOrDefault(yearStart, 0L);
                    long totalMinutes = Math.round(totalSeconds / 60.0);
                    long hours = totalMinutes / 60;
                    long minutes = totalMinutes % 60;
                    String formattedDate = yearStart.format(dateFormatter);
                    result.add(DailyOnlineTimeDTO.builder()
                            .date(formattedDate)
                            .timeFormatted(String.format("%02d:%02d", hours, minutes))
                            .totalMinutes(totalMinutes)
                            .build());
                    currentDate = currentDate.plusYears(1).withDayOfYear(1);
                }
                break;
            default: // day
                dateFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                while (!currentDate.isAfter(endDateObj)) {
                    long totalSeconds = groupedData.getOrDefault(currentDate, 0L);
                    long totalMinutes = Math.round(totalSeconds / 60.0);
                    long hours = totalMinutes / 60;
                    long minutes = totalMinutes % 60;
                    String formattedDate = currentDate.format(dateFormatter);
                    result.add(DailyOnlineTimeDTO.builder()
                            .date(formattedDate)
                            .timeFormatted(String.format("%02d:%02d", hours, minutes))
                            .totalMinutes(totalMinutes)
                            .build());
                    currentDate = currentDate.plusDays(1);
                }
        }

        return result;
    }

    // API: /api/parent/recent-tests
    public List<RecentTestDTO> getRecentTests(Long childId, int page, int size) {
        PageRequest pageRequest = PageRequest.of(page, size);
        List<UserTest> recentTests = userTestRepository.findByUserUserIdOrderByTimeEndDesc(childId, pageRequest)
                .getContent();
        return recentTests.stream()
                .map(ut -> RecentTestDTO.builder()
                        .testId(ut.getTest().getTestId())
                        .testName(ut.getTest().getTestName())
                        .score(Math.round((ut.getTotalQuestions() > 0 ? (double) ut.getCorrectAnswers() / ut.getTotalQuestions() * 10 : 0.0) * 100) / 100.0)
                        .timeEnd(ut.getTimeEnd() != null ? ut.getTimeEnd().format(dateTimeFormatter) : null)
                        .build())
                .collect(Collectors.toList());
    }

    public long getTotalTests(Long childId) {
        return userTestRepository.countByUserUserId(childId);
    }

    // API: /api/parent/learning-progress
    public List<LearningProgressDTO> getLearningProgress(Long childId) {
        Map<Long, LearningProgressDTO> progressMap = new HashMap<>(); // Sử dụng Map để tránh trùng lặp

        // Lấy danh sách các package mà user đã đăng ký
        List<UserPackage> userPackages = userPackageRepository.findByUserUserId(childId);
        for (UserPackage userPackage : userPackages) {
            userPackage.getPkg().getPackageSubjects().forEach(packageSubject -> {
                User user = User.builder().userId(childId).build();
                List<LessonProgress> lessonProgress = lessonProgressRepository
                        .findByUserAndSubjectAndPackageEntity(user, packageSubject.getSubject(), userPackage.getPkg());

                long countCompletedLessons = lessonProgress.stream()
                        .filter(LessonProgress::getIsCompleted)
                        .count();

                long countLessons = packageSubject.getSubject().getChapters().stream()
                        .flatMap(chapter -> chapter.getLessons().stream()
                                .filter(Lesson::getStatus))
                        .count();

                Double progressPercentage = (countLessons > 0) ? (countCompletedLessons * 100.0 / countLessons) : 0.0;
                String subjectImage = packageSubject.getSubject().getSubjectImage() != null ? packageSubject.getSubject().getSubjectImage() : "/img/default-subject.jpg";

                Long subjectId = packageSubject.getSubject().getSubjectId();
                LearningProgressDTO existingProgress = progressMap.get(subjectId);

                // Nếu chưa có hoặc tiến độ hiện tại cao hơn, cập nhật
                if (existingProgress == null || progressPercentage > existingProgress.getProgressPercentage()) {
                    progressMap.put(subjectId, LearningProgressDTO.builder()
                            .subjectId(subjectId)
                            .subjectName(packageSubject.getSubject().getSubjectName())
                            .completedLessons(countCompletedLessons)
                            .totalLessons(countLessons)
                            .progressPercentage(progressPercentage)
                            .subjectImage(subjectImage)
                            .packageId(userPackage.getPkg().getPackageId())
                            .build());
                }
            });
        }

        return new ArrayList<>(progressMap.values());
    }
}