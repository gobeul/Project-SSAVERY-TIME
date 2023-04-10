package com.ssafy.ssafytime.api.service.survey;

import com.ssafy.ssafytime.db.entity.survey.SurveyOption;
import com.ssafy.ssafytime.db.repository.survey.SurveyOptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service("surveyOptionService")
public class SurveyOptionServiceImpl implements SurveyOptionService{
    @Autowired
    SurveyOptionRepository surveyOptionRepository;

    @Override
    public Optional<SurveyOption> findById(Long Id) {
        return surveyOptionRepository.findById(Id);
    }

    @Override
    public List<SurveyOption> findAllById(Long Id) {
        return surveyOptionRepository.findAllById(Id);
    }
}
