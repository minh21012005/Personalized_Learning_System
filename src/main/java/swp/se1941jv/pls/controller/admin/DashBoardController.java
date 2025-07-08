package swp.se1941jv.pls.controller.admin;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Review;
import swp.se1941jv.pls.entity.TransactionStatus;
import swp.se1941jv.pls.service.PackageService;
import swp.se1941jv.pls.service.ReviewService;
import swp.se1941jv.pls.service.TransactionService;
import swp.se1941jv.pls.service.UserService;

@Controller
public class DashBoardController {

        private final UserService userService;
        private final PackageService packageService;
        private final TransactionService transactionService;
        private final ReviewService reviewService;

        public DashBoardController(UserService userService, PackageService packageService,
                        TransactionService transactionService, ReviewService reviewService) {
                this.userService = userService;
                this.packageService = packageService;
                this.transactionService = transactionService;
                this.reviewService = reviewService;
        }

        @GetMapping("/admin")
        public String getDashboard(Model model) {
                int totalActiveUser = this.userService.countActiveUser();
                List<Package> packages = this.packageService.getActivePackages();
                List<Package> top3Packages = packages.stream()
                                .sorted(Comparator.comparingInt((Package pkg) -> (int) pkg.getTransactions().stream()
                                                .filter(t -> t.getStatus().equals(TransactionStatus.APPROVED))
                                                .count()).reversed())
                                .limit(3)
                                .collect(Collectors.toList());

                Map<Package, Integer> packageOrderCounts = new HashMap<>();
                Map<Package, Double> packageAverageRating = new HashMap<>();
                for (Package p : top3Packages) {
                        int orderCount = (int) p.getTransactions().stream()
                                        .filter(t -> t.getStatus().equals(TransactionStatus.APPROVED))
                                        .count();
                        packageOrderCounts.put(p, orderCount);

                        double avgRate = p.getReviews().stream()
                                        .mapToInt(Review::getRating)
                                        .average()
                                        .orElse(0);

                        avgRate = Math.round(avgRate * 10.0) / 10.0;
                        packageAverageRating.put(p, avgRate);
                }

                BigDecimal totalRevenue = this.transactionService.getTotalRevenue();
                int totalActivePackage = packages.size();

                int oneStarRated = this.reviewService.getRate(1);
                int twoStarRated = this.reviewService.getRate(2);
                int threeStarRated = this.reviewService.getRate(3);
                int fourStarRated = this.reviewService.getRate(4);
                int fiveStarRated = this.reviewService.getRate(5);
                int totalReview = oneStarRated + twoStarRated + threeStarRated + fourStarRated + fiveStarRated;

                model.addAttribute("totalActiveUser", totalActiveUser);
                model.addAttribute("top3Packages", top3Packages);
                model.addAttribute("packageOrderCounts", packageOrderCounts);
                model.addAttribute("packageAverageRating", packageAverageRating);
                model.addAttribute("totalRevenue", totalRevenue);
                model.addAttribute("totalActivePackage", totalActivePackage);
                model.addAttribute("oneStarRated", oneStarRated);
                model.addAttribute("twoStarRated", twoStarRated);
                model.addAttribute("threeStarRated", threeStarRated);
                model.addAttribute("fourStarRated", fourStarRated);
                model.addAttribute("fiveStarRated", fiveStarRated);
                model.addAttribute("totalReview", totalReview);
                model.addAttribute("revenueData", transactionService.getMonthlyRevenue());
                return "admin/dashboard/show";
        }
}
