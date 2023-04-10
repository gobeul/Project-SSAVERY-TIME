package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.entity.JobInfoEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface JobInfoRepository extends JpaRepository<JobInfoEntity, Long> {
    List<JobInfoEntity> findByStartDateLessThanEqualOrderByStartDate(Long date);


}
