package com.ssafy.ssafytime.api.controller;


import com.ssafy.ssafytime.api.service.AuthService;
import com.ssafy.ssafytime.api.service.TokenService;
import com.ssafy.ssafytime.db.dto.LoginDto;
import com.ssafy.ssafytime.db.dto.TokenRequest;
import com.ssafy.ssafytime.db.dto.TokenResponse;
import com.ssafy.ssafytime.jwt.JwtFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

@RestController
@RequestMapping("/")
@RequiredArgsConstructor
public class AuthController {
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final TokenService tokenService;
    private final AuthService authService;
    public static final String AUTHORIZATION_HEADER = "Authorization";

    /**
     * 이메일, 비밀번호 입력으로 authenticationToken객체를 생성하고 authenticate메소드가 실행될때
     *  customuserdetailservice의 loadbyusername메소드가 실행
     *  그결과 값으로 authentication 객체를 생성후 SecurityContext에 저장하고
     *  createtoken메소드를 통해 JWT 토큰 생성
     *  토큰을 Response header에도 넣어주고 response body에도 넣어서 반환
     * @param loginDto(userEmail) 유저 이메일
     * @param loginDto(password) 유저 패스워드
     * @return (액세스,리프레시토큰) 헤더, 상태코드
     */
    @PostMapping("/login")
    public ResponseEntity<TokenResponse> authorize(@Valid @RequestBody LoginDto loginDto) {

        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(loginDto.getUserEmail(), loginDto.getPassword());


        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
        TokenResponse tokenResponse = tokenService.createTokenResponse(authentication);

        tokenService.saveRefreshToken(authentication.getName(), tokenResponse.getRefreshToken());

        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add(JwtFilter.AUTHORIZATION_HEADER, "Bearer " + tokenResponse.getAccessToken());
        return new ResponseEntity<>(tokenResponse, httpHeaders, HttpStatus.OK);
    }

    /**
     *  액세스 토큰과 리프레시토큰을 인자로 받아 액세스 토큰과 리프레시 토큰을 새로 발급받는다.
     * @param tokenRequest(accessToken, refreshToken)
     * @return (액세스,리프레시토큰) 헤더, 상태코드
     */
    @PostMapping("/refresh-token")
    public ResponseEntity<TokenResponse> refreshToken(@Valid @RequestBody final TokenRequest tokenRequest){
        final TokenResponse tokenResponse = authService.refreshToken(tokenRequest);

        final HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setBearerAuth(tokenResponse.getAccessToken());

        return new ResponseEntity<>(tokenResponse, httpHeaders, HttpStatus.OK);
    }


    /*
        logout 함수
        - request 헤더에서 토큰정보를 빼서 authService의 로그아웃 실행
     */
    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest request){
        String bearerToken = request.getHeader(AUTHORIZATION_HEADER);
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) {
            bearerToken =  bearerToken.substring(7);
        }
        authService.logout(bearerToken);
        return ResponseEntity.status(200).body("Success");
    }



















}
