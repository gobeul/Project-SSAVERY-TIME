package com.ssafy.ssafytime.api.service;

import com.ssafy.ssafytime.db.dto.MeetInfoDto;
import com.ssafy.ssafytime.db.dto.ReserveDto;
import com.ssafy.ssafytime.db.entity.MeetList;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public interface MeetService {

    MeetList findByRezIdx(Long rezIdx);
    void update(MeetList meetList);
    void save(ReserveDto reserveDto);
    List<Double> findByRezDateAndManagerId(String date , Long managerId);
    ArrayList<HashMap<String, Object>> getManagerInfo(Integer classNum, Integer regionCode);
    List<MeetInfoDto> findAllByStudentId_UserIdx(Long userId);
    List<MeetInfoDto> findAllByManagerId_UserIdx(Long userId);
}
