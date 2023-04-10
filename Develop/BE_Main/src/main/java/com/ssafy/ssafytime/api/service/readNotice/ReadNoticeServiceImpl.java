//package com.ssafy.ssafytime.api.service.readNotice;
//
//import com.ssafy.ssafytime.db.dto.readNotice.ReadNoticeResponseDto;
//import com.ssafy.ssafytime.db.repository.ReadNoticeRepository;
//import lombok.AllArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Service;
//
//import java.util.ArrayList;
//import java.util.List;
//
//@Service
//@Slf4j
//@AllArgsConstructor
//public class ReadNoticeServiceImpl implements ReadNoticeService{
//
//    final ReadNoticeRepository readNoticeRepository;
//
//    @Override
//    public List<ReadNoticeResponseDto> getAllUnreadNotice(Long id, int isRead){
//        List<ReadNoticeResponseDto> readNoticeResponseDtoList = new ArrayList<>();
//        readNoticeRepository.findByNoticeEntity_IdAndIsRead(id, isRead).forEach((unreadNoticeEntity) -> {
//            readNoticeResponseDtoList.add(new ReadNoticeResponseDto(unreadNoticeEntity));
//        });
//        return readNoticeResponseDtoList;
//    }
//
//    @Override
//    public List<ReadNoticeResponseDto> getUnreadNotice(Long uid, int isRead) {
//        List<ReadNoticeResponseDto> readNoticeResponseDtoList = new ArrayList<>();
//        readNoticeRepository.findByUserEntity_UserIdxAndIsRead(uid, isRead).forEach((unreadNoticeEntity -> {
//            readNoticeResponseDtoList.add(new ReadNoticeResponseDto(unreadNoticeEntity));
//        }));
//        return readNoticeResponseDtoList;
//    }
//}
