package com.ssafy.ssafytime.api.service;

import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.UserRepository;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Component("userDetailsService")
public class CustomUserDetailsService implements UserDetailsService {
   private final UserRepository userRepository;



   public CustomUserDetailsService(UserRepository userRepository) {
      this.userRepository = userRepository;
   }


   /*
   DB에서 유저정보와 권한정보를 가져와 해당정보를 기반으로 userDetails.user객체를 생성
    */
   @Override
   @Transactional
   public UserDetails loadUserByUsername(final String userEmail) {
      return userRepository.findOneWithAuthoritiesByUserEmail(userEmail)
         .map(user -> createUser(userEmail, user))
         .orElseThrow(() -> new UsernameNotFoundException(userEmail + " -> 데이터베이스에서 찾을 수 없습니다."));
   }





   private org.springframework.security.core.userdetails.User createUser(String userName, User user) {
      List<GrantedAuthority> grantedAuthorities = user.getAuthorities().stream()
              .map(authority -> new SimpleGrantedAuthority(authority.getAuthorityName()))
              .collect(Collectors.toList());

      return new org.springframework.security.core.userdetails.User(user.getUserEmail(),
              user.getPassword(),
              grantedAuthorities);
   }
}
