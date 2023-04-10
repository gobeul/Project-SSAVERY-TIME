package com.ssafy.ssafytime.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;

/* 알림 Entity(develop_AJH)
================================================|| attribute ||=========================================================
id(PK)              : 인덱싱 번호
user_id(FK)         : 사용자 id(학번)
notice_alarm        : 공지사항 알림 상태
survey_alarm        : 설문조사 알림 상태
consulting_alarm    : 상담 알림 상태
========================================================================================================================
*/
@Getter
@NoArgsConstructor
@Entity
@DynamicInsert
@Table(name = "alarm_default")
public class AlarmDefault {
    @Id
    @Column(name="user_id")
    private Long userId;

    @OneToOne
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "notice_alarm")
    @ColumnDefault("true")
    private Boolean noticeAlarm;

    @Column(name = "survey_alarm")
    @ColumnDefault("true")
    private Boolean surveyAlarm;

    @Column(name = "consulting_alarm")
    @ColumnDefault("true")
    private Boolean consultingAlarm;

    @Builder
    public AlarmDefault(User user, Boolean noticeAlarm, Boolean surveyAlarm, Boolean consultingAlarm) {
        this.user = user;
        this.noticeAlarm = noticeAlarm;
        this.surveyAlarm = surveyAlarm;
        this.consultingAlarm = consultingAlarm;
    }
}
