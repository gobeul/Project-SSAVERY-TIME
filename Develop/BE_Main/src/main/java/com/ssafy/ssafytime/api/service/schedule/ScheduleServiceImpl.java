package com.ssafy.ssafytime.api.service.schedule;

import com.ssafy.ssafytime.db.dto.schedule.ScheduleResponseDto;
import com.ssafy.ssafytime.db.entity.schedule.ScheduleEntity;
import com.ssafy.ssafytime.db.repository.ScheduleRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
@AllArgsConstructor
public class ScheduleServiceImpl implements ScheduleService{

    final ScheduleRepository scheduleRepository;

    /* 현재 시간표 조회(develop_AJH)
    ================================================|| parameter ||=========================================================
    trackCode : 트랙 코드(0: 2학기(프로젝트), 1: 파이썬, 2:, 자바(비전공), 3: 자바(전공), 4: 모바일, 5: 임베디드)
    ========================================================================================================================
     */
    @Override
    public ScheduleResponseDto getCurrentSchedule(int trackCode, int interval) {
        String[] dateTime = LocalDateTime.now().plusMinutes(interval).toString().split("T");
        System.out.println(dateTime[1]);
        int date = Integer.parseInt(dateTime[0].toString().replace("-", ""));
        int time = Integer.parseInt(dateTime[1].replace(":", "").substring(0, 2));
        if (null == scheduleRepository.findByTrackCodeAndDateAndStartTimeLessThanEqualAndEndTimeGreaterThan(trackCode, date, time, time).orElse(null))
            return null;
        return new ScheduleResponseDto(scheduleRepository.findByTrackCodeAndDateAndStartTimeLessThanEqualAndEndTimeGreaterThan(trackCode, date, time, time).orElse(null));
    }

    @Override
    public HashMap<Integer, List<ScheduleResponseDto>> getWeekSchedule(int trackCode) {
        LocalDate date = LocalDate.now();
        int weekDay = date.getDayOfWeek().getValue();
        if (weekDay >= 6) {
            date = date.plusDays(8 - weekDay);
        } else {
            date = date.minusDays(weekDay - 1);
        }
        HashMap<Integer, List<ScheduleResponseDto>> weekScheduleList = new HashMap<>();
        for (int d=0; d < 5; d++) {
            int dateToInt = Integer.parseInt(date.toString().replace("-", ""));
            List<ScheduleResponseDto> scheduleResponseDtoList = new ArrayList<>();
            scheduleRepository.findByTrackCodeAndDateOrderByStartTime(trackCode, dateToInt).forEach(
                    (scheduleEntity -> {
                        scheduleResponseDtoList.add(new ScheduleResponseDto(scheduleEntity));
                    })
            );
            weekScheduleList.put(d, scheduleResponseDtoList);
            date = date.plusDays(1);
        }
        if (weekScheduleList.isEmpty())
            return null;
        return weekScheduleList;
    }
}
