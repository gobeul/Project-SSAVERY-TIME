package com.ssafy.ssafytime.db.dto;

import com.ssafy.ssafytime.db.entity.AlarmDefault;
import com.ssafy.ssafytime.db.entity.User;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

/* 기본 알림 조회 DTO(develop_AJH) */
@Getter
@ToString
public class AlarmDefaultResponseDto {
    private Boolean noticeAlarm;
    private Boolean surveyAlarm;
    private Boolean consultingAlarm;
    private User user;

    @Builder
    public AlarmDefaultResponseDto(AlarmDefault alarmDefault) {
        this.noticeAlarm = alarmDefault.getNoticeAlarm();
        this.surveyAlarm = alarmDefault.getSurveyAlarm();
        this.consultingAlarm = alarmDefault.getConsultingAlarm();
        this.user = alarmDefault.getUser();
    }
}
