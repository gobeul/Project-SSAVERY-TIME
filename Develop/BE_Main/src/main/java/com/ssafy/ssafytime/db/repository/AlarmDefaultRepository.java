package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.entity.AlarmDefault;
import com.ssafy.ssafytime.db.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public interface AlarmDefaultRepository extends JpaRepository<AlarmDefault, Long> {

    List<AlarmDefault> findAllBySurveyAlarm(boolean chk);  // 설문 알림 설정 되어있는 유저들만 반환

    List<AlarmDefault> findAllByConsultingAlarm(boolean chk);

    List<AlarmDefault> findAllByNoticeAlarm(boolean chk);

    @Modifying
    @Transactional
    @Query("UPDATE AlarmDefault SET noticeAlarm = case when noticeAlarm = true then false else true end WHERE userId = :userId")
    void noticeUpdate(Long userId);

    @Modifying
    @Transactional
    @Query("UPDATE AlarmDefault SET surveyAlarm = case when surveyAlarm = true then false else true end WHERE userId = :userId")
    void surveyUpdate(Long userId);

    @Modifying
    @Transactional
    @Query("UPDATE AlarmDefault SET consultingAlarm = case when consultingAlarm = true then false else true end WHERE userId = :userId")
    void consultingUpdate(Long userId);
}
