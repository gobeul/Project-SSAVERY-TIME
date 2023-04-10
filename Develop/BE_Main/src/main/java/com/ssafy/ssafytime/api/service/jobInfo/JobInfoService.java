package com.ssafy.ssafytime.api.service.jobInfo;

import com.ssafy.ssafytime.db.dto.jobInfo.JobInfoRequestDto;
import com.ssafy.ssafytime.db.dto.jobInfo.JobInfoResponseDto;
import com.ssafy.ssafytime.db.entity.JobInfoEntity;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;

public interface JobInfoService {

    void save(HashMap<String, Object> jobInfo);

    List<JobInfoResponseDto> getAllJobInfo();
}
