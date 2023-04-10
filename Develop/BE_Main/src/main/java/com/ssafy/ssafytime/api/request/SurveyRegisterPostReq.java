package com.ssafy.ssafytime.api.request;


import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import java.time.LocalDateTime;

/**
 * 설문 등록 API ([POST] /api/v1/surveys/survey/{ID}) 요청에 필요한 리퀘스트 바디 정의.
 */
@Getter
@Setter
@ApiModel("SurveyRegisterPostReq")
public class SurveyRegisterPostReq {
    @ApiModelProperty(name = "survey_title", example = "설문 제목")
    String title;
    @ApiModelProperty(name = "survey_status", example = "설문 상태")
    Integer status;
    @ApiModelProperty(name = "survey_createdAt", example = "설문 시작일시")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "Asia/Seoul")
    LocalDateTime createdAt;
    @ApiModelProperty(name = "survey_endedAt", example = "설문 종료일시")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "Asia/Seoul")
    LocalDateTime endedAt;
    @ApiModelProperty(name = "survey_category", example = "설문 카테고리")
    Integer category;

}