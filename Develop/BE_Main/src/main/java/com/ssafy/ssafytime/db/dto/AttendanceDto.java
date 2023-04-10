package com.ssafy.ssafytime.api.dto;

import com.ssafy.ssafytime.db.entity.Attendance;
import lombok.*;


@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AttendanceDto {

    private Integer Category;

    private Integer count;
}
