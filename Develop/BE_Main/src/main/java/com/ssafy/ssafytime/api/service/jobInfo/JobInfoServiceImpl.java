package com.ssafy.ssafytime.api.service.jobInfo;

import com.ssafy.ssafytime.db.dto.jobInfo.JobInfoRequestDto;
import com.ssafy.ssafytime.db.dto.jobInfo.JobInfoResponseDto;
import com.ssafy.ssafytime.db.entity.JobInfoEntity;
import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.JobInfoRepository;
import com.ssafy.ssafytime.db.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
@AllArgsConstructor
public class JobInfoServiceImpl implements JobInfoService{

    final JobInfoRepository jobInfoRepository;

    @Override
    public void save(HashMap<String, Object> jobInfo) {
        JobInfoRequestDto jobInfoRequest = new JobInfoRequestDto();
        jobInfoRequest.setStartDate(Long.parseLong(String.valueOf(jobInfo.get("startDate"))));
        jobInfoRequest.setEndDate(Long.parseLong(String.valueOf(jobInfo.get("endDate"))));
        jobInfoRequest.setCompany(String.valueOf(jobInfo.get("company")));
        jobInfoRequest.setJob(String.valueOf(jobInfo.get("job")));
        jobInfoRequest.setLink(String.valueOf(jobInfo.get("link")));
        jobInfoRepository.save(jobInfoRequest.toEntity());
    }

    @Override
    public List<JobInfoResponseDto> getAllJobInfo() {
        Long date = Long.parseLong(LocalDateTime.now().toString().replace("-","").replace(":", "").replace("T", "").substring(0,14));
        List<JobInfoResponseDto> jobInfoResponseDtoList = new ArrayList<>();
        jobInfoRepository.findByStartDateLessThanEqualOrderByStartDate(date).forEach(jobInfo -> {
            jobInfoResponseDtoList.add(new JobInfoResponseDto(jobInfo));
        });
        return jobInfoResponseDtoList;
    }
}
