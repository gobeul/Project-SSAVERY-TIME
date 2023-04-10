package com.ssafy.ssafytime.api.service;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Notification;

import com.ssafy.ssafytime.api.firebase.MessageDTO;
import com.ssafy.ssafytime.db.dto.AlarmDefaultRequestDto;
import com.ssafy.ssafytime.db.dto.AlarmDefaultResponseDto;
import com.ssafy.ssafytime.db.dto.UserDto;
import com.ssafy.ssafytime.db.entity.User;
import org.springframework.stereotype.Service;

import java.util.List;

public interface AlarmDefaultService {
    AlarmDefaultResponseDto getDefaultAlarmSetting(Long userId);

    List<AlarmDefaultResponseDto> findAllBySurveyAlarm(boolean chk);

    List<AlarmDefaultResponseDto> findAllByNoticeAlarm(boolean chk);

    List<AlarmDefaultResponseDto> findAllByConsultingAlarm(boolean chk);


    public List<String> getUserTokens(int chk, MessageDTO messageDTO);

    Integer sendMultiAlarms(Notification notification, List<String> registrationTokens) throws FirebaseMessagingException;  // 알림 보내는 함수



    void noticeChange(Long userId);

    void surveyChange(Long userId);

    void consultingChange(Long userId);

    void save(Long userId);
}
