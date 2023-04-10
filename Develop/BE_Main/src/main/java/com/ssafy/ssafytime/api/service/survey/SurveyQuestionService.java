package com.ssafy.ssafytime.api.service.survey;

import com.ssafy.ssafytime.api.response.AllQuestionRes;
import com.ssafy.ssafytime.db.entity.survey.SurveyQuestion;

import java.util.List;
import java.util.Optional;

public interface SurveyQuestionService {
    List<SurveyQuestion> findAllBySurvey_IdOrderByIdAsc(long Id);
    Optional<SurveyQuestion> findById(Long Id);

    List<AllQuestionRes> makeQuestionRes(List<SurveyQuestion> allQuestion);
}
