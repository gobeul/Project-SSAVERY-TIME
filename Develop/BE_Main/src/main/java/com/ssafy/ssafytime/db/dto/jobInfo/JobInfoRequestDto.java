package com.ssafy.ssafytime.db.dto.jobInfo;

import com.ssafy.ssafytime.db.entity.JobInfoEntity;
import com.ssafy.ssafytime.db.entity.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class JobInfoRequestDto {
    private Long startDate;
    private Long endDate;
    private String company;
    private String job;
    private String link;

    @Builder
    public JobInfoRequestDto(Long startDate, Long endDate, String company, String job, String link) {
        this.startDate = startDate;
        this.endDate = endDate;
        this.company = company;
        this.job = job;
        this.link = link;
    }

    public JobInfoEntity toEntity() {
        return JobInfoEntity.builder().startDate(startDate).endDate(endDate).company(company).job(job).link(link).build();
    }
}
