package com.ssafy.ssafytime.api.controller;

import com.google.api.client.util.Value;
import com.google.firebase.messaging.*;
import com.ssafy.ssafytime.api.firebase.FirebaseCloudMessageService;
import com.ssafy.ssafytime.api.firebase.MessageDTO;
import com.ssafy.ssafytime.api.service.survey.*;
import com.ssafy.ssafytime.db.dto.UserDto;
import com.ssafy.ssafytime.api.request.SurveyConductPostReq;
import com.ssafy.ssafytime.api.request.SurveyRegisterPostReq;
import com.ssafy.ssafytime.api.response.AllQuestionRes;
import com.ssafy.ssafytime.api.response.AllSurveyRes;
import com.ssafy.ssafytime.api.service.*;
import com.ssafy.ssafytime.common.model.response.BaseResponseBody;
import com.ssafy.ssafytime.db.dto.survey.SurveyResDto;
import com.ssafy.ssafytime.db.entity.*;
import com.ssafy.ssafytime.db.entity.survey.*;
import com.ssafy.ssafytime.db.repository.*;
import com.ssafy.ssafytime.db.repository.survey.*;
import com.ssafy.ssafytime.exception.ResponseHandler;
import com.ssafy.ssafytime.jdbc_connection.DbConnector;
import io.swagger.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Api(value = "설문 API", tags = {"Survey"})
@RestController
@RequestMapping("/surveys")
public class SurveyController {

    private final String API_URL = "https://fcm.googleapis.com/v1/projects/ssafytime/messages:send";

    @Value("${project.properties.firebase-create-scoped}")

    @Autowired
    FirebaseCloudMessageService firebaseCloudMessageService;

    @Autowired
    AlarmDefaultService alarmDefaultService;

    @Autowired
    AlarmDefaultRepository alarmDefaultRepository;

    @Qualifier("surveyService")
    @Autowired
    SurveyService surveyService;
    @Qualifier("surveyQuestionService")
    @Autowired
    SurveyQuestionService surveyQuestionService;
    @Autowired
    SurveyOptionService surveyOptionService;
    @Autowired
    UserService userService;

    @Autowired
    SurveyConductService surveyConductService;

    @Autowired
    SurveyResponseService surveyResponseService;

    @Autowired
    SurveyResponseRepository surveyResponseRepository;
    @Autowired
    SurveyConductRepository surveyConductRepository;

    @Autowired
    UserRepository userRepository;
    @Autowired
    SurveyRepository surveyRepository;
    @Autowired
    SurveyQuestionRepository surveyQuestionRepository;
    @Autowired
    SurveyOptionRepository surveyOptionRepository;

