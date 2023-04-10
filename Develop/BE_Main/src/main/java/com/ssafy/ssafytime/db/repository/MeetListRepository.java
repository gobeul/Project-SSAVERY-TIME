package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.entity.MeetList;
import com.ssafy.ssafytime.db.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface MeetListRepository extends JpaRepository<MeetList,Long> {
    // 교육생 번호에 해당하는 상담리스트 조회
    List<MeetList> findByStudentId(Long userId);
    // 매니저 번호에 해당하는 상담리스트 조회
    List<MeetList> findByManagerId(Long userId);
    // 상담 idx에 해당하는 상담 조회
    MeetList findByRezIdx(Long rezIdx);
    // 예약 날짜와 매니저 번호에 해당하는 상담 리스트 조회
//    List<MeetList> findByRezDateAndManagerId(LocalDate rezDate , Long managerId);
    List<MeetList> findByRezDateAndManagerId(LocalDate rezDate , User managerId);
    // 학생 번호에 해당하는 상담리스트와 상대 이름 조회
    List<MeetList> findAllByStudentId_UserIdx(Long userId);
    // 학생 번호에 해당하는 상담리스트와 상대 이름 조회
    List<MeetList> findAllByManagerId_UserIdx(Long ManagerId);
}


