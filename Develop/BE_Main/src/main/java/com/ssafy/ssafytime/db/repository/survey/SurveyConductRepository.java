package com.ssafy.ssafytime.db.repository.survey;

import com.ssafy.ssafytime.db.dto.survey.SurveyResDto;
import com.ssafy.ssafytime.db.entity.survey.Survey;
import com.ssafy.ssafytime.db.entity.survey.SurveyConduct;
import com.ssafy.ssafytime.db.entity.survey.SurveyConductKey;
import com.ssafy.ssafytime.db.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository

public interface SurveyConductRepository extends JpaRepository<SurveyConduct, SurveyConductKey> {
    @Override
    SurveyConduct save(SurveyConduct surveyConduct);

    Optional<Survey> findByUserIdxAndSurveyIdx(User user, Survey survey);

    List<SurveyConduct> findAllByUserIdx(User user);
}
