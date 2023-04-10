package com.ssafy.ssafytime.db.repository.survey;

import com.ssafy.ssafytime.db.entity.survey.Survey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SurveyRepository extends JpaRepository<Survey, Long> {

    @Override
    List<Survey> findAll();

    @Override
    Optional<Survey> findById(Long Id);

    @Override
    Survey save(Survey survey);

    List<Survey> findAllByStatus(Integer status);
}
