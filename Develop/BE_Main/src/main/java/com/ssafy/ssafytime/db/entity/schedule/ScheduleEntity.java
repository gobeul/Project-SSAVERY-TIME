package com.ssafy.ssafytime.db.entity.schedule;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

/* 시간표 Entity(develop_AJH)
================================================|| attribute ||=========================================================
id(PK)          : 인덱싱 번호
track_code      : 트랙 코드(0: 모두, 1: 파이선, 2: 자바(비전공), 3: 자바(전공), 4: 임베디드, 5: 모바일)
date            : 날짜(ex : 20230210)
start_time      : 시작 시간(ex : 13)
end_time        : 끝나는 시간(ex : 15)
title           : 제목
sub_title       : 부제목
on_off          : on/off 여부(ex : true, false)
category_id(FK) : 시간표 분류(1: 알고리즘, 2: 코딩과정, 3: 프로젝트, 4: 기타)
========================================================================================================================
*/
@Getter
@Entity
@NoArgsConstructor
@Table(name = "schedule")
public class ScheduleEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "track_code")
    private int trackCode;

    @Column(name = "date")
    private int date;

    @Column(name = "start_time")
    private int startTime;

    @Column(name = "end_time")
    private int endTime;

    @Column(name = "title")
    private String title;

    @Column(name = "sub_title")
    private String subTitle;

    @Column(name = "on_off")
    private int onOff;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private ScheduleCategoryEntity scheduleCategoryEntity;
}
