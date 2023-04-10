//package com.ssafy.ssafytime.api.controller;
//
//import com.ssafy.ssafytime.db.dto.readNotice.ReadNoticeResponseDto;
//import com.ssafy.ssafytime.api.service.readNotice.ReadNoticeServiceImpl;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RestController;
//
//import java.util.List;
//@RequiredArgsConstructor
//@RestController
//public class ReadNoticeController {
//
//    private final ReadNoticeServiceImpl readNoticeService;
//
//    @GetMapping("notice/unread/all")
//    public List<ReadNoticeResponseDto> allUnReadNotice(@RequestParam("id") Long id, @RequestParam("is_read") int isRead) throws Exception {
//        List<ReadNoticeResponseDto> readNoticeResponseDtoList = readNoticeService.getAllUnreadNotice(id, isRead);
//        return readNoticeResponseDtoList;
//    }
//
//    @GetMapping("notice/unread")
//    public List<ReadNoticeResponseDto> unReadNotice(@RequestParam("uid") Long uid, @RequestParam("is_read") int isRead) throws Exception {
//        List<ReadNoticeResponseDto> readNoticeResponseDtoList = readNoticeService.getUnreadNotice(uid, isRead);
//        return readNoticeResponseDtoList;
//    }
//}
