package com.ssafy.ssafytime.db.repository;

import com.ssafy.ssafytime.db.entity.Authority;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AuthorityRepository extends JpaRepository<Authority, String> {
}