    public static int cnt = 0;  // 설문 등록시 상태변환 SQL스케줄러의 제목으로 사용할 count변수 선언!

/*
    =======================================================================
    설문 전체 조회 API
    by jaehee

    Parameter : NONE
    Response Type : List<SurveyResDto>
    Method : GET
    =======================================================================
 */
    @GetMapping("/survey")
    @ApiOperation(value = "설문 전체 조회", notes = "<strong>설문 전체 조회</strong>")
    @ApiResponses({
            @ApiResponse(code = 200, message = "성공"),
            @ApiResponse(code = 204, message = "No Content"),
            @ApiResponse(code = 401, message = "인증 실패"),
            @ApiResponse(code = 404, message = "사용자 없음"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<List<SurveyResDto>> getSurvey() throws SQLException {

        List<SurveyResDto> surveyList = surveyService.findAll();  // 전체 설문 조회
        if(surveyList.size() == 0) {
            return ResponseEntity.status(204).body(null);
        }
        else {
            return ResponseEntity.ok().body(surveyList);
        }
    }

/*
    =======================================================================
    설문의 전체 질문 조회 API
    by jaehee

    Parameter : pathvariable(SurveyId)
    Response Type : List<QuestionResDto>
    Method : GET
    =======================================================================
*/

    @GetMapping("/survey/questions/{Id}")
    @ApiOperation(value = "해당설문의 질문 전체 조회", notes = "<strong>해당 설문의 질문 전체 조회</strong>")
    @ApiResponses({
            @ApiResponse(code = 200, message = "성공"),
            @ApiResponse(code = 204, message = "No Content"),
            @ApiResponse(code = 401, message = "인증 실패"),
            @ApiResponse(code = 404, message = "사용자 없음"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<List<AllQuestionRes>> getQuestion(@PathVariable("Id") int Id) {


        List<SurveyQuestion> questionList = (List<SurveyQuestion>) surveyQuestionService.findAllBySurvey_IdOrderByIdAsc(Id);  // 해당 설문의 전체 질문 조회

        if(questionList.size() == 0) {
            return ResponseEntity.status(204).body(null);
        }
        else {
            List<AllQuestionRes> allQuestionRes = surveyQuestionService.makeQuestionRes(questionList);  // AllSurveyRes 리스트 타입으로 바꿈
            return ResponseEntity.ok().body(allQuestionRes);
        }
    }

    @GetMapping("/survey/options/{Id}")
    @ApiOperation(value = "설문 선지 내용 조회", notes = "<strong>설문 선지 내용 조회</strong>")
    @ApiResponses({
            @ApiResponse(code = 200, message = "성공"),
            @ApiResponse(code = 204, message = "No Content"),
            @ApiResponse(code = 401, message = "인증 실패"),
            @ApiResponse(code = 404, message = "사용자 없음"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<Optional<SurveyOption>> getOption(@PathVariable("Id") Long Id) {
        Optional<SurveyOption> surveyOption = surveyOptionService.findById(Id);
        if(surveyOption.isPresent()) {
            return ResponseEntity.ok().body(surveyOption);
        } else {
            return ResponseEntity.status(204).body(null);
        }
    }

    @PostMapping("/survey")
    @ApiOperation(value = "설문 등록", notes = "<strong>설문 등록</strong>")
    @ApiResponses({
            @ApiResponse(code = 200, message = "성공"),
            @ApiResponse(code = 204, message = "No Content"),
            @ApiResponse(code = 401, message = "Unauthorized"),
            @ApiResponse(code = 404, message = "사용자 없음"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity registerSurvey(@RequestBody @ApiParam(value="설문 등록 정보", required = true) SurveyRegisterPostReq surveyRegisterPostReq) throws IOException, FirebaseMessagingException {  // 설문 등록 API
        Survey survey = new Survey();

        String title = surveyRegisterPostReq.getTitle();
        Integer status = surveyRegisterPostReq.getStatus();
        LocalDateTime createdAt = surveyRegisterPostReq.getCreatedAt();
        LocalDateTime endedAt = surveyRegisterPostReq.getEndedAt();
        Integer category = surveyRegisterPostReq.getCategory();

        survey.setCategory(category);
        survey.setTitle(title);
        survey.setStatus(status);
        survey.setEndedAt(endedAt);
        survey.setCreatedAt(createdAt);
        survey.setMadeAt(LocalDateTime.now());  // 생성날짜시간은 현재로!

        surveyService.save(survey);  // create

        try {
            DbConnector.main(createdAt, endedAt);  // 상태변경 스케줄러 호출
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        // 알림보내기
        MessageDTO messageDTO = MessageDTO.builder().title("새로운 설문이 있습니다").body(title).build();  // 알림에 넣을 인자들
        List<String> registrationTokens = alarmDefaultService.getUserTokens(1, messageDTO);  // 1 : 설문, 2 : 공지 , 3: 상담 으로 설정하여 알림보낼 유저들 토큰 얻는 함수

        if (registrationTokens.isEmpty()) {  // 토큰이 있는 사람중에 알림 보낼 사람이 하나도 없을 때
            return ResponseHandler.generateResponse(false, "there is no people to send FCM", HttpStatus.NOT_FOUND, null);
        } else {
            if (registrationTokens.contains(null)) { // 알림 보낼 사람은 있는데 FCMtoken이 null일때
                return ResponseHandler.generateResponse(false, "there is null FCMtoken", HttpStatus.NOT_FOUND, null);
            }
            Notification notification = Notification.builder().setTitle(messageDTO.getTitle()).setBody(messageDTO.getBody()).setImage(null).build();  // 없으면 알림 안보내짐
            Integer FailedAlarmCnt = alarmDefaultService.sendMultiAlarms(notification, registrationTokens);
            return ResponseHandler.generateResponse(true, "FailedAlarmCnt : " + FailedAlarmCnt, HttpStatus.OK, null);
        }
    }


    @PostMapping("/survey/conduct/{surveyId}")
    @ApiOperation(value = "설문 완료 ", notes = "<strong>설문 완료</strong>")
    @ApiResponses({
            @ApiResponse(code = 200, message = "성공"),
            @ApiResponse(code = 204, message = "No Content"),
            @ApiResponse(code = 400, message = "Bad Request"),
            @ApiResponse(code = 401, message = "Unauthorized"),
            @ApiResponse(code = 404, message = "사용자 없음"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<? extends BaseResponseBody> surveyConduct(@PathVariable("surveyId") Long Id, @ApiIgnore Authentication authentication) {
        if(authentication == null) {
            return ResponseEntity.status(401).body(BaseResponseBody.of(401, "unauthorized"));
        }
        SurveyConduct surveyConduct = new SurveyConduct();  // DB에 저장할 엔티티!
        UserDto userDto = userService.getMyUserWithAuthorities();  // 토큰 이용해서 유저정보 가져옴
        Optional<User> user = userService.findById(userDto.getId());  // 외래키는 객체로 저장해야해서 유저객체 찾아옴
        Optional<Survey> survey = surveyService.findById(Id);
        if(!user.isPresent() || !survey.isPresent()) // 둘 중 하나라도 null이면
            return ResponseEntity.status(204).body(BaseResponseBody.of(400, "Bad Request"));
        else {  // 요청이 제대로면
//            if(surveyConduct.getUserIdxAndSurveyIdx(user.get().))  // 이미 저장된 설문완료는 따로 응답

            surveyConduct.setUserIdx(user.get());  // optional객체 말고 user로 바꾸기 위해 .get()해주어야함
            surveyConduct.setSurveyIdx(survey.get());  // optional객체 말고 일반객체로 바꾸기 위해 .get()해주어야함
            surveyConductService.save(surveyConduct);  // 객체 DB에 저장 !
            return ResponseEntity.status(200).body(BaseResponseBody.of(200, "Success"));
        }
    }

    @PostMapping("/survey/answers/{surveyId}")
    @ApiOperation(value = "설문 답변 제출", notes = "<strong>설문 답변 제출</strong>")
    @ApiResponses({
            @ApiResponse(code = 200, message = "성공"),
            @ApiResponse(code = 204, message = "No Content"),
            @ApiResponse(code = 401, message = "Unauthorized"),
            @ApiResponse(code = 404, message = "사용자 없음"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<? extends BaseResponseBody> surveyConduct  // userIdx 포함 3개의 복합키가 PK이므로 한 유저가 같은질문에 답변 저장을 여러번 하는 것이 불가함
            (@PathVariable("surveyId") Long Id, @RequestBody @ApiParam(value="설문 답변 제출", required = true) List<SurveyConductPostReq> surveyConductList, @ApiIgnore Authentication authentication) {
        // 객체 하나라도 없으면 PK 성립 안되기 때문에 에러 보내줘야함 !!
            if(authentication == null) {  // 토큰없다면!!!!
                return ResponseEntity.status(401).body(BaseResponseBody.of(401, "unauthorized"));
            }
            SecurityContextHolder.getContext().setAuthentication(authentication);
            UserDto userDto = userService.getMyUserWithAuthorities();  // 토큰으로 유저인덱스 가져옴
            for(int i = 0; i < surveyConductList.size(); i++) {  // 질문과 답변이 쌍으로 List 형식으로 요청와서
            SurveyResponse surveyResponse = new SurveyResponse();  // 리턴타입!

            Optional<User> user = userService.findById(userDto.getId());
            Optional<Survey> survey = surveyService.findById(Id);  // surveyIdx 외래키 대신 survey 객체를 넣어줘야해서
            Optional<SurveyQuestion> question = surveyQuestionService.findById(surveyConductList.get(i).getQuestionId());  // questionIdx 외래키 대신 question 객체를 넣어줘야해서

            if(!user.isPresent() || !survey.isPresent() || !question.isPresent())  // null인 요청값이 하나라도 있으면
                return ResponseEntity.status(204).body(BaseResponseBody.of(400, "Bad Request"));  // 에러보냄
            else {
                surveyResponse.setUserIdx(user.get());
                surveyResponse.setSurveyIdx(survey.get());  // 리턴타입 객체에 외래키 객체 삽입
                surveyResponse.setQuestionIdx(question.get());  // 리턴타입 객체에 외래키 객체 삽입
                surveyResponse.setResponse(surveyConductList.get(i).getResponse());  // 리턴타입 객체에 Request로 받은 응답 String 저장
                surveyResponseService.save(surveyResponse);  // DB에 저장
            }
        }
        return ResponseEntity.status(200).body(BaseResponseBody.of(200, "Success"));  // 굳!
    }

    @GetMapping("/main/survey")
    @ApiOperation(value = "진행중이지만 유저가 완료하지 않은 설문 조회", notes = "<strong>메인페이지에 띄울 설문 조회</strong>")
    @ApiResponses({
            @ApiResponse(code = 200, message = "성공"),
            @ApiResponse(code = 204, message = "No Content"),
            @ApiResponse(code = 401, message = "Unauthorized"),
            @ApiResponse(code = 404, message = "사용자 없음"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<? extends Object> getNotConductedSurvey(@ApiIgnore Authentication authentication) {

        List<Survey> returnSurvey = new ArrayList<>();  // 리턴할 리스트
        
        // 0. 토큰으로 사용자 idx 받아오기
        if(authentication == null) {  //  토큰 없을 경우 처리
            return ResponseEntity.status(400).body(BaseResponseBody.of(401, "unauthorized"));
        }
        SecurityContextHolder.getContext().setAuthentication(authentication);
        UserDto userDto = userService.getMyUserWithAuthorities();  // 토큰으로 유저인덱스 가져옴
        Optional<User> user = userRepository.findById(userDto.getId());  // 유저인덱스로 유저엔티티 가져옴
        if(!user.isPresent()) {  // 해당 토큰의 유저가 없을경우
            return ResponseEntity.status(204).body(BaseResponseBody.of(204,"해당사용자없음"));
        }
        
        
        // 1. 진행중인 설문들 리스트 받아오기
        List<Survey> allsurvey = surveyService.findAllByStatus(1);  // 진행중인 설문들 다 가져옴
        for(int i = 0; i < allsurvey.size(); i++) {
            Survey survey = allsurvey.get(i);  // 설문리스트에서 하나 받아옴
            
            // 2. 받아온 설문이랑 유저 인덱스로 찾아서 surveyConduct 테이블에 존재하지않으면 완료하지 않은 설문이므로 리턴 리스트에 넣어줌
            Optional<Survey> conductedSurvey = surveyConductService.findByUserIdxAndSurveyIdx(user.get(), survey);
            if(!conductedSurvey.isPresent()) {
                returnSurvey.add(survey);
            }
        }

        return ResponseEntity.status(200).body(returnSurvey);

    }

    @GetMapping("/survey/conduct")
    @ApiOperation(value = "유저별 완료한 설문들 조회", notes = "<strong>유저별 완료한 설문들 조회</strong>")
    @ApiResponses({
            @ApiResponse(code = 200, message = "성공"),
            @ApiResponse(code = 204, message = "No Content"),
            @ApiResponse(code = 401, message = "인증 실패"),
            @ApiResponse(code = 404, message = "사용자 없음"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> getConductedSurvey(@ApiIgnore Authentication authentication) throws SQLException {

        UserDto userDto = userService.getMyUserWithAuthorities();  // 토큰으로 유저인덱스 가져옴
        Optional<User> user = userRepository.findById(userDto.getId());  // 유저인덱스로 유저엔티티 가져옴
        if(user.isPresent()) {
            List<SurveyResDto> surveyList = surveyConductService.findAllByUserIdx(user.get());  // 전체 설문 조회
            if (surveyList.size() == 0) {
                return ResponseEntity.status(204).body(null);
            } else {
                return ResponseEntity.ok().body(surveyList);
            }
        } else {
            return ResponseEntity.status(401).body("No user");
        }
    }

}