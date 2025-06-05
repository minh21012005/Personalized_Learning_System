package swp.se1941jv.pls.service;

import java.util.List;

import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.PackageSubject;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.keys.KeyPackageSubject;
import swp.se1941jv.pls.repository.PackageRepository;
import swp.se1941jv.pls.repository.PackageSubjectRepository;
import swp.se1941jv.pls.repository.SubjectRepository;

@Service
public class PackageService {
    private final PackageRepository packageRepository;
    private final PackageSubjectRepository packageSubjectRepository;
    private final SubjectRepository subjectRepository;

    public PackageService(PackageRepository packageRepository, PackageSubjectRepository packageSubjectRepository,
            SubjectRepository subjectRepository) {
        this.packageRepository = packageRepository;
        this.subjectRepository = subjectRepository;
        this.packageSubjectRepository = packageSubjectRepository;
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

}
