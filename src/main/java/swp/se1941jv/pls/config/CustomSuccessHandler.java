package swp.se1941jv.pls.config;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.UserService;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

//@Component
public class CustomSuccessHandler implements AuthenticationSuccessHandler {

    @Autowired
    private UserService userService;

    private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

    protected String determineTargetUrl(final Authentication authentication) {
        Map<String, String> roleTargetUrlMap = new HashMap<>();
        roleTargetUrlMap.put("ROLE_STUDENT", "/");
        roleTargetUrlMap.put("ROLE_PARENT", "/");
        roleTargetUrlMap.put("ROLE_CONTENT_MANAGER", "/admin");
        roleTargetUrlMap.put("ROLE_ADMIN", "/admin");
        roleTargetUrlMap.put("ROLE_STAFF", "/staff");

        final Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        for (final GrantedAuthority grantedAuthority : authorities) {
            String authorityName = grantedAuthority.getAuthority();
            if (roleTargetUrlMap.containsKey(authorityName)) {
                return roleTargetUrlMap.get(authorityName);
            }
        }

        throw new IllegalStateException("Không tìm thấy vai trò phù hợp để điều hướng!");
    }

    protected void clearAuthenticationAttributes(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        String targetUrl = determineTargetUrl(authentication);

        HttpSession session = request.getSession(false);
        if (session != null) {
            String email = authentication.getName();
            User user = this.userService.getUserByEmail(email);
            if (user != null) {
                session.setAttribute("fullName", user.getFullName());
                session.setAttribute("avatar", user.getAvatar());
                session.setAttribute("id", user.getUserId());
                session.setAttribute("email", email);
                session.setAttribute("dob", user.getDob());
                session.setAttribute("role", user.getRole().getRoleName());
                // Có thể thêm thông tin khác nếu cần, ví dụ: cấp lớp của học sinh
                // session.setAttribute("grade", user.getGrades() != null ?
                // user.getGrades().get(0).getGradeName() : null);
            }
        }

        if (response.isCommitted()) {
            return;
        }

        redirectStrategy.sendRedirect(request, response, targetUrl);
        clearAuthenticationAttributes(request);
    }
}