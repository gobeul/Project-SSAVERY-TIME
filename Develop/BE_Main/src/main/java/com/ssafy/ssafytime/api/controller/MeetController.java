package com.ssafy.ssafytime.api.controller;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Notification;
import com.ssafy.ssafytime.api.firebase.MessageDTO;
import com.ssafy.ssafytime.api.service.AlarmDefaultService;
import com.ssafy.ssafytime.api.service.MeetService;
import com.ssafy.ssafytime.db.dto.MeetInfoDto;
import com.ssafy.ssafytime.db.entity.MeetList;
import com.ssafy.ssafytime.db.repository.AlarmDefaultRepository;
import com.ssafy.ssafytime.db.repository.MeetListRepository;
import com.ssafy.ssafytime.exception.ResponseHandler;
import io.openvidu.java.client.*;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Log4j2
@RestController
@RequestMapping("/meet")
public class MeetController {
    // OpenVidu
    // OpenVidu deployment URL, SECRET
    @Value("${OPENVIDU_URL}")
    private String OPENVIDU_URL;
    @Value("${OPENVIDU_SECRET}")
    private String OPENVIDU_SECRET;
    // Openvidu object
    private OpenVidu openvidu;
    @PostConstruct
    public void init() {
        this.openvidu = new OpenVidu(OPENVIDU_URL, OPENVIDU_SECRET);
    }

    @Autowired
    AlarmDefaultService alarmDefaultService;

    @Autowired
    AlarmDefaultRepository alarmDefaultRepository;
    private final MeetService meetService;
    private final MeetListRepository meetListRepository;

    public MeetController(MeetService meetService,
                          MeetListRepository meetListRepository){
        this.meetService = meetService;
        this.meetListRepository = meetListRepository;
    }

    // 회원번호로 한명의 회원 조회
    // code값이 0이면 교육생 1이면 매니저
    @GetMapping(value = "/{userId}/{code}", produces = { MediaType.APPLICATION_JSON_VALUE }) // 요청을 json type의 데이터만 담고 있는 요청 처리
    public ResponseEntity<List<MeetInfoDto>> getMember(@PathVariable("userId") Long userId, @PathVariable("code") int code)
            throws OpenViduJavaClientException, OpenViduHttpException, FirebaseMessagingException{

        // 본인의 상담 예약 정보 리스트
        List<MeetInfoDto> member = null;

        // 교육생
        if(code==0){
            // Optional : 'null일 수도 있는 객체'를 감싸는 일종의 Wrapper 클래스
            member = meetService.findAllByStudentId_UserIdx(userId);

        }
        // 관리자
        else if(code==1){
            // Optional : 'null일 수도 있는 객체'를 감싸는 일종의 Wrapper 클래스
            member = meetService.findAllByManagerId_UserIdx(userId);
        }


        // 종료상태면 세션 종료
//        member.forEach(m->{
//            if(m.getState()==4) {
//                // 세선 닫아버리기
//
////                Session session = openvidu.getActiveSession(m.getSessionId());
//
////                if (session != null) {
////
////                }
////                if (session != null) {
////                    try {
////                        session.close();
////                    } catch (OpenViduJavaClientException e) {
////                        throw new RuntimeException(e);
////                    } catch (OpenViduHttpException e) {
////                        throw new RuntimeException(e);
////                    }
////                }
//
//            }
//        });

        // 정렬
        // 1순위 : state 2 - 1 - 3 - 4
        // 2순위 상담 시작 시간 오름차순

        int endPoint = -1; // 2가 아닌 시점

        // 2를 앞쪽으로
        for(int i=0; i<member.size(); i++){
            Long nowState = member.get(i).getState();
            // 2면 두고 나머지는 오름차순
            if(nowState==2) continue;
            for(int j=i+1; j<member.size(); j++){
                if(member.get(j).getState() == 2) {
                    MeetInfoDto temp = member.get(i);
                    member.set(i, member.get(j));
                    member.set(j, temp);
                    endPoint = i;
                }
            }
        }

        // 2 제외 오름차순
        for(int i=endPoint+1; i<member.size(); i++){
            Long nowState = member.get(i).getState();
            for(int j=i+1; j<member.size(); j++){
                if(nowState > member.get(j).getState()) {
                    MeetInfoDto temp = member.get(i);
                    member.set(i, member.get(j));
                    member.set(j, temp);
                }
            }
        }

        // 상담 시작 시간 오름차순
        // 2 제외 오름차순
        for(int i=0; i<member.size(); i++){
            Double preTime = Integer.parseInt(member.get(i).getRezDate().toString().replace("-", "")) + member.get(i).getRezTime();
            Long nowState = member.get(i).getState();
            for(int j=i+1; j<member.size(); j++){
                if(nowState != member.get(j).getState()) continue;

                Double nowTime = Integer.parseInt(member.get(j).getRezDate().toString().replace("-", "")) + member.get(j).getRezTime();

                if(preTime > nowTime) {
                    MeetInfoDto temp = member.get(i);
                    member.set(i, member.get(j));
                    member.set(j, temp);
                }
            }
        }

        return new ResponseEntity(member, HttpStatus.OK);
    }

