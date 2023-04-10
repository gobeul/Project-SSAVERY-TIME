package com.ssafy.ssafytime.db.dto;


import com.ssafy.ssafytime.db.entity.User;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.jetbrains.annotations.NotNull;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Setter
@Getter
@ToString
public class MeetInfoDto {
    // 상담 날짜
    private LocalDate rezDate;
    // 상담 시간
    private Double rezTime;
    // 상담 제목
    private String title;
    // 상담 카테고리
    private String category;
    // 세션 아이디
    private String sessionId;
    // 상담 번호
    private Long rezIdx;
    // 거절 사유
    private String reject;
    // 상담 상태
    private Long state;
    // 이름
    private String name;
    // 등록 날짜
    private LocalDateTime subTime;



}
