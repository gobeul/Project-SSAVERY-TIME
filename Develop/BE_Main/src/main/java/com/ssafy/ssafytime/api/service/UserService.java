package com.ssafy.ssafytime.api.service;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import com.ssafy.ssafytime.db.dto.*;
import com.ssafy.ssafytime.api.dto.AttendanceDto;
import com.ssafy.ssafytime.db.dto.UserDto;
import com.ssafy.ssafytime.db.entity.Attendance;
import com.ssafy.ssafytime.db.entity.AttendanceId;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import com.ssafy.ssafytime.db.entity.Authority;
import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.AttendanceRepository;
import com.ssafy.ssafytime.db.repository.LogoutTokenRepository;
import com.ssafy.ssafytime.db.repository.RefreshTokenRepository;
import com.ssafy.ssafytime.db.repository.UserRepository;
import com.ssafy.ssafytime.exception.DuplicateUserException;
import com.ssafy.ssafytime.exception.NotFoundUserException;
import com.ssafy.ssafytime.jwt.TokenProvider;
import com.ssafy.ssafytime.util.SecurityUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    @Autowired
    private JavaMailSender mailSender;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenProvider tokenProvider;
    private final AttendanceRepository attendanceRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final LogoutTokenRepository logoutTokenRepository;



    /**
     * UserEmail로 중복확인후 Authority와 User정보를 생성해 DB에 저장
     * @param userDto
     * @return
     */
    @Transactional
    public UserDto signup(UserDto userDto) {
        if (userRepository.findOneWithAuthoritiesByUserEmail(userDto.getUserEmail()).orElse(null) != null) {
            throw new DuplicateUserException("이미 가입되어 있는 유저입니다.");
        }

        Authority authority = Authority.builder()
                .authorityName("ROLE_USER")
                .build();

        User user = User.builder()
                .userIdx(userDto.getId())
                .userName(userDto.getUserName())
                .password(passwordEncoder.encode(userDto.getPassword()))
                .userEmail(userDto.getUserEmail())
                .trackCode(userDto.getTrackCode())
                .regionCode(userDto.getRegionCode())
                .authorities(Collections.singleton(authority))
                .build();

        return UserDto.from(userRepository.save(user));
    }

    @Transactional(readOnly = true)
    public UserDto getUserWithAuthorities(String userEmail) {

        return UserDto.from(userRepository.findOneWithAuthoritiesByUserEmail(userEmail).orElse(null));
    }

    @Transactional(readOnly = true)
    public UserDto getMyUserWithAuthorities() {
        return UserDto.from(
                SecurityUtil.getCurrentUsername()
                        .flatMap(userRepository::findOneWithAuthoritiesByUserEmail)
                        .orElseThrow(() -> new NotFoundUserException("User not found"))
        );
    }




    public Optional<User> findById(Long Id) {
        return userRepository.findById(Id);
    }

    public Long count() {
        return userRepository.count();
    }

//    public List<User> findByIsAdminAndAlarm(int isAdmin, int alarm) {
//        return userRepository.findByIsAdminAndAlarm(isAdmin, alarm);
//    }

    public void save(Optional<User> user) {
        userRepository.save(user.get());
    }


    public void temporaryPassword(TemporaryDto temporaryDto){
        System.out.println("=-=-=--==--=-=");
        String userEmail = temporaryDto.getUserEmail();
        String userName = temporaryDto.getUserName();
        String password = getTemporaryPassword();
        String encodePassword = passwordEncoder.encode(password);
        User user = userRepository.findByUserEmailAndUserName(userEmail, userName).orElse(null);
        user.setPassword(encodePassword);
        System.out.println("-==--=-==--=-=-==-=-");
        System.out.println(password);
        System.out.println(encodePassword);
        System.out.println("-==--=-==--=-=-==-=-");


        MailDto dto = new MailDto();
        dto.setAddress(userEmail);
        dto.setTitle("임시비밀번호 메일입니다.");
        dto.setMsg("SSAFY 임시비밀번호는" + password +"입니다.");

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(dto.getAddress());
        message.setSubject(dto.getTitle());
        message.setText(dto.getMsg());
        message.setFrom("ssafy@ssafy.com");
        System.out.println("message"+message);
        mailSender.send(message);
        userRepository.save(user);


    }

    public String getTemporaryPassword(){
        char[] charSet = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
                'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

        String str = "";

        // 문자 배열 길이의 값을 랜덤으로 10개를 뽑아 구문을 작성함
        int idx = 0;
        for (int i = 0; i < 10; i++) {
            idx = (int) (charSet.length * Math.random());
            str += charSet[idx];
        }
        return str;
    }

}
