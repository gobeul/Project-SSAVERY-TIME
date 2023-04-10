package com.ssafy.ssafytime.api.controller;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Notification;
import com.ssafy.ssafytime.api.firebase.MessageDTO;
import com.ssafy.ssafytime.api.service.AlarmDefaultService;
import com.ssafy.ssafytime.api.service.MeetService;
import com.ssafy.ssafytime.api.service.UserService;
import com.ssafy.ssafytime.db.dto.ReserveDto;
import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.AlarmDefaultRepository;
import com.ssafy.ssafytime.db.repository.UserRepository;
import com.ssafy.ssafytime.exception.ResponseHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/reserve")
public class ReserveController {

    @Autowired
    AlarmDefaultService alarmDefaultService;

    @Autowired
    AlarmDefaultRepository alarmDefaultRepository;

    @Autowired
    UserService userService;

    @Autowired
    UserRepository userRepository;

    private final MeetService meetService;
    public ReserveController(AlarmDefaultService alarmDefaultService, AlarmDefaultRepository alarmDefaultRepository, MeetService meetService){
        this.alarmDefaultService = alarmDefaultService;
        this.alarmDefaultRepository = alarmDefaultRepository;
        this.meetService = meetService;
    }

    // 클래스와 지역정보를 받아 해당하는 매니저 정보 반환
    @GetMapping(value = "/info", produces = { MediaType.APPLICATION_JSON_VALUE }) // 요청을 json type의 데이터만 담고 있는 요청 처리
    public ResponseEntity<Map<String, Object>> getManagerInfo(@RequestParam("classNum") Integer classNum, @RequestParam("regionCode") Integer regionCode) {
        return new ResponseEntity(meetService.getManagerInfo(classNum, regionCode), HttpStatus.OK);
    }

    // 상담 등록 요청
    @PostMapping(value = "/submit", produces = { MediaType.APPLICATION_JSON_VALUE }) // 요청을 json type의 데이터만 담고 있는 요청 처리
    public ResponseEntity<Object> postReserve(@RequestBody ReserveDto reserveDto) throws FirebaseMessagingException {
        // create
        meetService.save(reserveDto);

        // 알림보내기
        Optional<User> user = userService.findById(reserveDto.getManagerId());  // 상담 요청된 관리자의 엔티티받아옴
        MessageDTO messageDTO = MessageDTO.builder().title("상담 요청 알림").body(reserveDto.getRezDate() + " " + reserveDto.getRezTime() + " 에 새로운 요청이 있습니다.").build();  // 알림에 넣을 인자들
        List<String> registrationTokens = new ArrayList<>();
        registrationTokens.add(user.get().getToken());  // Optional 형식에서 user 엔티티로 바꾸어서 FCM 토큰 받아옴
        Notification notification = Notification.builder().setTitle(messageDTO.getTitle()).setBody(messageDTO.getBody()).setImage(null).build();  // 없으면 알림 안보내짐
        if(registrationTokens.isEmpty()) {  // 알림 보낼 사람이 하나도 없을 때
            return ResponseHandler.generateResponse(false, "there is no people to send FCM", HttpStatus.NOT_FOUND, null);
        } else {
            if (registrationTokens.contains(null))  // 알림 보낼 사람은 있는데 FCMtoken이 null일때
                return ResponseHandler.generateResponse(false, "there is null FCMtoken", HttpStatus.NOT_FOUND, null);
            Integer FailedAlarmCnt = alarmDefaultService.sendMultiAlarms(notification, registrationTokens);  // 알림보냄
            return ResponseHandler.generateResponse(true, "FailedAlarmCnt : " + FailedAlarmCnt, HttpStatus.OK, null);
        }
    }

    // 해당 날짜에 매니저의 예약 신청 시간 리스트 호출
    @GetMapping(value = "/time", produces = { MediaType.APPLICATION_JSON_VALUE }) // 요청을 json type의 데이터만 담고 있는 요청 처리
    public ResponseEntity<Map<String,List<Double>>> getReserveTime(@RequestParam("date") String date, @RequestParam("managerId") Long managerId) {

        List<Double> timeList = meetService.findByRezDateAndManagerId(date, managerId);
        Map<String, List> map = new HashMap<>();
        map.put("time", timeList);
        return new ResponseEntity(map, HttpStatus.OK);

    }


}
