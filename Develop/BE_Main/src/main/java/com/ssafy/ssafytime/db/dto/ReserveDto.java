package com.ssafy.ssafytime.db.dto;

import com.ssafy.ssafytime.db.entity.MeetList;
import com.ssafy.ssafytime.db.entity.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

@Getter
@NoArgsConstructor
public class ReserveDto {
//    private User studentId;
//    private User managerId;
    // 교육생
    private Long studentId;
    // 매니저
    private Long managerId;
    // 예약 날짜
    private LocalDate rezDate;
    // 예약 시간
    private String rezTime; // 11:30 이런 식으로 들어올 거임 ( 돌려줄 땐 11.5 로 넘겨주자)
    // 상담 제목
    private String title;
    // 상담 카테고리
    private String category;

    @Builder
    public ReserveDto(Long studentId, Long managerId, LocalDate rezDate, String rezTime, String title, String category) {
        this.studentId = studentId;
        this.managerId = managerId;
        this.rezDate = rezDate;
        this.rezTime = rezTime;
        this.title = title;
        this.category = category;
    }

    // Dto -> Entity
    public MeetList toEntity(User studentId, User managerId, Double rezTime) {

        return MeetList.builder().studentId(studentId).managerId(managerId).rezDate(rezDate).rezTime(rezTime).title(title).category(category).subTime(LocalDateTime.now()).build();
    }
}

