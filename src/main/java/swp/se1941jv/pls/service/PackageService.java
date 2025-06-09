package swp.se1941jv.pls.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.PackageSubject;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.keys.KeyPackageSubject;
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
        return this.packageRepository.save(pkg);
    }

    public boolean existsByName(String name) {
        return this.packageRepository.existsByName(name);
    }

    public Package savePackageWithSubjects(Package newPackage, List<Long> subjectIds) {
        // Lưu Package trước để có packageId
        Package savedPackage = packageRepository.save(newPackage);

        for (Long subjectId : subjectIds) {
            Subject subject = subjectRepository.findById(subjectId).orElseThrow();

            // Tạo khóa chính tổng hợp
            KeyPackageSubject key = new KeyPackageSubject(savedPackage.getPackageId(), subjectId);

            // Tạo PackageSubject
            PackageSubject packageSubject = new PackageSubject();
            packageSubject.setId(key); // Gán khóa tổng hợp
            packageSubject.setPkg(savedPackage); // Gán package
            packageSubject.setSubject(subject); // Gán subject

            packageSubjectRepository.save(packageSubject);
        }

        return savedPackage;
    }

    public Page<Package> getFilteredPackage(String keyword, String isActive, Long gradeId, Pageable pageable) {
        if (gradeId != null && keyword != null && isActive != null && !isActive.isEmpty()) {
            return packageRepository.findByGradeGradeIdAndIsActiveAndNameContainingIgnoreCase(gradeId,
                    Boolean.parseBoolean(isActive), keyword,
                    pageable);
        } else if (gradeId != null && keyword != null) {
            return packageRepository.findByGradeGradeIdAndNameContainingIgnoreCase(gradeId, keyword, pageable);
        } else if (gradeId != null && isActive != null && !isActive.isEmpty()) {
            return packageRepository.findByGradeGradeIdAndIsActive(gradeId, Boolean.parseBoolean(isActive), pageable);
        } else if (gradeId != null) {
            return packageRepository.findByGradeGradeId(gradeId, pageable);
        } else if (keyword != null && isActive != null && !isActive.isEmpty()) {
            return packageRepository.findByNameContainingIgnoreCaseAndIsActive(keyword, Boolean.parseBoolean(isActive),
                    pageable);
        } else if (keyword != null) {
            return packageRepository.findByNameContainingIgnoreCase(keyword, pageable);
        } else if (isActive != null && !isActive.isEmpty()) {
            return packageRepository.findByIsActive(Boolean.parseBoolean(isActive), pageable);
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
}
