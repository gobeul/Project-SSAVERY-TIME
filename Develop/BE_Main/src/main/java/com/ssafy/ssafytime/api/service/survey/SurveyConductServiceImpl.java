package com.ssafy.ssafytime.api.service.survey;

import com.ssafy.ssafytime.db.dto.survey.SurveyResDto;
import com.ssafy.ssafytime.db.entity.survey.Survey;
import com.ssafy.ssafytime.db.entity.survey.SurveyConduct;
import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.survey.SurveyConductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service("surveyConductService")
public class SurveyConductServiceImpl implements SurveyConductService {
    @Autowired
    SurveyConductRepository surveyConductRepository;

    @Override
    public void save(SurveyConduct surveyConduct) {
        surveyConductRepository.save(surveyConduct);
    }

    @Override
    public Optional<Survey> findByUserIdxAndSurveyIdx(User user, Survey survey) {
        return surveyConductRepository.findByUserIdxAndSurveyIdx(user, survey);
    }

    @Override
    public List<SurveyResDto> findAllByUserIdx(User user) {
        List<Survey> surveyList = new ArrayList<>();  // SurveyConduct리스트를 바꿀 Survey 리스트
        List<SurveyResDto> surveyResList = new ArrayList<>();  // 반환형태인 DTO의 리스트로!

        // SurveyConduct 리스트를 Survey 리스트로 바꿈
        surveyConductRepository.findAllByUserIdx(user).forEach((surveyConduct)->
                surveyList.add(surveyConduct.getSurveyIdx()));

        // Survey List 받아서 하나씩 DTO로 변경해서 DTO List에 추가
        for (Survey survey : surveyList) {
            surveyResList.add(new SurveyResDto(survey));
        }
        return surveyResList;
    }


}
