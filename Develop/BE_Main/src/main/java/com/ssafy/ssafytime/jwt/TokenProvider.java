package com.ssafy.ssafytime.jwt;

import com.google.api.gax.rpc.UnauthenticatedException;
import com.ssafy.ssafytime.db.dto.TokenType;
import com.ssafy.ssafytime.db.repository.LogoutTokenRepository;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.stream.Collectors;

/**
 * 빈 생성후 주입 후에 BASE64 디코드를 통해 key변수에 할당
 */
@Component
public class TokenProvider implements InitializingBean {

   private final Logger logger = LoggerFactory.getLogger(TokenProvider.class);
   private static final String AUTHORITIES_KEY = "auth";
   static final String TOKEN_TYPE_KEY = "typ";

   private final String secret;
   private final long tokenValidityInMilliseconds;
   private Key key;
   private final LogoutTokenRepository logoutTokenRepository;

   public TokenProvider(
      @Value("${jwt.secret}") String secret,
      @Value("${jwt.token-validity-in-seconds}") long tokenValidityInSeconds,
      LogoutTokenRepository logoutTokenRepository) {
      this.secret = secret;
      this.tokenValidityInMilliseconds = tokenValidityInSeconds * 1000;
      this.logoutTokenRepository = logoutTokenRepository;
   }

   @Override
   public void afterPropertiesSet() {
      byte[] keyBytes = Decoders.BASE64.decode(secret);
      this.key = Keys.hmacShaKeyFor(keyBytes);
   }

   //Jwt 토큰 생성
   public String createAccessToken(Authentication authentication) {
      String authorities = authentication.getAuthorities().stream()
         .map(GrantedAuthority::getAuthority)
         .collect(Collectors.joining(","));

      final Date now = new Date();

      Date validity = new Date(now.getTime() + this.tokenValidityInMilliseconds);


      return Jwts.builder()
         .setSubject(authentication.getName())
         .claim(TOKEN_TYPE_KEY, TokenType.ACCESS)
         .claim(AUTHORITIES_KEY, authorities)
         .signWith(key, SignatureAlgorithm.HS512)
         .setExpiration(validity)
         .setIssuedAt(now)
         .compact();
   }

   public String createRefreshToken() {
      final Date now = new Date();

      Date validity = new Date(now.getTime() + this.tokenValidityInMilliseconds);
      LocalDateTime localDateTime = new Timestamp(validity.getTime()).toLocalDateTime();

      return Jwts.builder()
              .claim(TOKEN_TYPE_KEY, TokenType.REFRESH)
              .setIssuedAt(now)
              .signWith(key, SignatureAlgorithm.HS512)
              .setExpiration(validity)
              .compact();
   }


   /**
    Token 정보를 받아서 권한 객체반환
    * Token에서 권한객체 추출
    * 권한객체를 이용해 유저 객체 생성 유저 객체, 토큰, 권한정보를 이용해 권한객체 반환
    */
   public Authentication getAuthentication(String token) {

      Claims claims = parseClaims(token);


      Collection<? extends GrantedAuthority> authorities =
         Arrays.stream(claims.get(AUTHORITIES_KEY).toString().split(","))
            .map(SimpleGrantedAuthority::new)
            .collect(Collectors.toList());

      User principal = new User(claims.getSubject(), "", authorities);
      return new UsernamePasswordAuthenticationToken(principal, token, authorities);
   }

   private Claims parseClaims(String token) {
      try {
         return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody();
      } catch (ExpiredJwtException e) {
         return e.getClaims();
      }
   }


   /**
    * 토큰을 파싱해서 검증
    * @param token
    * @return
    */

   public boolean validateAccessToken(final String token){
      return validateToken(token, TokenType.ACCESS);
   }

   public boolean validateRefreshToken(final String token){
      return validateToken(token, TokenType.REFRESH);
   }

   public Date validity(final String token){
      return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody().getExpiration();
   }
   public boolean validateToken(String token, final TokenType tokenType) {
      try {
         final Claims claims = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody();
         final TokenType extractedType = TokenType.valueOf((String)claims.get(TOKEN_TYPE_KEY));
         if(logoutTokenRepository.existsByToken(token)){
            throw new io.jsonwebtoken.security.SecurityException("잘못된 JWT 서명입니다.");
         }

         return !claims.getExpiration().before(new Date()) && extractedType == tokenType;
      } catch (io.jsonwebtoken.security.SecurityException | MalformedJwtException e) {
         logger.info("잘못된 JWT 서명입니다.");
      } catch (ExpiredJwtException e) {
         logger.info("만료된 JWT 토큰입니다.");
      } catch (UnsupportedJwtException e) {
         logger.info("지원되지 않는 JWT 토큰입니다.");
      } catch (IllegalArgumentException e) {
         logger.info("JWT 토큰이 잘못되었습니다.");
      }
      return false;
   }


}
