package com.ssafy.ssafytime.api.service;

import com.ssafy.ssafytime.db.dto.MeetInfoDto;
import com.ssafy.ssafytime.db.dto.ReserveDto;
import com.ssafy.ssafytime.db.entity.MeetList;
import com.ssafy.ssafytime.db.entity.User;
import com.ssafy.ssafytime.db.repository.MeetListRepository;
import com.ssafy.ssafytime.db.repository.MeetUpdateRepository;
import com.ssafy.ssafytime.db.repository.UserRepository;
import io.openvidu.java.client.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.converter.FormHttpMessageConverter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.InetSocketAddress;
import java.nio.charset.Charset;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service("meetService")
public class MeetServiceImpl implements MeetService{
    @Autowired
    MeetListRepository meetListRepository;
    @Autowired
    MeetUpdateRepository meetUpdateRepository;
    @Autowired
    UserRepository userRepository;

    private OpenVidu openvidu;

    // 날짜와 매니저의 id정보를 가지고 해당 날짜에 신청되어 있는 시간 정보 리스트를 반환
    @Override
    public List<Double> findByRezDateAndManagerId(String date , Long managerId){
        LocalDate day = LocalDate.parse(date, DateTimeFormatter.ISO_DATE);
        ArrayList<Double> timeList = new ArrayList<Double>();
        User manager = userRepository.findById(managerId).get();
        meetListRepository.findByRezDateAndManagerId(day, manager).forEach(
                s-> timeList.add(s.getRezTime())
        );

        return timeList;
    }

    // 교육생 본인의 반번호와 지역코드를 사용하여 해당하는 매니저들의 정보 호출
    @Override
    public ArrayList<HashMap<String, Object>> getManagerInfo(Integer classNum, Integer regionCode){

        List<User> userList = userRepository.findByClassNumAndRegionCode(classNum, regionCode);

        ArrayList<HashMap<String, Object>> manager = new ArrayList<HashMap<String, Object>>();

        userList.stream()
                .forEach(user -> {

                    HashMap<String, Object> info = new HashMap<String, Object>();
                    if(user.getIsAdmin()!=0) {

                        info.put("user_name", user.getUserName());
                        info.put("user_img", user.getUserImg());
                        info.put("is_admin", user.getIsAdmin());
                        info.put("user_idx", user.getUserIdx());
                        manager.add(info);
                    }

                });
        return manager;
    }

