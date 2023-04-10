package com.ssafy.ssafytime.api.service;

import com.ssafy.ssafytime.db.dto.TokenDto;
import com.ssafy.ssafytime.db.dto.TokenResponse;
import com.ssafy.ssafytime.db.entity.RefreshToken;
import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.RefreshTokenRepository;
import com.ssafy.ssafytime.db.repository.UserRepository;
import com.ssafy.ssafytime.jwt.TokenProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.Optional;

@Service
public class TokenService {
    private final TokenProvider tokenProvider;
    private final long refreshTokenValidityInMilliseconds;
    private final RefreshTokenRepository refreshTokenRepository;

    public TokenService(
            final TokenProvider tokenProvider,
            @Value("${jwt.token-validity-in-seconds}") final long refreshTokenValidityInMilliseconds,
            RefreshTokenRepository refreshTokenRepository){
        this.tokenProvider = tokenProvider;
        this.refreshTokenValidityInMilliseconds = refreshTokenValidityInMilliseconds;
        this.refreshTokenRepository = refreshTokenRepository;
    }

    public TokenResponse createTokenResponse(final Authentication authentication){
        final String accessToken = tokenProvider.createAccessToken(authentication);
        final String refreshToken = tokenProvider.createRefreshToken();

        return new TokenResponse(accessToken, refreshToken);
    }

    public void saveRefreshToken(final String userIdx, String refreshToken){

        long now = (new Date()).getTime();
        Date validity = new Date(now + this.refreshTokenValidityInMilliseconds*10000);
        LocalDateTime localDateTime = new Timestamp(validity.getTime()).toLocalDateTime();

        refreshTokenRepository.save(new RefreshToken(userIdx, refreshToken, localDateTime));
    }

    public void invalidateRefreshToken(final Long userIdx){
        invalidateRefreshToken(userIdx.toString());
    }

    public void invalidateRefreshToken(final String userIdx){
        refreshTokenRepository.deleteById(Long.valueOf(userIdx));

    }

}
