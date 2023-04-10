package com.ssafy.ssafytime.api.service.notice;

import com.ssafy.ssafytime.db.dto.notice.NoticeRequestDto;
import com.ssafy.ssafytime.db.dto.notice.NoticeResponseDto;

import java.util.List;

public interface NoticeService {

    NoticeResponseDto getRecentNotice();

    NoticeResponseDto getNotice(Long id);

    List<NoticeResponseDto> getAllNotice();

    void save(NoticeRequestDto noticeRequestDto);
}
