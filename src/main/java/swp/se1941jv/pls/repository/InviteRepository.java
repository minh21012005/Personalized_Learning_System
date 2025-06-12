package swp.se1941jv.pls.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import swp.se1941jv.pls.entity.Invite;

public interface InviteRepository extends JpaRepository<Invite, Long> {
    Optional<Invite> findByInviteCode(String inviteCode);
}