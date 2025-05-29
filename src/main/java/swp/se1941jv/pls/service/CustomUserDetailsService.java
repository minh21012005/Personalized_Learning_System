package swp.se1941jv.pls.service;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(username);
        if (user == null) {
            throw new UsernameNotFoundException("Không tìm thấy người dùng với email: " + username);
        }

        List<GrantedAuthority> authorities = new ArrayList<>();

        // Thêm vai trò vào authorities
        if (user.getRole() != null) {
            authorities.add(new SimpleGrantedAuthority("ROLE_" + user.getRole().getRoleName()));
        } else {
            throw new UsernameNotFoundException("Người dùng không có vai trò: " + username);
        }

        return new CustomUserDetails(
                user.getEmail(),
                user.getPassword(),
                user.getEmailVerify(), // enabled
                true, // accountNonExpired
                true, // credentialsNonExpired
                user.getIsActive(), // accountNonLocked
                authorities,
                user.getUserId() // userId
        );
    }
}