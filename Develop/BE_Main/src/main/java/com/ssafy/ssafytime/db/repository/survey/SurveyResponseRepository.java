package com.ssafy.ssafytime.db.repository.survey;

import com.ssafy.ssafytime.db.entity.survey.SurveyResponse;
import com.ssafy.ssafytime.db.entity.survey.SurveyResponseKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository

public interface SurveyResponseRepository extends JpaRepository<SurveyResponse, SurveyResponseKey> {
}
