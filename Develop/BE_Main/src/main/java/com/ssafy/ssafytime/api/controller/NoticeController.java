package com.ssafy.ssafytime.api.controller;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Notification;
import com.ssafy.ssafytime.api.firebase.MessageDTO;
import com.ssafy.ssafytime.api.service.AlarmDefaultService;
import com.ssafy.ssafytime.db.dto.notice.NoticeRequestDto;
import com.ssafy.ssafytime.db.dto.notice.NoticeResponseDto;
import com.ssafy.ssafytime.db.repository.AlarmDefaultRepository;
import com.ssafy.ssafytime.exception.ResponseHandler;
import com.ssafy.ssafytime.api.service.notice.NoticeServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("notice")
public class NoticeController {

    private final AlarmDefaultService alarmDefaultService;

    private final NoticeServiceImpl noticeService;

    /* 최신 공지사항 조회(develop_AJH)
     */
    @GetMapping("")
    public ResponseEntity<Object> recentNotice() {
        return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, noticeService.getRecentNotice());
    }

    /* 단일 공지사항 조회(develop_AJH)
    ================================================|| parameter ||=========================================================
    id : 공지사항 id
    ========================================================================================================================
     */
    @GetMapping("/{id}")
    public ResponseEntity<Object> notice(@PathVariable Long id) {
        return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, noticeService.getNotice(id));
    }

    /* 전체 공지사항 조회(develop_AJH)
     */
    @GetMapping("/all")
    public ResponseEntity<Object> noticeAll(){
        return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, noticeService.getAllNotice());
    }

    /* 공지사항 생성(develop_AJH)
    ================================================|| parameter ||=========================================================
    title       : 제목
    category    : 분류
    contentUrl  : 내용 이미지 URL
    ========================================================================================================================
     */
    @PostMapping(value = "/create", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> createNotice(@RequestBody NoticeRequestDto noticeRequestDto) throws FirebaseMessagingException {
        noticeService.save(noticeRequestDto);

        MessageDTO messageDTO = MessageDTO.builder().title("새로운 공지가 있습니다").body(noticeRequestDto.getTitle()).build();  // 알림에 넣을 인자들
        List<String> registrationTokens = alarmDefaultService.getUserTokens(2, messageDTO);  // 1 : 설문, 2 : 공지 , 3: 상담 으로 설정하여 알림보낼 유저들 토큰 얻는 함수

        if (registrationTokens.isEmpty()) {  // 토큰이 있는 사람중에 알림 보낼 사람이 하나도 없을 때
            return ResponseHandler.generateResponse(false, "there is no people to send FCM", HttpStatus.NOT_FOUND, null);
        } else {
            if (registrationTokens.contains(null)) { // 알림 보낼 사람은 있는데 FCMtoken이 null일때
                return ResponseHandler.generateResponse(false, "there is null FCMtoken", HttpStatus.NOT_FOUND, null);
            }
            Notification notification = Notification.builder().setTitle(messageDTO.getTitle()).setBody(messageDTO.getBody()).setImage(null).build();  // 없으면 알림 안보내짐
            Integer FailedAlarmCnt = alarmDefaultService.sendMultiAlarms(notification, registrationTokens);
            return ResponseHandler.generateResponse(true, "FailedAlarmCnt : " + FailedAlarmCnt, HttpStatus.OK, null);
        }

    }
}
