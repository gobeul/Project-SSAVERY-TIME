package com.ssafy.ssafytime.api.response;

import com.ssafy.ssafytime.db.entity.survey.Survey;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import io.swagger.annotations.ApiParam;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 전체 설문 조회
 */
@Getter
@Setter
@ApiModel("SurveyResponse")
public class AllSurveyRes {

    @ApiModelProperty(
            name = "index"
            , example = "번호"
    )
    @ApiParam(value = "설문 번호", required = true)
    private Long Id;

    @ApiModelProperty(
            name = "title"
            , example = "8기만족도조사"
    )
    @ApiParam(value = "설문 제목", required = true)
    private String title;

    @ApiModelProperty(
            name = "status"
            , example = "예정"
    )
    @ApiParam(value = "설문 상태", required = true)
    private Integer status;

    @ApiModelProperty(
            name = "category"
            , example = "0"
    )
    @ApiParam(value = "카테고리", required = true)
    private Integer category;

    @ApiModelProperty(
            name = "startDate"
            , example = "YYYY-MM-DD HH:MM"
    )
    @ApiParam(value = "설문시작날짜", required = true)
    private LocalDateTime startDate;

    @ApiModelProperty(
            name = "endDate"
            , example = "YYYY-MM-DD HH:MM"
    )
    @ApiParam(value = "설문종료날짜", required = true)
    private LocalDateTime endDate;


    public static List<AllSurveyRes> of(List<Survey> allSurvey) {
        
        List<AllSurveyRes> allSurveyRes = new ArrayList<>();  // 응답으로 보낼 전체설문리스트
        
        for(int i = 0; i < allSurvey.size(); i++) {
            Survey survey = allSurvey.get(i);  // 받아온 리스트 중 i번째 설문
            AllSurveyRes surveyRes = new AllSurveyRes();  // 현재 response 클래스 형식으로 클래스 하나 만듦
            surveyRes.setId(survey.getId());
            surveyRes.setTitle(survey.getTitle());  // 받아온 리스트를 조회해가며 i번째 설문의 제목을 현재 클래스의 제목으로 설정
            surveyRes.setStatus(survey.getStatus());
            surveyRes.setCategory(survey.getCategory());
            surveyRes.setStartDate(survey.getCreatedAt());
            surveyRes.setEndDate(survey.getEndedAt());
            allSurveyRes.add(surveyRes);  // 응답리스트에 추가
        }

        return allSurveyRes;
    }
}