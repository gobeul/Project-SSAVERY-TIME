package com.ssafy.ssafytime.db.entity;


import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@Entity(name = "job_info")
public class JobInfoEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "start_date")
    private Long startDate;

    @Column(name = "end_date")
    private Long endDate;

    @Column(name = "company")
    private String company;

    @Column(name = "job")
    private String job;

    @Column(name = "link", nullable = true)
    private String link;

    @Builder
    public JobInfoEntity(Long startDate, Long endDate, String company, String job, String link) {
        this.startDate = startDate;
        this.endDate = endDate;
        this.company = company;
        this.job = job;
        this.link = link;
    }
}
