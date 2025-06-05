package swp.se1941jv.pls.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.repository.PackageRepository;
import swp.se1941jv.pls.service.specification.PackageSpecification;

@Service
public class PackageService {
    private final PackageRepository packageRepository;

    public PackageService(PackageRepository packageRepository) {
        this.packageRepository = packageRepository;
    }

    public List<Package> getListPackages() {
        return this.packageRepository.findAll();
    }

    public Page<Package> findAllwithPageable(String courseFilter,
            List<String> selectedGrades,
            List<String> selectedSubjects,
            Pageable pageable) {
        return this.packageRepository.findAll(
                PackageSpecification.findPackageWithFilters(courseFilter, selectedGrades, selectedSubjects),
                pageable);
    }
}
