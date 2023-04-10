package com.ssafy.ssafytime.api.service.survey;

import com.ssafy.ssafytime.api.response.AllQuestionRes;
import com.ssafy.ssafytime.db.entity.survey.SurveyOption;
import com.ssafy.ssafytime.db.entity.survey.SurveyQuestion;
import com.ssafy.ssafytime.db.repository.survey.SurveyOptionRepository;
import com.ssafy.ssafytime.db.repository.survey.SurveyQuestionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service("surveyQuestionService")
public class SurveyQuestionServiceImpl implements SurveyQuestionService{
    @Autowired
    SurveyQuestionRepository surveyQuestionRepository;

    @Autowired
    SurveyOptionRepository surveyOptionRepository;  // 옵션 불러오는 함수 위해서 !!

    @Override
    public List<SurveyQuestion> findAllBySurvey_IdOrderByIdAsc(long Id) {
        return surveyQuestionRepository.findAllBySurvey_IdOrderByIdAsc(Id);
    }

    @Override
    public Optional<SurveyQuestion> findById(Long Id) {
        return surveyQuestionRepository.findById(Id);
    }

    @Override
    public List<AllQuestionRes> makeQuestionRes(List<SurveyQuestion> allQuestion) {
        List<AllQuestionRes> allQuestionRes = new ArrayList<>();  // 응답으로 보낼 전체질문리스트

        for(int i = 0; i < allQuestion.size(); i++) {
            SurveyQuestion question = allQuestion.get(i);  // 받아온 질문리스트 중 i번째 설문
            AllQuestionRes questionRes = new AllQuestionRes();  // 현재 response 클래스 형식으로 클래스 하나 만듦
            questionRes.setId(question.getId());  // 질문 번호 받아옴
            questionRes.setQuestionContent(question.getQuestionContent());  // 받아온 리스트를 조회해가며 i번째 질문의 내용을 받아옴

            List<SurveyOption> surveyOptions = new ArrayList<>();  // 하나의 질문에 속한 선지들 받을 리스트


            for(int j = 0; j < question.getOptionList().length(); j++) {
                Character optionIdx = question.getOptionList().charAt(j);  // option리스트에서 인덱스를 하나씩 받아옴
                if(optionIdx == '{' || optionIdx == ',' || optionIdx == '}')  // 인덱스만 받아올 수 있도록 처리
                    continue;

                Long optionIdxnum = Long.parseLong(optionIdx.toString());
                Optional<SurveyOption> surveyOption = surveyOptionRepository.findById(optionIdxnum);  // 받아온 인덱스로 해당 옵션 객체 가져옴;
                if(surveyOption.isPresent())  // Optional객체는 항상 이렇게 해주어야!
                    surveyOptions.add(surveyOption.get());  //  하나의 질문에 있는 선지 리스트에 선지객체 하나 추가
                else
                    System.out.println("Surveyoption : null");
            }
            questionRes.setOptionList(surveyOptions);  // 한질문에 하나의 선지리스트 추가
            
            allQuestionRes.add(questionRes);  // 하나의 질문을 전체질문응답리스트에 추가
        }

        return allQuestionRes;
    }


}
