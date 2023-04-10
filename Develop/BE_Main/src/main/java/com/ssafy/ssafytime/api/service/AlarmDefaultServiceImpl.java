package com.ssafy.ssafytime.api.service;

import com.google.firebase.messaging.*;
import com.ssafy.ssafytime.api.firebase.MessageDTO;
import com.ssafy.ssafytime.db.dto.AlarmDefaultRequestDto;
import com.ssafy.ssafytime.db.dto.AlarmDefaultResponseDto;
import com.ssafy.ssafytime.db.entity.AlarmDefault;
import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.AlarmDefaultRepository;
import com.ssafy.ssafytime.db.repository.UserRepository;
import com.ssafy.ssafytime.exception.ResponseHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class AlarmDefaultServiceImpl implements AlarmDefaultService{

    final UserRepository userRepository;
    final AlarmDefaultRepository alarmDefaultRepository;

    /* 기본 알림(공지사항, 설문조사, 상담) 설정 가져오기(develop_AJH)
    ================================================|| parameter ||=========================================================
    userId : 사용자 id(학번)
    ========================================================================================================================
     */
    @Override
    public AlarmDefaultResponseDto getDefaultAlarmSetting(Long userId) {
        Optional<AlarmDefault> userAlarmSettings = alarmDefaultRepository.findById(userId);
        return new AlarmDefaultResponseDto(userAlarmSettings.get());
    }

    public List<String> getUserTokens(int chk, MessageDTO messageDTO) {
        List<String> registrationTokens = new ArrayList<>();  // 알림 보낼 토큰들
        List<AlarmDefaultResponseDto> alarmList = new ArrayList<>();
        switch(chk) {
            case 1:  // 설문
                alarmList = this.findAllBySurveyAlarm(true);  // 설문 설정해놓은 알람들 DTO 리스트 가져옴
            case 2:
                alarmList = this.findAllByNoticeAlarm(true);  // 공지 설정해놓은 알람들 DTO 리스트 가져옴
            case 3:
                alarmList = this.findAllByConsultingAlarm(true);  // 상담 설정해놓은 알람들 DTO 리스트 가져옴
            default:
                break;

        }

        List<User> users = new ArrayList<>();  // 관리자가 아니면서 알림설정해놓은(alarm=0) 유저들 가져오는 리스트
        for(int i = 0; i < alarmList.size(); i++) {  // alarmDto로 받아온 리스트를
            User user = alarmList.get(i).getUser();  // 유저로 받아옴
            if(user.getIsAdmin() != 1)  // 유저의 isAdmin을 확인해서 관리자가 아니라면 (관리자에게는 알람 안보내도돼서)
                users.add(user);  // 유저로 바꿔서 리스트에 넣음
        }

        for(int i = 0; i < users.size(); i++) {  // 유저리스트에서
            String token = users.get(i).getToken(); // 토큰 추출
//            System.out.println(token);
//            if(!users.get(i).getToken().equals(null)) {// 토큰이 있는 경우만 registrationTokens에 추가 // 이렇게 하면 안댐!!!!!!!!!!!!!!!!!!!!
//              null.equals 하면 에러가 나요!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            if(token != null)
                registrationTokens.add(users.get(i).getToken());  // 토큰들 추출
//                System.out.println("not null");
//            }
        }


        return registrationTokens;
    }


    @Override
    public Integer sendMultiAlarms(Notification notification, List<String> registrationTokens) throws FirebaseMessagingException {
        MulticastMessage message = MulticastMessage.builder()  // 다수에게 보내기 위한 메세지 생성
                .setNotification(notification)  // 꼭 넣어주기...
                .putData("title", "title")
                .putData("content", "content")
                .addAllTokens(registrationTokens)
                .build();
        BatchResponse response = FirebaseMessaging.getInstance().sendMulticast(message);  // 결과 리턴

        if (response.getFailureCount() > 0) {
            List<SendResponse> responses = response.getResponses();
            List<String> failedTokens = new ArrayList<>();
            for (int i = 0; i < responses.size(); i++) {
                if (!responses.get(i).isSuccessful()) {
                    // The order of responses corresponds ...to the order of the registration tokens.
                    failedTokens.add(registrationTokens.get(i));
                }
            }
        }
        return response.getFailureCount();  // 실패한 토큰 수
    }


    @Override
    public List<AlarmDefaultResponseDto> findAllBySurveyAlarm(boolean chk) {  // 설문조사 알림 켜놓은 사람들의 DTO 리스트 반환
        List<AlarmDefault> userFromAlarm = alarmDefaultRepository.findAllBySurveyAlarm(chk);
        List<AlarmDefaultResponseDto> list = new ArrayList<>();
        for(int i = 0; i < userFromAlarm.size(); i++) {
            list.add(new AlarmDefaultResponseDto(userFromAlarm.get(i)));
        }
        return list;
    }

    public List<AlarmDefaultResponseDto> findAllByConsultingAlarm(boolean chk) {  // 상담 알림 켜놓은 사람들의 DTO 리스트 반환
        List<AlarmDefault> userFromAlarm = alarmDefaultRepository.findAllByConsultingAlarm(chk);
        List<AlarmDefaultResponseDto> list = new ArrayList<>();
        for(int i = 0; i < userFromAlarm.size(); i++) {
            list.add(new AlarmDefaultResponseDto(userFromAlarm.get(i)));
        }
        return list;
    }

    public List<AlarmDefaultResponseDto> findAllByNoticeAlarm(boolean chk) {  // 공지사항 알림 켜놓은 사람들의 DTO 리스트 반환
        List<AlarmDefault> userFromAlarm = alarmDefaultRepository.findAllByNoticeAlarm(chk);
        List<AlarmDefaultResponseDto> list = new ArrayList<>();
        for(int i = 0; i < userFromAlarm.size(); i++) {
            list.add(new AlarmDefaultResponseDto(userFromAlarm.get(i)));
        }
        return list;
    }

    /* 공지사항 알림 on/off 변경(develop_AJH)
    ================================================|| parameter ||=========================================================
    userId : 사용자 id(학번)
    ========================================================================================================================
     */
    @Override
    public void noticeChange(Long userId) {
        /* delete & save 로 update
        AlarmDefault userAlarmSettings = alarmDefaultRepository.findById(userId).get();
        AlarmDefaultRequestDto alarmDefaultRequestDto = new AlarmDefaultRequestDto(userAlarmSettings);
        alarmDefaultRequestDto.setNoticeAlarm(!alarmDefaultRequestDto.getNoticeAlarm());
        alarmDefaultRepository.delete(userAlarmSettings);
        alarmDefaultRepository.save(alarmDefaultRequestDto.toEntity());
         */
        alarmDefaultRepository.noticeUpdate(userId);
    }

    /* 설문조사 알림 on/off 변경(develop_AJH)
    ================================================|| parameter ||=========================================================
    userId : 사용자 id(학번)
    ========================================================================================================================
     */
    @Override
    public void surveyChange(Long userId) {
        /* delete & save 로 update
        AlarmDefault userAlarmSettings = alarmDefaultRepository.findById(userId).get();
        AlarmDefaultRequestDto alarmDefaultRequestDto = new AlarmDefaultRequestDto(userAlarmSettings);
        alarmDefaultRequestDto.setSurveyAlarm(!alarmDefaultRequestDto.getSurveyAlarm());
        alarmDefaultRepository.delete(userAlarmSettings);
        alarmDefaultRepository.save(alarmDefaultRequestDto.toEntity());
         */
        alarmDefaultRepository.surveyUpdate(userId);
    }

    /* 상담 알림 on/off 변경(develop_AJH)
    ================================================|| parameter ||=========================================================
    userId : 사용자 id(학번)
    ========================================================================================================================
     */
    @Override
    public void consultingChange(Long userId) {
        /* delete & save 로 update
        AlarmDefault userAlarmSettings = alarmDefaultRepository.findById(userId).get();
        AlarmDefaultRequestDto alarmDefaultRequestDto = new AlarmDefaultRequestDto(userAlarmSettings);
        alarmDefaultRequestDto.setConsultingAlarm(!alarmDefaultRequestDto.getConsultingAlarm());
        alarmDefaultRepository.delete(userAlarmSettings);
        alarmDefaultRepository.save(alarmDefaultRequestDto.toEntity());
         */
        alarmDefaultRepository.consultingUpdate(userId);
    }

    /* 유저 생성 시 기본 알림 설정 저장(develop_AJH)
    ================================================|| parameter ||=========================================================
    userId : 사용자 id(학번) -> User Entity(int 타입 X)
    ========================================================================================================================
     */
    @Override
    public void save(Long userId) {
        AlarmDefaultRequestDto alarmDefaultRequestDto = new AlarmDefaultRequestDto();
        alarmDefaultRequestDto.setUser(userRepository.findById(userId).get());
        alarmDefaultRepository.save(alarmDefaultRequestDto.toEntity());
    }
}
