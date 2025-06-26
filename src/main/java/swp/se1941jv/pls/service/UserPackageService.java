package swp.se1941jv.pls.service;

import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.UserPackage;
import swp.se1941jv.pls.repository.UserPackageRepository;

@Service
public class UserPackageService {
    private final UserPackageRepository userPackageRepository;

    public UserPackageService(UserPackageRepository userPackageRepository) {
        this.userPackageRepository = userPackageRepository;
    }

    public void save(UserPackage userPackage) {
        this.userPackageRepository.save(userPackage);
    }
}
