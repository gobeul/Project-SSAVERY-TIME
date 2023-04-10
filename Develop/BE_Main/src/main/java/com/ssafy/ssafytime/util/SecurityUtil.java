package com.ssafy.ssafytime.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Optional;

public class SecurityUtil {

   private static final Logger logger = LoggerFactory.getLogger(SecurityUtil.class);

   private SecurityUtil() {}

   /*
   Security Context의 Authentication 객체를 통해 username을 리턴해주는 메소드
   이때 authentication 객체는 jwtfilter 의 dofilter 메소드에서 request가 들어올때 securitycontext에 저장됨
    */
   public static Optional<String> getCurrentUsername() {
      final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

      if (authentication == null) {
         logger.debug("Security Context에 인증 정보가 없습니다.");
         return Optional.empty();
      }

      String userName = null;
      if (authentication.getPrincipal() instanceof UserDetails) {
         UserDetails springSecurityUser = (UserDetails) authentication.getPrincipal();
         userName = springSecurityUser.getUsername();
      } else if (authentication.getPrincipal() instanceof String) {
         userName = (String) authentication.getPrincipal();
      }

      return Optional.ofNullable(userName);
   }
}
