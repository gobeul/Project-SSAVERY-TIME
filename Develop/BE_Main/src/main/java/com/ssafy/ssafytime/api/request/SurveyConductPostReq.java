package com.ssafy.ssafytime.api.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
/**
 * 설문 답변 API ([POST] /api/v1/surveys/survey/answers/Id) 요청에 필요한 리퀘스트 바디 정의.
 */
@Getter
@Setter
@ApiModel("SurveyConductPostReq")
public class SurveyConductPostReq {
    @ApiModelProperty(name = "question_idx", example = "질문 인덱스")
    Long questionId;
    @ApiModelProperty(name = "survey_response", example = "설문 답변")
    String response;
}
