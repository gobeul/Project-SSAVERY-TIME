package com.ssafy.ssafytime.api.service.survey;

import com.ssafy.ssafytime.db.dto.survey.SurveyResDto;
import com.ssafy.ssafytime.db.entity.survey.Survey;

import java.util.List;
import java.util.Optional;


public interface SurveyService {

    List<SurveyResDto> findAll();

    Optional<Survey> findById(Long Id);

    List<Survey> findAllByStatus(Integer Status);
    void save(Survey survey);
}
