package com.ssafy.ssafytime.db.entity.survey;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SurveyConductKey implements Serializable {
    private Long userIdx;
    private Long surveyIdx;
}