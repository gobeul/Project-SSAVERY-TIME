package com.ssafy.ssafytime.api.service;

import com.ssafy.ssafytime.db.dto.TokenDto;
import com.ssafy.ssafytime.db.dto.TokenRequest;
import com.ssafy.ssafytime.db.dto.TokenResponse;
import com.ssafy.ssafytime.db.entity.LogoutToken;
import com.ssafy.ssafytime.db.entity.RefreshToken;
import com.ssafy.ssafytime.db.repository.LogoutTokenRepository;
import com.ssafy.ssafytime.db.repository.RefreshTokenRepository;
import com.ssafy.ssafytime.db.repository.UserRepository;
import com.ssafy.ssafytime.exception.NotFoundUserException;
import com.ssafy.ssafytime.jwt.RefreshTokenValidator;
import com.ssafy.ssafytime.jwt.TokenProvider;
import com.ssafy.ssafytime.util.SecurityUtil;
import io.jsonwebtoken.Jwts;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final RefreshTokenValidator refreshTokenValidator;
    private final TokenProvider tokenProvider;
    private final TokenService tokenService;

    private final UserRepository userRepository;
    private final LogoutTokenRepository logoutTokenRepository;

    /*
        - refreshToken
        accessToken 과 refreshToken을 인자로 받아 권한객체를 얻어온다.
        권한객체 뽑은 name을 통해 refreshToken을 검증하고 accessToken과 refreshToken 새로 생성하여 저장한다.
        그 후 두 token을 반환한다.
     */
    @Transactional
    public TokenResponse refreshToken(final TokenRequest tokenRequest){
        final String accessToken = tokenRequest.getAccessToken();
        final String refreshToken = tokenRequest.getRefreshToken();

        final Authentication authentication = tokenProvider.getAuthentication(accessToken);

        validateRefreshToken(authentication.getName(), refreshToken);


        final TokenResponse tokenResponse = tokenService.createTokenResponse(authentication);

        tokenService.saveRefreshToken(authentication.getName(), tokenResponse.getRefreshToken());

        return tokenResponse;

    }

    /*
        refreshToken 검증. 실패시 tok
     */
    private void validateRefreshToken(final String userIdx, String refreshToken){
        if(!refreshTokenValidator.validate(userIdx,refreshToken)){
            tokenService.invalidateRefreshToken(userIdx);
            throw new BadCredentialsException("리프레쉬 토큰이 유효하지 않습니다.");
        }
    }


    public void logout(String accessToken) {
        SecurityUtil.getCurrentUsername()
                .flatMap(userRepository::findOneWithAuthoritiesByUserEmail)
                .orElseThrow(() -> new NotFoundUserException("User not found"));
        Date date = tokenProvider.validity(accessToken);
        System.out.println(date);
        LocalDateTime localDateTime = new Timestamp(date.getTime()).toLocalDateTime();

        logoutTokenRepository.save(new LogoutToken(accessToken, localDateTime));

    }
}

