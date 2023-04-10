package com.ssafy.ssafytime.db.entity;

import lombok.*;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.time.LocalDate;
import java.util.TimeZone;

@Embeddable
@EqualsAndHashCode
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AttendanceId implements Serializable {

    private Long userIdx;

    @Column(name = "attendance_category")
    private int attendanceCategory;

    @Column(name = "attendance_date")




    private LocalDate attendanceDate;

}
