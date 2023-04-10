package com.ssafy.ssafytime.db.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ssafy.ssafytime.db.dto.AuthorityDto;
import com.ssafy.ssafytime.db.entity.User;
import lombok.*;
import org.springframework.security.crypto.password.PasswordEncoder;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.Set;
import java.util.stream.Collectors;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {

   private Long Id;
   @NotNull
   @Size(min = 3, max = 50)
   private String userName;

   @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
   @NotNull
   @Size(min = 3, max = 100)
   private String password;


   @NotNull
   private String userEmail;


   @NotNull
   private Integer trackCode;

   private String userImg;

   @NotNull
   private Integer regionCode;

   private Integer exp;

   private Integer mileage;


   @NotNull
   private Integer class_num;


   private Integer isAdmin;

   private String token;  // FCM 토큰



   private Set<AuthorityDto> authorityDtoSet;

   public static UserDto from(User user) {
      if(user == null) return null;

      return UserDto.builder()
              .Id(user.getUserIdx())
              .userName(user.getUserName())
              .userEmail(user.getUserEmail())
              .trackCode(user.getTrackCode())
              .userImg(user.getUserImg())
              .isAdmin(user.getIsAdmin())
              .regionCode(user.getRegionCode())
              .class_num(user.getClassNum())
              .exp(user.getExp())
              .mileage(user.getMileage())
              .authorityDtoSet(user.getAuthorities().stream()
                      .map(authority -> AuthorityDto.builder().authorityName(authority.getAuthorityName()).build())
                      .collect(Collectors.toSet()))
              .build();
   }


   public void updatePassWord(PasswordEncoder passwordEncoder, String password){
      this.password =  passwordEncoder.encode(password);
   }




}