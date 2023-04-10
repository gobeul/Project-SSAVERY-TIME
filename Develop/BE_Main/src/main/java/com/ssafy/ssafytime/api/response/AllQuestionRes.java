package com.ssafy.ssafytime.api.response;

import com.ssafy.ssafytime.db.entity.survey.SurveyOption;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import io.swagger.annotations.ApiParam;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 전체 설문 조회
 */
@Getter
@Setter
@ApiModel("SurveyResponse")
public class AllQuestionRes {

    @ApiModelProperty(
            name = "questionId"
            , example = "질문ID"
    )
    @ApiParam(value = "질문 번호", required = true)
    private Long Id;

    @ApiModelProperty(
            name = "questionContent"
            , example = "질문내용"
    )
    @ApiParam(value = "질문 내용", required = true)
    private String questionContent;

    @ApiModelProperty(
            name = "optionList"
            , example = "{}"
    )
    @ApiParam(value = "선지 리스트", required = true)
    private List<SurveyOption> optionList;


}