package com.ssafy.ssafytime.api.service.survey;

import com.ssafy.ssafytime.api.response.AllSurveyRes;
import com.ssafy.ssafytime.db.dto.survey.SurveyResDto;
import com.ssafy.ssafytime.db.entity.survey.Survey;
import com.ssafy.ssafytime.db.repository.survey.SurveyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


@Service("surveyService")
public class SurveyServiceImpl implements SurveyService {
    @Autowired
    SurveyRepository surveyRepository;

    @Override
    public List<SurveyResDto> findAll() {
        List<SurveyResDto> surveyResList = new ArrayList<>();  // 반환형태인 DTO의 리스트로!
        surveyRepository.findAll().forEach((Survey)->
                surveyResList.add(new SurveyResDto(Survey)));
        // Survey 엔티티 List로 받아서 하나씩 DTO로 변경해서 DTO List에 추가
        return surveyResList;
    }

    @Override
    public Optional<Survey> findById(Long Id) {
        return surveyRepository.findById(Id);
    }

    @Override
    public List<Survey> findAllByStatus(Integer status) {
        return surveyRepository.findAllByStatus(status);
    }

    @Override
    public void save(Survey survey) {
        surveyRepository.save(survey);
    }
}
