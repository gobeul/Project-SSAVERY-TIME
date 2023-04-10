package com.ssafy.ssafytime.db.entity;

import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;

@Builder
@Entity
@Getter
@Setter
@Table(name = "refresh_token")
@NoArgsConstructor
@AllArgsConstructor
public class RefreshToken {

    @Id
    @Column(name = "user_email")
    private String userEmail;

    @Column(name = "token")
    private String token;


    @Column(name = "expired_at")
    private LocalDateTime expiredAt;


    public boolean hasSameValue(final String token){
        return this.token.equals(token);
    }




}
