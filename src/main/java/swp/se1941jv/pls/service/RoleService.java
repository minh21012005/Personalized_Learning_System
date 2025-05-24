package swp.se1941jv.pls.service;

import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Role;
import swp.se1941jv.pls.repository.RoleRepository;

@Service
public class RoleService {
    private final RoleRepository roleRepository;

    public RoleService(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

    public Role getRoleByName(String name) {
        return this.roleRepository.findByRoleName(name);
    }
}
