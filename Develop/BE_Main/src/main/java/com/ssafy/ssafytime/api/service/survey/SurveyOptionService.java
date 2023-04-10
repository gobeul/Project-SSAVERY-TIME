package com.ssafy.ssafytime.api.service.survey;

import com.ssafy.ssafytime.db.entity.survey.SurveyOption;

import java.util.List;
import java.util.Optional;

public interface SurveyOptionService {
    Optional<SurveyOption> findById(Long Id);
    List<SurveyOption> findAllById(Long Id);
}
