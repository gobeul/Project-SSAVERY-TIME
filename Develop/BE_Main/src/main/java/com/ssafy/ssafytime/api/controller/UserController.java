package com.ssafy.ssafytime.api.controller;

import com.ssafy.ssafytime.db.dto.*;
import com.ssafy.ssafytime.api.service.AlarmDefaultServiceImpl;
import com.ssafy.ssafytime.api.request.SurveyRegisterPostReq;
import com.ssafy.ssafytime.api.service.UserService;
import com.ssafy.ssafytime.common.model.response.BaseResponseBody;
import com.ssafy.ssafytime.db.dto.UserDto;
import com.ssafy.ssafytime.db.entity.AlarmDefault;
import com.ssafy.ssafytime.db.entity.User;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiParam;
import lombok.RequiredArgsConstructor;
import com.ssafy.ssafytime.exception.ResponseHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import com.ssafy.ssafytime.db.repository.AttendanceRepository;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.*;
import java.net.URL;
import java.util.*;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final AlarmDefaultServiceImpl alarmService;
    private final AttendanceRepository attendanceRepository;


    @PostMapping("/signup")
    public ResponseEntity<Object> signup(
            @Valid @RequestBody UserDto userDto
    ) {
        UserDto user = userService.signup(userDto);
        alarmService.save(user.getId());
        return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, null);
    }

    @GetMapping("/my-page")
    @PreAuthorize("hasAnyRole('USER','ADMIN')")
    public ResponseEntity<UserDto> getMyUserInfo(HttpServletRequest request) {
        return ResponseEntity.ok(userService.getMyUserWithAuthorities());
    }

    @GetMapping("/{username}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public ResponseEntity<UserDto> getUserInfo(@PathVariable String username) {
        return ResponseEntity.ok(userService.getUserWithAuthorities(username));
    }

    @GetMapping("/attendance")
    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public ResponseEntity<Map<String, Object>> getAttendance(HttpServletRequest request, @AuthenticationPrincipal User user) {

        Long userIdx = userService.getMyUserWithAuthorities().getId();

        List<AttendanceInterface> list = attendanceRepository.findAbsent(userIdx);
        List<AttendanceInterface> list2 = attendanceRepository.findMonthAttendance(userIdx);
        List<AttendanceInterface> list3 = attendanceRepository.findAllAttendance(userIdx);

        list.addAll(list2);
        list.addAll(list3);

        Map<String, Object> result = new HashMap<>();
        result.put("attendance", list);

        return  ResponseEntity.ok().body(result);
    }


    @PostMapping("/alarm")  // FCM 토큰 저장 및 갱신
    public ResponseEntity<? extends BaseResponseBody> saveFCMToken(@RequestBody @ApiParam(value="FCM 토큰", required = true) FCMTokenDTO fcmTokenDTO, @ApiIgnore Authentication authentication) {
        UserDto userDto = userService.getMyUserWithAuthorities();  // jwt 토큰을 통해 DTO불러옴
        Optional<User> user = userService.findById(userDto.getId());  // DTO 통해 User 엔티티 불러옴
        if (user.isPresent()) {  // 유저가 존재한다면
            if (userDto.getToken() == null || userDto.getToken() != fcmTokenDTO.getFCMToken()) {  // 해당 사용자가 FCM 토큰이 없다면
                user.get().setToken(fcmTokenDTO.getFCMToken());  // 토큰 설정해서
                userService.save(user);  // 저장
            }
            return ResponseEntity.ok().body(BaseResponseBody.of(200, "Success"));
        } else {
            return ResponseEntity.ok().body(BaseResponseBody.of(401, "no user"));
        }
    }

    /* 유저 기본 알람 on/off 상태 조회
    ================================================|| parameter ||=========================================================
    userId : 사용자 학번(user_idx)
    ========================================================================================================================
     */
    @GetMapping("alarm/{userId}")
//    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public ResponseEntity<Object> getAlarm(@PathVariable Long userId) {
        AlarmDefaultResponseDto alarm = alarmService.getDefaultAlarmSetting(userId);
        HashMap<String, Boolean> result = new HashMap<>();
        result.put("noticeAlarm", alarm.getNoticeAlarm());
        result.put("surveyAlarm", alarm.getSurveyAlarm());
        result.put("consultingAlarm", alarm.getConsultingAlarm());
        return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, result);
    }

    /* 유저 공지사항 알림 on/off 변경
    ================================================|| parameter ||=========================================================
    userId : 사용자 학번(user_idx)
    ========================================================================================================================
     */
    @PatchMapping("alarm/notice/{userId}")
