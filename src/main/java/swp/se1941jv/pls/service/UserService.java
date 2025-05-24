package swp.se1941jv.pls.service;


import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Role;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.RoleRepository;
import swp.se1941jv.pls.repository.UserRepository;

import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public UserService(UserRepository userRepository, RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    public UserRepository getUserRepository() {
        return userRepository;
    }

    public List<User> getAllUsers() {
        return this.userRepository.findAll();
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }
//
//    public List<User> getAllUsersByEmail(String email) {
//        return this.userRepository.findAllByEmail(email);
//    }

    public User saveUser(User user) {
        return this.userRepository.save(user);
    }

    public User getUserById(Long id) {
        return this.userRepository.findById(id).orElse(null);
    }

    public void deleteUserById(Long id) {
        this.userRepository.deleteById(id);
    }
//
//    public Role getRoleByName(String name) {
//        return this.roleRepository.findByRoleName(name);
//    }
//
//    public boolean checkEmailExist(String email) {
//        return this.userRepository.existsByEmail(email);
//    }

    public long countUsers() {
        return this.userRepository.count();
    }
}