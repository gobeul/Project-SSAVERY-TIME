package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.entity.schedule.ScheduleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/* develop_AJH */
@Repository
public interface ScheduleRepository extends JpaRepository<ScheduleEntity, Long> {
    /* 조건
    TrackCode               : 트랙코드 일치
    Date                    : 날짜 일치
    StartTimeLessThanEqual  : 시작시간이 인자값 이하
    EndTimeGreaterThan      : 끝나는 시간이 인자값 초과
     */
    Optional<ScheduleEntity> findByTrackCodeAndDateAndStartTimeLessThanEqualAndEndTimeGreaterThan(int trackCode, int date, int startTime, int endTime);

    /* 조건
    TrackCode               : 트랙코드 일치
    Date                    : 날짜 일치
    OrderByStartTime        : 시작 시간을 기준으로 오름차순 정렬
     */
    List<ScheduleEntity> findByTrackCodeAndDateOrderByStartTime(int trackCode, int date);
}
