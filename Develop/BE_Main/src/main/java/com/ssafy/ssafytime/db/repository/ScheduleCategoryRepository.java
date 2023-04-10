package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.entity.schedule.ScheduleCategoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ScheduleCategoryRepository extends JpaRepository<ScheduleCategoryEntity, Long> {
}