    // 예약 정보와 상대의 이름을 호출 ( 교육생 기준 )
    @Override
    public List<MeetInfoDto> findAllByStudentId_UserIdx(Long userId) {
        List<MeetList> member = meetListRepository.findAllByStudentId_UserIdx(userId);

        ArrayList<MeetInfoDto> manager = new ArrayList<MeetInfoDto>();

        // 현재 시간
        String[] dateTime = LocalDateTime.now().toString().split("T");
        int nowDate = Integer.parseInt(dateTime[0].toString().replace("-", ""));
        int nowHour = Integer.parseInt(dateTime[1].split(":")[0]);
        int nowMin = Integer.parseInt(dateTime[1].split(":")[1]);
        Double nowTime = nowHour + (nowMin/60.0);

        member.forEach(m->{
                // 관리자의 이름을 뽑아서 추출
                MeetInfoDto meetInfoDto = new MeetInfoDto();
                meetInfoDto.setName(m.getManagerId().getUserName());
                meetInfoDto.setReject(m.getReject());
                meetInfoDto.setTitle(m.getTitle());
                meetInfoDto.setSessionId(m.getSessionId());

                meetInfoDto.setRezTime(m.getRezTime());
                meetInfoDto.setRezDate(m.getRezDate());

                // 시간이 지났으면 state 4(종료)로 변경
            if((m.getState() != 3L) && (nowDate > Integer.parseInt(m.getRezDate().toString().replace("-", ""))) || (nowDate == Integer.parseInt(m.getRezDate().toString().replace("-", "")) && (nowTime > (m.getRezTime() + 1)))){
                    m.setState(4L); // 4(종료) (entity)
                    String sId = m.getSessionId();
                    if(sId != null){
                        // 세션 종료

//                        // path param
//                        Map< String, String > params = new HashMap < String, String > ();
//                        params.put("sessionId", "ses_KQPkjRflJp");
//                        RestTemplate restTemplate = new RestTemplate();
//
//                        // 1. HttpHeaders 객체 생성
//                        HttpHeaders headers = new HttpHeaders();
//
//                        // 2. 헤더 설정 : ContentType
//                        headers.setContentType(new MediaType("application","json", Charset.forName("UTF-8")));
//                        headers.setBasicAuth("T1BFTlZJRFVBUFA6c3NhZnl0aW1l");
//
//                        // REST API 호출
//                        restTemplate.delete("https://i8a602.p.ssafy.io/openvidu/api/sessions/{sessionId}", params, headers, String.class);
//
//
////                        String result = restTemplate.postForObject("http://localhost:8082/restTest/", map, String.class);
////                        System.out.println("------------------ TEST 결과 ------------------");
////                        System.out.println(result);


//                        RestTemplate restTemplate = new RestTemplate();
//                        String url = "https://i8a602.p.ssafy.io/openvidu/api/sessions/" + "ses_AmWQkrYKj1";
//
//                        HttpHeaders httpHeaders = new HttpHeaders();
//                        httpHeaders.setContentType(MediaType.APPLICATION_JSON);
//                        httpHeaders.setBasicAuth("T1BFTlZJRFVBUFA6c3NhZnl0aW1l");
//
//                        restTemplate.delete(url, httpHeaders, String.class);

                        m.setSessionId(null); // 세션정보 삭제
                    }



                    meetUpdateRepository.save(m);// db에 적용


                }
                meetInfoDto.setState(m.getState());
                meetInfoDto.setCategory(m.getCategory());
                meetInfoDto.setRezIdx(m.getRezIdx());
                meetInfoDto.setSubTime(m.getSubTime());
                meetInfoDto.setSessionId(m.getSessionId());

                manager.add(meetInfoDto);
            }
        );

        return manager;
    }
    // 예약 정보와 상대의 이름을 호출 ( 매니저 기준 )
    @Override
    public List<MeetInfoDto> findAllByManagerId_UserIdx(Long userId) {
        List<MeetList> member = meetListRepository.findAllByManagerId_UserIdx(userId);

        ArrayList<MeetInfoDto> manager = new ArrayList<MeetInfoDto>();

        // 현재 시간
        String[] dateTime = LocalDateTime.now().toString().split("T");
        int nowDate = Integer.parseInt(dateTime[0].toString().replace("-", ""));
        int nowHour = Integer.parseInt(dateTime[1].split(":")[0]);
        int nowMin = Integer.parseInt(dateTime[1].split(":")[1]);
        Double nowTime = nowHour + (nowMin/60.0);
        System.out.println("현재시간 "+ nowTime);
        System.out.println("날짜 "+ nowDate);
        member.forEach(m->{
                    // 교육생의 이름을 뽑아서 추출
                    MeetInfoDto meetInfoDto = new MeetInfoDto();
                    meetInfoDto.setName(m.getStudentId().getUserName());
                    meetInfoDto.setSessionId(m.getSessionId());
                    meetInfoDto.setReject(m.getReject());
                    meetInfoDto.setTitle(m.getTitle());
                    meetInfoDto.setRezTime(m.getRezTime());
                    meetInfoDto.setRezDate(m.getRezDate());
                    // 시간이 지났으면 state 4(종료)로 변경 (3(거절)인 경우는 처리안함)
                    if((m.getState() != 3L) && (nowDate > Integer.parseInt(m.getRezDate().toString().replace("-", ""))) || (nowDate == Integer.parseInt(m.getRezDate().toString().replace("-", "")) && (nowTime > (m.getRezTime() + 1))))
                    {
                        System.out.println("cnt");
                        m.setState(4L); // 4(종료) (entity)
//                        m.setSessionId(null);
                        meetUpdateRepository.save(m);// db에 적용
                    }
                    meetInfoDto.setState(m.getState());
                    meetInfoDto.setCategory(m.getCategory());
                    meetInfoDto.setRezIdx(m.getRezIdx());
                    meetInfoDto.setSubTime(m.getSubTime());
                    meetInfoDto.setSessionId(m.getSessionId());

                    manager.add(meetInfoDto);
                }
        );


        return manager;
    }

    // 예약된 상담정보 호출
    @Override
    public MeetList findByRezIdx(Long rezIdx){
        return meetListRepository.findByRezIdx(rezIdx);
    }

    // 예약 정보 수정 ( 거절 사유에 사용 )
    @Override
    public void update(MeetList meetList){ meetUpdateRepository.save(meetList);}
    
    // 예약 입력
    @Override
    public void save(ReserveDto reserveDto) {

        User std = userRepository.findById(reserveDto.getStudentId()).get();
        User manager = userRepository.findById(reserveDto.getManagerId()).get();

        String[] timeSplit = reserveDto.getRezTime().split(":");
        Double rezTime = Double.parseDouble(timeSplit[0]) + ((Double.parseDouble(timeSplit[1]) / 6) * 0.1);

        meetUpdateRepository.save(reserveDto.toEntity(std, manager, rezTime));
    }

}
