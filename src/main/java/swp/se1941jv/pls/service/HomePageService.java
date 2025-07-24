package swp.se1941jv.pls.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.dto.response.homepage.PackageHomeDTO;
import swp.se1941jv.pls.repository.PackageRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HomePageService {

    private final PackageRepository packageRepository;

    public List<PackageHomeDTO> getPackageHomeDTOs() {
        return packageRepository.findAllByIsActiveTrue().stream().map(pkg -> PackageHomeDTO.builder()
                .imageUrl(pkg.getImage())
                .name(pkg.getName())
                .description(pkg.getDescription())
                .build()).toList();
    }

}
