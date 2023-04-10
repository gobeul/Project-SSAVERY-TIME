package com.ssafy.ssafytime.jwt;

import com.ssafy.ssafytime.db.entity.RefreshToken;
import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.RefreshTokenRepository;
import com.ssafy.ssafytime.db.repository.UserRepository;
import org.springframework.stereotype.Component;
import org.webjars.NotFoundException;


@Component
public class RefreshTokenValidator {
    private final TokenProvider tokenProvider;
    private final RefreshTokenRepository refreshTokenRepository;

    public RefreshTokenValidator(
            final TokenProvider tokenProvider,
            final RefreshTokenRepository refreshTokenRepository
    ){
        this.tokenProvider = tokenProvider;
        this.refreshTokenRepository = refreshTokenRepository;
    }


    public boolean validate(final String userIdx, String refreshToken){
        final RefreshToken refreshToken1 = getSavedRefreshToken(userIdx);
        return tokenProvider.validateRefreshToken(refreshToken)&& refreshToken1.hasSameValue(refreshToken);
    }

    private RefreshToken getSavedRefreshToken(final String userIdx){
        return refreshTokenRepository.findRefreshTokenByUserEmail(userIdx)
                .orElseThrow(() -> new NotFoundException("리프레수 토큰을 찾을 수 없습니다."));
    }

}
