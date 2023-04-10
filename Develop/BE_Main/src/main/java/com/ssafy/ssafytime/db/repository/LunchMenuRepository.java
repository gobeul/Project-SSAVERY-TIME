package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.entity.lunchmenu.LunchMenuEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/* develop_AJH */
@Repository
public interface LunchMenuRepository extends JpaRepository<LunchMenuEntity, Long> {
    /* 조건
    Region  : 지역 코드 일치
    Date    : 날짜 일치
     */
    List<LunchMenuEntity> findByRegionAndDate(int region, String date);
}