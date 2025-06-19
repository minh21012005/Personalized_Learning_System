package swp.se1941jv.pls.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.PackagePracticeDTO;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.UserPackage;
import swp.se1941jv.pls.repository.PackageRepository;
import swp.se1941jv.pls.repository.QuestionBankRepository;
import swp.se1941jv.pls.repository.UserPackageRepository;
import swp.se1941jv.pls.repository.UserRepository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class PracticesService {

    QuestionBankRepository questionBankRepository;
    PackageRepository packageRepository;
    UserPackageRepository userPackageRepository;
    UserRepository userRepository;

    @PreAuthorize("hasAnyRole('STUDENT')")
    public List<PackagePracticeDTO> getPackagePractices() {

        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return new ArrayList<>();
        }


        List<UserPackage> userPackages = userPackageRepository.findByIdUserId(userId);

        if (userPackages.isEmpty()) {
            return new ArrayList<>();
        }

        List<PackagePracticeDTO> packagePractices = new ArrayList<>();

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        userPackages.stream()
            .filter(userPackage ->{
                LocalDateTime endDate = userPackage.getEndDate();
                return endDate == null || !endDate.isBefore(now);
            })
            .forEach(userPackage -> {
                PackagePracticeDTO packagePractice = PackagePracticeDTO.builder()
                        .packageId(userPackage.getPkg().getPackageId())
                        .name(userPackage.getPkg().getName())
                        .description(userPackage.getPkg().getDescription())
                        .imageUrl(userPackage.getPkg().getImage())
                       .startDate(userPackage.getStartDate() != null ? userPackage.getStartDate().format(formatter) : null)
                        .endDate(userPackage.getEndDate() != null ? userPackage.getEndDate().format(formatter) : null)
                        .build();
                packagePractices.add(packagePractice);
            });


        return packagePractices;
    }

}
