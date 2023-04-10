package com.ssafy.ssafytime.db.entity.survey;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Setter
public class SurveyOption {

    @Id
    @Column(name = "option_idx")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id = null;

    @Column(name = "option_content")
    String optionContent;

    @Column(name = "option_intensity")
    Integer optionIntensity;
}
