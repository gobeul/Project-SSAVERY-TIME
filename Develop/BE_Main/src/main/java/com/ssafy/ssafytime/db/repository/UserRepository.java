package com.ssafy.ssafytime.db.repository;

//import com.ssafy.ssafytime.db.entity.Attendance;
import com.ssafy.ssafytime.db.entity.User;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long>{
    @EntityGraph(attributePaths = {"authorities"})
    Optional<User> findOneWithAuthoritiesByUserEmail(String userEmail);

    List<User> findByClassNumAndRegionCode(Integer classNum, Integer regionCode);


    Optional<User> findByUserEmailAndUserName(String userEmail, String userName);







//    List<User> findByIsAdminAndAlarm(int isAdmin, int Alaram);
}
