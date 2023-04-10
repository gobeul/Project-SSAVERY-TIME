package com.ssafy.ssafytime.db.dto.schedule;

import com.ssafy.ssafytime.db.entity.schedule.ScheduleEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

/* 시간표(현재, 주간) 조회 DTO(develop_AJH) */
@Getter
@ToString
public class ScheduleResponseDto {
    private int date;

    private int startTime;

    private int endTime;

    private int onOff;

    private String title;

    private String subTitle;

    private Long category;

    private int totalTime;

    @Builder
    public ScheduleResponseDto(ScheduleEntity scheduleEntity) {
        this.date = scheduleEntity.getDate();
        this.startTime = scheduleEntity.getStartTime();
        this.endTime = scheduleEntity.getEndTime();
        this.onOff = scheduleEntity.getOnOff();
        this.title = scheduleEntity.getTitle();
        this.subTitle = scheduleEntity.getSubTitle();
        this.category = scheduleEntity.getScheduleCategoryEntity().getId();
        this.totalTime = scheduleEntity.getEndTime() - scheduleEntity.getStartTime();
    }
}