//    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public ResponseEntity<Object> updateNotice(@PathVariable Long userId) {
        alarmService.noticeChange(userId);
        return ResponseHandler.generateResponse(true, "UPDATE", HttpStatus.OK, null);
    }

    /* 유저 설문조사 알림 on/off 변경
    ================================================|| parameter ||=========================================================
    userId : 사용자 학번(user_idx)
    ========================================================================================================================
     */
    @PatchMapping("alarm/survey/{userId}")
//    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public ResponseEntity<Object> updateSurvey(@PathVariable Long userId) {
        alarmService.surveyChange(userId);
        return ResponseHandler.generateResponse(true, "UPDATE", HttpStatus.OK, null);
    }

    /* 유저 상담 알림 on/off 변경
    ================================================|| parameter ||=========================================================
    userId : 사용자 학번(user_idx)
    ========================================================================================================================
     */
    @PatchMapping("alarm/consulting/{userId}")
//    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public ResponseEntity<Object> updateConsulting(@PathVariable Long userId) {
        alarmService.consultingChange(userId);
        return ResponseHandler.generateResponse(true, "UPDATE", HttpStatus.OK, null);
    }

    @GetMapping("images")  // 프로필 이미지를 C://image 폴더에 학번이름으로 저장하기
    public ResponseEntity<?> downloadImage(@ApiIgnore Authentication authentication) throws IOException, NullPointerException{
        UserDto userdto = userService.getMyUserWithAuthorities();
        String img = userdto.getUserImg();  // 이미지 url 받아옴
        Long id = userdto.getId();  // 현재 로그인된 사용자의 학번 받아와서 이미지이름으로 사용하도록
        URL url = new URL(img);
        InputStream in = new BufferedInputStream(url.openStream());
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        byte[] buf = new byte[1024];
        int n = 0;
        while(-1!=(n=in.read(buf))){
            out.write(buf,0,n);
        }
        out.close();
        in.close();
        byte[] response = out.toByteArray();

        File fileDir = new File("C:\\image");  // 폴더 만듬
        if(!fileDir.isDirectory()){
            fileDir.mkdirs();
        }
        File fileData = new File("C:\\image\\"+id+".png");  // 파일 생성
        if(!fileData.exists()) {  // 해당 경로의 파일이 존재하지 않으면!!
            FileOutputStream fos = new FileOutputStream("C:\\image\\"+id+".png");  // 만들고
            fos.write(response);  // 해당 url 이미지 넣음
            fos.close();

            return ResponseHandler.generateResponse(true, "success", HttpStatus.OK, null);
        } else {
            return ResponseHandler.generateResponse(false, "Already exist", HttpStatus.NOT_FOUND, null);
        }


    }

    @GetMapping(value="/images/view", produces= MediaType.IMAGE_PNG_VALUE)  // 저장된 이미지 파일 가져오기
    public ResponseEntity<?> getImage(@ApiIgnore Authentication authentication) throws IOException{
        FileInputStream fis = null;
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        UserDto userDto = userService.getMyUserWithAuthorities(); // 현재 유저 DTO 가져오기
        Long id = userDto.getId();  // 학번 가져오기

        String fileDir = "C:\\image\\" + id + ".png"; // 파일경로

        try{
            fis = new FileInputStream(fileDir);
        } catch(FileNotFoundException e){
            e.printStackTrace();
        }

        int readCount = 0;
        byte[] buffer = new byte[1024];
        byte[] fileArray = null;

        try{
            while((readCount = fis.read(buffer)) != -1){
                baos.write(buffer, 0, readCount);
            }
            fileArray = baos.toByteArray();
            fis.close();
            baos.close();
        } catch(IOException e){
            throw new RuntimeException("File Error");
        }
        return ResponseEntity.status(200).body(fileArray);
    }


    @PostMapping("/password")
    public ResponseEntity<?> temporaryPassword(@Valid @RequestBody TemporaryDto temporaryDto){

        userService.temporaryPassword(temporaryDto);
        return ResponseEntity.status(200).body("Success");
    }

}