    // 거절사유 등록 ( 매니저가 등록 )
    // rez_idx는 예약된 상담의 번호, reject는 거절 사유
    @PutMapping("/update/reject")
    public ResponseEntity<Object> putReject(@RequestParam("rez_idx") Long rezIdx, @RequestParam("reject") String reject) throws FirebaseMessagingException {

        // 예약된 상담의 정보 가져오기
        MeetList member = meetService.findByRezIdx(rezIdx);
        // 상태 ( 1(대기중) -> 3(거절) )
        member.setState(3L);
        // 거절사유 등록
        member.setReject(reject);
        meetService.update(member);


        Double doubleTime = 0.0;  // 상담 알림 메시지 위함
        doubleTime = Math.floor(member.getRezTime());
        String time = null;
        if(member.getRezTime()%1.0 == 0.5)  // 시간이 16.5 면 16:30으로 바꾸게!
            time = String.valueOf(doubleTime) + ":30";
        else
            time = String.valueOf(doubleTime) + ":00";
        // 알림 보내기
        MessageDTO messageDTO = MessageDTO.builder().title("상담 거절 알림").body(member.getRezDate() + " " + time + " 상담 거절됨").build();  // 알림에 넣을 인자들
        List<String> registrationTokens = alarmDefaultService.getUserTokens(3, messageDTO);  // 1 : 설문, 2 : 공지 , 3: 상담 으로 설정하여 알림보낼 유저들 토큰 얻는 함수
        if(registrationTokens.isEmpty()) {  // 알림 보낼 사람이 하나도 없을 때
            return ResponseHandler.generateResponse(false, "there is no people to send FCM", HttpStatus.NOT_FOUND, null);
        } else {
            if (registrationTokens.contains(null))  // 알림 보낼 사람은 있는데 FCMtoken이 null일때
                return ResponseHandler.generateResponse(false, "there is null FCMtoken", HttpStatus.NOT_FOUND, null);
            Notification notification = Notification.builder().setTitle(messageDTO.getTitle()).setBody(messageDTO.getBody()).setImage(null).build();  // 없으면 알림 안보내짐
            Integer FailedAlarmCnt = alarmDefaultService.sendMultiAlarms(notification, registrationTokens);
            return ResponseHandler.generateResponse(true, "FailedAlarmCnt : " + FailedAlarmCnt, HttpStatus.OK, null);
        }
    }

