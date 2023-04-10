package com.ssafy.ssafytime.db.dto;

import lombok.Getter;

@Getter
public class TokenRequest {

    private String accessToken;
    private String refreshToken;
}
