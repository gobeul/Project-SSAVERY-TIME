package com.ssafy.ssafytime.db.dto.notice;

import com.ssafy.ssafytime.db.entity.notice.NoticeEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/* 공지사항 생성 DTO (develop_AJH) */
@Getter
@Setter
@NoArgsConstructor
public class NoticeRequestDto {
    private String title;
    private String category;
    private String contentUrl;
    private String createDate;
    private String createTime;

    @Builder NoticeRequestDto(String title, String category, String contentUrl, String createDateTime) {
        this.title = title;
        this.category = category;
        this.contentUrl = contentUrl;
        // createDate & createTime 할당
        String[] dateTime = createDateTime.split("T");
        String date = dateTime[0].replace("-", "");
        String time = dateTime[1].replace(":", "");
        this.createDate = date;
        this.createTime = time;
    }
    public NoticeEntity toEntity() {
        return NoticeEntity.builder().title(title).category(category).contentUrl(contentUrl).createDate(createDate).createTime(createTime).build();
    }
}