    // 상담승인 등록 ( 매니저가 등록 )
    // rez_idx는 예약된 상담의 번호
    // Basic EncodeBase64(OPENVIDUAPP:<YOUR_SECRET>), Content-Type: application/json 헤더로 받기
    // 세션 생성
    @PutMapping("/update/accept")
    public ResponseEntity<Object> putAccept(@RequestBody(required = false) Map<String, Object> params, @RequestParam("rez_idx") Long rezIdx)
            throws OpenViduJavaClientException, OpenViduHttpException, FirebaseMessagingException {

        // 예약된 상담의 정보 가져오기
        MeetList member = meetService.findByRezIdx(rezIdx);
        // 이미 상태가 2라면 cut!
        if(member.getState()==2L){
            return ResponseEntity.ok().body("이미 수락 되어 있어요~");
        }

        // 세션 생성
        SessionProperties properties = SessionProperties.fromJson(params).build();
        Session session = openvidu.createSession(properties);

        // 세션 아이디 저장
        member.setSessionId(session.getSessionId());
        // 상태 ( 1(대기중) -> 2(승인) )
        member.setState(2L);
        meetService.update(member);

        Double doubleTime = 0.0;  // 상담 알림 메시지 위함
        int hour = (int) Math.floor(member.getRezTime());
        String time = null;
        if(member.getRezTime()%1.0 == 0.5)  // 시간이 16.5 면 16:30으로 바꾸게!
            time = String.valueOf(hour) + ":30";
        else
            time = String.valueOf(hour) + ":00";

        System.out.println(time);

        // 알림 보내기
        MessageDTO messageDTO = MessageDTO.builder().title("상담 승인 알림").body(member.getRezDate() + " " + time + " 상담 승인됨").build();  // 알림에 넣을 인자들
        List<String> registrationTokens = alarmDefaultService.getUserTokens(3, messageDTO);  // 1 : 설문, 2 : 공지 , 3: 상담 으로 설정하여 알림보낼 유저들 토큰 얻는 함수
        if(registrationTokens.isEmpty()) {  // 알림 보낼 사람이 하나도 없을 때
            return ResponseHandler.generateResponse(false, "there is no people to send FCM", HttpStatus.NOT_FOUND, null);
        } else {
            if (registrationTokens.contains(null))  // 알림 보낼 사람은 있는데 FCMtoken이 null일때
                return ResponseHandler.generateResponse(false, "there is null FCMtoken", HttpStatus.NOT_FOUND, null);
            Notification notification = Notification.builder().setTitle(messageDTO.getTitle()).setBody(messageDTO.getBody()).setImage(null).build();  // 없으면 알림 안보내짐
            Integer FailedAlarmCnt = alarmDefaultService.sendMultiAlarms(notification, registrationTokens);
            return ResponseHandler.generateResponse(true, "FailedAlarmCnt : " + FailedAlarmCnt, HttpStatus.OK, null);
        }

    }

    // api 설계서 기준 초기화 (프론트 테스트용)
    // rez_idx는 예약된 상담의 번호
    @PutMapping("/update/reset")
    public ResponseEntity<Object> putReset(@RequestParam("rez_idx") Long rezIdx) throws FirebaseMessagingException {

        // 예약된 상담의 정보 가져오기
        MeetList member = meetService.findByRezIdx(rezIdx);
        // 상태 1로 초기화
        member.setState(1L);
        meetService.update(member);

        return ResponseEntity.ok().body("state --> 1 초기화 했습니돠 ");
    }

    // api 설계서 기준 초기화 (프론트 테스트용)
    // rez_idx는 예약된 상담의 번호
    @PutMapping("/update/end")
    public ResponseEntity<Object> putEnd(@RequestParam("rez_idx") Long rezIdx) throws FirebaseMessagingException {

        // 예약된 상담의 정보 가져오기
        MeetList member = meetService.findByRezIdx(rezIdx);
        // 상태 1로 초기화
        member.setState(4L);
        meetService.update(member);

        return ResponseEntity.ok().body("state --> 4 초기화 했습니돠 ");
    }

}
