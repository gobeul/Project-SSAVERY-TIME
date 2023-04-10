package com.ssafy.ssafytime.api.service.survey;

import com.ssafy.ssafytime.db.dto.survey.SurveyResDto;
import com.ssafy.ssafytime.db.entity.survey.Survey;
import com.ssafy.ssafytime.db.entity.survey.SurveyConduct;
import com.ssafy.ssafytime.db.entity.User;

import java.util.List;
import java.util.Optional;

public interface SurveyConductService {
    void save(SurveyConduct surveyConduct);

    Optional<Survey> findByUserIdxAndSurveyIdx(User user, Survey survey);

    List<SurveyResDto> findAllByUserIdx(User user);

}
