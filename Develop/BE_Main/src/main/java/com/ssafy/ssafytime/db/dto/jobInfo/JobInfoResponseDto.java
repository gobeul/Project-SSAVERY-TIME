package com.ssafy.ssafytime.db.dto.jobInfo;

import com.ssafy.ssafytime.db.entity.JobInfoEntity;
import com.ssafy.ssafytime.db.entity.User;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class JobInfoResponseDto {
    private String date;
    private String company;
    private String job;
    private String link;

    @Builder
    public JobInfoResponseDto(JobInfoEntity jobInfo) {
        String startDate = jobInfo.getStartDate().toString();
        startDate = startDate.substring(0, 4) + "." + startDate.substring(4, 6) + "." + startDate.substring(6, 8);
        String endDate = jobInfo.getEndDate().toString();
        endDate = endDate.substring(0, 4) + "." + endDate.substring(4, 6) + "." + endDate.substring(6, 8);
        this.date = startDate + " ~ " + endDate;
        this.company = jobInfo.getCompany();
        this.job = jobInfo.getJob();
        this.link = jobInfo.getLink();
    }
}
