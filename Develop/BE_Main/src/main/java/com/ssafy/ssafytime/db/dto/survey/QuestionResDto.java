//package com.ssafy.ssafytime.db.dto.survey;
//
//import com.ssafy.ssafytime.db.entity.survey.SurveyOption;
//import com.ssafy.ssafytime.db.entity.survey.SurveyQuestion;
//import io.swagger.annotations.ApiModelProperty;
//import io.swagger.annotations.ApiParam;
//import lombok.Builder;
//import lombok.Getter;
//import lombok.NoArgsConstructor;
//import lombok.Setter;
//
//import java.util.List;
//
//@Getter
//@Setter
//@NoArgsConstructor
//public class QuestionResDto {
//    @ApiModelProperty(
//            name = "questionContent"
//            , example = "질문내용"
//    )
//    @ApiParam(value = "질문 내용", required = true)
//    private String questionContent;
//
//    @ApiModelProperty(
//            name = "optionList"
//            , example = "{}"
//    )
//    @ApiParam(value = "선지 리스트", required = true)
//    private List<SurveyOption> optionList;
//
//    @Builder
//    public QuestionResDto(SurveyQuestion surveyQuestion) {
//        this.questionContent = surveyQuestion.getQuestionContent();
//        this.optionList = surveyQuestion.getOptionList();
//    }
//}
