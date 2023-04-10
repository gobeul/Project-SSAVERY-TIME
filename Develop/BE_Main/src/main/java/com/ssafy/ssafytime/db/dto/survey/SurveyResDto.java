package com.ssafy.ssafytime.db.dto.survey;

import com.ssafy.ssafytime.db.entity.survey.Survey;
import io.swagger.annotations.ApiModelProperty;
import io.swagger.annotations.ApiParam;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
public class SurveyResDto {

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
            name = "madeAt"
            , example = "YYYY-MM-DD HH:MM"
    )
    @ApiParam(value = "설문 생성날짜", required = true)
    private LocalDateTime madeAt;

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

    @Builder
    public SurveyResDto(Survey survey) {
        this.Id = survey.getId();
        this.category = survey.getCategory();
        this.endDate = survey.getEndedAt();
        this.title = survey.getTitle();
        this.status = survey.getStatus();
        this.startDate = survey.getCreatedAt();
        this.madeAt = survey.getMadeAt();
    }

}
