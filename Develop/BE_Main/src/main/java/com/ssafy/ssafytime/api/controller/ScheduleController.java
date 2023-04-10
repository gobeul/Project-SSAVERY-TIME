package com.ssafy.ssafytime.api.controller;

import com.ssafy.ssafytime.exception.ResponseHandler;
import com.ssafy.ssafytime.api.service.schedule.ScheduleServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
public class ScheduleController {

    private final ScheduleServiceImpl scheduleService;

    /* 현재 시간표 조회 (develop_AJH)
    ================================================|| parameter ||=========================================================
    track_code          : 트랙 코드(0: 2학기(프로젝트), 1: 파이썬(비전공), 2: 자바(비전공), 3: 자바(전공), 4: 모바일, 5: 임베디드
    interval(default=0) : 현재 시간보다 N분 뒤의 시간표를 보고 싶을 경우 사용하는 parameter
    ================================================|| setting ||=========================================================
    required            : false로 설정할 경우 해당 parameter가 들어오지 않는다고 해서 오류 발생 X
    defaultValue        : parameter가 들어오지 않을 경우 defaultValue로 대체
    ========================================================================================================================
     */
    @GetMapping("schedule/now")
    public ResponseEntity<Object> currentSchedule(@RequestParam("track_code") int trackCode, @RequestParam(name="interval", required = false, defaultValue="0") int interval) {
        return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, scheduleService.getCurrentSchedule(trackCode, interval));
    }

    /* 주간 시간표 조회 (develop_AJH)
    ================================================|| parameter ||=========================================================
    track_code          : 트랙 코드(0: 2학기(프로젝트), 1: 파이썬(비전공), 2: 자바(비전공), 3: 자바(전공), 4: 모바일, 5: 임베디드
    ========================================================================================================================
     */
    @GetMapping("schedule/week")
    public ResponseEntity<Object> weekSchedule(@RequestParam("track_code") int trackCode) {
        return ResponseHandler.generateResponse(true, "OK", HttpStatus.OK, scheduleService.getWeekSchedule(trackCode));
    }
}
