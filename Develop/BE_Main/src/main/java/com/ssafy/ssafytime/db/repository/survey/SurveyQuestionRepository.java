package com.ssafy.ssafytime.db.repository.survey;

import com.ssafy.ssafytime.db.entity.survey.SurveyQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository

public interface SurveyQuestionRepository extends JpaRepository<SurveyQuestion, Long> {
    List<SurveyQuestion> findAllBySurvey_IdOrderByIdAsc(Long Id);
    @Override
    Optional<SurveyQuestion> findById(Long Id);
}
