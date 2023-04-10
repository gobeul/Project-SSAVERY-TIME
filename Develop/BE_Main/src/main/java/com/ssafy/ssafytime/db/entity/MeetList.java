package com.ssafy.ssafytime.db.entity;

import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicInsert // insert시 null인 column 제외
public class MeetList {
    @Id
    @Column(name = "rez_idx")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long rezIdx = null;

    @ManyToOne(optional = true, targetEntity = User.class)
    @JoinColumn(name="manager_id")
    User managerId;

    @ManyToOne(optional = true, targetEntity = User.class)
    @JoinColumn(name="student_id")
    User studentId;

    @Column(name = "rez_date")
    LocalDate rezDate;

    @Column(name = "rez_time")
    Double rezTime;
    @ColumnDefault("1") //default 1
    @Column(name = "state")
    Long state;

    @Column(name = "reject")
    String reject;

    @Column(name = "title")
    String title;

    @Column(name = "category")
    String category;

    @Column(name = "sub_time", columnDefinition = "TIMESTAMP")
    LocalDateTime subTime;

    @Column(name = "session_id")
    String sessionId;

}
