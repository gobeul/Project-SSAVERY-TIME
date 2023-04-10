package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.entity.LogoutToken;
import com.ssafy.ssafytime.db.entity.RefreshToken;
import com.ssafy.ssafytime.db.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface LogoutTokenRepository extends JpaRepository <LogoutToken, String> {

    @Transactional
    @Modifying
    @Query(value = "delete " +
            "from logout_token r " +
            "where r.expired_at < :expiredAt", nativeQuery = true)
    void deleteByExpiredAt(@Param("expiredAt") LocalDateTime now);

    boolean existsByToken(String token);

}
