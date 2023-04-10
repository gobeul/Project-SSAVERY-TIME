package com.ssafy.ssafytime.db.entity.survey;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Setter
public class SurveyQuestion {
    @Id
    @Column(name = "question_idx")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id = null;

    @Column(name = "question_content")
    String questionContent;

    @Column(name = "option_list")
    String optionList;

    @ManyToOne
    @JoinColumn(name = "survey_idx")
    private Survey survey;
}
