package com.ssafy.ssafytime.api.service.schedule;

import com.ssafy.ssafytime.db.dto.schedule.ScheduleResponseDto;

import java.util.HashMap;
import java.util.List;
import java.util.Optional;

public interface ScheduleService {
    ScheduleResponseDto getCurrentSchedule(int trackCode, int interval);

    HashMap<Integer, List<ScheduleResponseDto>> getWeekSchedule(int trackCode);
}
