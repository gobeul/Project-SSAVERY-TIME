package com.ssafy.ssafytime.db.entity;

import com.ssafy.ssafytime.api.dto.AttendanceDto;
import lombok.*;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "attendance")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Attendance{

    @EmbeddedId
    private AttendanceId id;

    @MapsId("userIdx")
    @ManyToOne
    @JoinColumn(name = "user_idx")
    public User user;






}