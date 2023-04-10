package com.ssafy.ssafytime.db.entity;

import lombok.*;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.time.LocalDateTime;

@Builder
@Entity
@Getter
@Setter
@Table(name = "logout_token")
@NoArgsConstructor
@AllArgsConstructor
public class LogoutToken {

    @Id
    @Column(name = "token")
    private String token;


    @Column(name = "expired_at")
    private LocalDateTime expiredAt;

    public boolean hasSameValue(final String token){
        return this.token.equals(token);
    }

}
