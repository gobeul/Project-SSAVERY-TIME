package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.entity.MeetList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MeetUpdateRepository extends JpaRepository<MeetList, Long> {
}
