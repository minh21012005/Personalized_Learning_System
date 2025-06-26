package swp.se1941jv.pls.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.PackagePracticeDTO;
import swp.se1941jv.pls.dto.response.PackageSubjectDTO;
import swp.se1941jv.pls.dto.response.SubjectResponseDTO;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.keys.KeyPackageSubject;
import swp.se1941jv.pls.entity.keys.KeyUserPackage;
import swp.se1941jv.pls.repository.PackageRepository;
import swp.se1941jv.pls.repository.PackageSubjectRepository;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.repository.UserPackageRepository;
import swp.se1941jv.pls.service.specification.PackageSpecification;

@Service
public class PackageService {

    private final PackageRepository packageRepository;
    private final PackageSubjectRepository packageSubjectRepository;
    private final SubjectRepository subjectRepository;
    private final UserPackageRepository userPackageRepository;

    public PackageService(PackageRepository packageRepository,
            PackageSubjectRepository packageSubjectRepository,
            SubjectRepository subjectRepository, UserPackageRepository userPackageRepository) {
        this.packageRepository = packageRepository;
        this.packageSubjectRepository = packageSubjectRepository;
        this.subjectRepository = subjectRepository;
        this.userPackageRepository = userPackageRepository;
    }

    public List<Package> getListPackages() {
        return this.packageRepository.findAll();
    }

    public Page<Package> findWithFilterPagination(String courseFilter,
            List<String> selectedGrades,
            List<String> selectedSubjects,
            Pageable pageable) {
        return this.packageRepository.findAll(
                PackageSpecification.findPackageWithFilters(courseFilter, selectedGrades, selectedSubjects),
                pageable);
    }

    public Optional<Package> findById(long id) {
        return this.packageRepository.findById(id);
    }

    public Package savePackage(Package pkg) {
        if (pkg.getStatus() == null) {
            pkg.setStatus(PackageStatus.PENDING);
        }
        return this.packageRepository.save(pkg);
    }

    public boolean existsByName(String name) {
        name = name.trim();
        return this.packageRepository.existsByNameIgnoreCase(name);
    }

    @Transactional
    public Package savePackageWithSubjects(Package newPackage, List<Long> subjectIds) {
        if (newPackage.getStatus() == null) {
            newPackage.setStatus(PackageStatus.PENDING); // Mặc định PENDING
        }
        Package savedPackage = packageRepository.save(newPackage);
        packageSubjectRepository.deleteByPkg_PackageId(savedPackage.getPackageId());
        for (Long subjectId : subjectIds) {
            Subject subject = subjectRepository.findById(subjectId)
                    .orElseThrow(() -> new IllegalArgumentException("Invalid subject ID: " + subjectId));

            // tạo khóa chính tổng hợp
            KeyPackageSubject key = new KeyPackageSubject(savedPackage.getPackageId(), subjectId);

            PackageSubject packageSubject = new PackageSubject(key, savedPackage, subject);

            packageSubjectRepository.save(packageSubject);
        }

        return savedPackage;
    }

    public Page<Package> getFilteredPackage(String keyword, String status, Long gradeId, Pageable pageable) {
        PackageStatus packageStatus = status != null && !status.isEmpty() ? PackageStatus.valueOf(status) : null;
        if (gradeId != null && keyword != null && packageStatus != null) {
            return packageRepository.findByGradeGradeIdAndStatusAndNameContainingIgnoreCase(gradeId,
                    packageStatus, keyword,
                    pageable);
        } else if (gradeId != null && keyword != null) {
            return packageRepository.findByGradeGradeIdAndNameContainingIgnoreCase(gradeId, keyword, pageable);
        } else if (gradeId != null && packageStatus != null) {
            return packageRepository.findByGradeGradeIdAndStatus(gradeId, packageStatus, pageable);
        } else if (gradeId != null) {
            return packageRepository.findByGradeGradeId(gradeId, pageable);
        } else if (keyword != null && packageStatus != null) {
            return packageRepository.findByNameContainingIgnoreCaseAndStatus(keyword, packageStatus,
                    pageable);
        } else if (keyword != null) {
            return packageRepository.findByNameContainingIgnoreCase(keyword, pageable);
        } else if (packageStatus != null) {
            return packageRepository.findByStatus(packageStatus, pageable);
        } else {
            return packageRepository.findAll(pageable);
        }
    }

    public List<Subject> findSubjectsByPackageIdAndKeyword(Long packageId, String keyword) {
        return this.packageSubjectRepository.findSubjectsByPackageIdAndKeyword(packageId, keyword);
    }

    public List<Subject> findSubjectsByPackageId(Long packageId) {
        return this.packageSubjectRepository.findSubjectsByPackageId(packageId);
    }

    public Long getAmountOfUsersRegistor(Long packageId) {
        long count = userPackageRepository.countByPkgPackageId(packageId);
        return count;

    }

    public List<Package> getActivePackages() {
        return this.packageRepository.findAllByIsActiveTrue();
    }

    public List<PackageSubjectDTO> getPackageSubjects() {

        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return new ArrayList<>();
        }


        List<UserPackage> userPackages = userPackageRepository.findByIdUserId(userId);

        if (userPackages.isEmpty()) {
            return new ArrayList<>();
        }

        List<PackageSubjectDTO> packageSubjects = new ArrayList<>();

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        userPackages.stream()
                .filter(userPackage -> {
                    LocalDateTime endDate = userPackage.getEndDate();
                    return endDate == null || !endDate.isBefore(now);
                })
                .forEach(userPackage -> {
                    PackageSubjectDTO packageSubject = PackageSubjectDTO.builder()
                            .packageId(userPackage.getPkg().getPackageId())
                            .name(userPackage.getPkg().getName())
                            .description(userPackage.getPkg().getDescription())
                            .imageUrl(userPackage.getPkg().getImage())
                            .startDate(userPackage.getStartDate() != null ? userPackage.getStartDate().format(formatter) : null)
                            .endDate(userPackage.getEndDate() != null ? userPackage.getEndDate().format(formatter) : null)
                            .build();
                    packageSubjects.add(packageSubject);
                });


        return packageSubjects;
    }

    public PackageSubjectDTO getPackageDetail(Long packageId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return null;
        }
        KeyUserPackage keyUserPackage = KeyUserPackage.builder()
                .userId(userId)
                .packageId(packageId)
                .build();

        UserPackage userPackage = userPackageRepository.findById(keyUserPackage).orElse(null);

        List<SubjectResponseDTO> subjectResponseDTOS = new ArrayList<>();

//        get subjects from userPackage
        if (userPackage != null) {
            userPackage.getPkg().getPackageSubjects().stream().forEach(packageSubject -> {
                SubjectResponseDTO subjectResponseDTO = SubjectResponseDTO.builder()
                        .subjectId(packageSubject.getSubject().getSubjectId())
                        .subjectName(packageSubject.getSubject().getSubjectName())
                        .subjectDescription(packageSubject.getSubject().getSubjectDescription())
                        .subjectImage(packageSubject.getSubject().getSubjectImage())
                        .build();
                subjectResponseDTOS.add(subjectResponseDTO);
            });
        }


        return userPackage != null ? PackageSubjectDTO.builder()
                .packageId(userPackage.getPkg().getPackageId())
                .name(userPackage.getPkg().getName())
                .description(userPackage.getPkg().getDescription())
                .imageUrl(userPackage.getPkg().getImage())
                .startDate(userPackage.getStartDate() != null ? userPackage.getStartDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : null)
                .endDate(userPackage.getEndDate() != null ? userPackage.getEndDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : null)
                .listSubject(subjectResponseDTOS)

                .build() : null;
    }
}
