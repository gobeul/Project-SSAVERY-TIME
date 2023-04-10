package com.ssafy.ssafytime.exception;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class ExceptionResponse {
    private Boolean isSuccess;
    private String message;
    private HttpStatus status;
    private Object data;
}