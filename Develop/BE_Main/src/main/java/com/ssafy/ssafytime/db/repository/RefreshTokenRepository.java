package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.dto.AttendanceInterface;
import com.ssafy.ssafytime.db.entity.RefreshToken;
import com.ssafy.ssafytime.db.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {
    Optional<RefreshToken> findRefreshTokenByUserEmail(String refreshToken);



    @Transactional
    @Modifying
    @Query(value = "delete " +
            "from refresh_token r " +
            "where r.expired_at < :expiredAt", nativeQuery = true)
    void deleteByExpiredAt(@Param("expiredAt") LocalDateTime now);
}
