package com.ssafy.ssafytime.api.firebase;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MessageDTO {
    private String title;
    private String body;

    @Builder
    MessageDTO(String title, String body) {
        this.title = title;
        this.body = body;
    }


}
