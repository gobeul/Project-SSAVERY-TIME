//package com.ssafy.ssafytime.api.firebase;
//
//import com.google.api.client.util.Value;
//import com.google.auth.oauth2.GoogleCredentials;
//import com.google.common.net.HttpHeaders;
//import com.google.firebase.FirebaseApp;
//import com.google.firebase.FirebaseOptions;
//import com.google.firebase.messaging.*;
//import com.ssafy.ssafytime.api.request.SurveyRegisterPostReq;
//import com.ssafy.ssafytime.api.service.AlarmDefaultService;
//import com.ssafy.ssafytime.db.dto.AlarmDefaultResponseDto;
//import com.ssafy.ssafytime.db.dto.UserDto;
//import com.ssafy.ssafytime.api.service.UserService;
//import com.ssafy.ssafytime.common.model.response.BaseResponseBody;
//import com.ssafy.ssafytime.db.entity.User;
//import com.ssafy.ssafytime.db.repository.AlarmDefaultRepository;
//import com.ssafy.ssafytime.db.repository.UserRepository;
//import io.swagger.annotations.*;
//import lombok.RequiredArgsConstructor;
//import okhttp3.*;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.Authentication;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RestController;
//import springfox.documentation.annotations.ApiIgnore;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.List;
//
//@RestController
//@RequiredArgsConstructor
//public class FcmController {
//
//    private final String API_URL = "https://fcm.googleapis.com/v1/projects/ssafytime/messages:send";
//
//    @Value("${project.properties.firebase-create-scoped}")
//
//    @Autowired
//    FirebaseCloudMessageService firebaseCloudMessageService;
//
//    @Autowired
//    AlarmDefaultService alarmDefaultService;
//
//    @Autowired
//    AlarmDefaultRepository alarmDefaultRepository;
//
//    @Autowired
//    UserService userService;
//
//    @Autowired
//    UserRepository userRepository;
//
//    @PostMapping("/surveys/fcm")
//    @ApiOperation(value = "설문 FCM 알림보내기", notes = "<strong>FCM 알림보내기</strong>")
//    @ApiResponses({
//            @ApiResponse(code = 200, message = "성공"),
//            @ApiResponse(code = 204, message = "No Content"),
//            @ApiResponse(code = 400, message = "Bad Request"),
//            @ApiResponse(code = 401, message = "인증 실패"),
//            @ApiResponse(code = 404, message = "사용자 없음"),
//            @ApiResponse(code = 500, message = "서버 오류")
//    })
//    public ResponseEntity pushSurveyAlarm(@RequestBody @ApiParam(value="FCM 메세지", required = true) MessageDTO messageDTO) throws IOException, FirebaseMessagingException {
//
//        List<String> registrationTokens = new ArrayList<>();  // 알림 보낼 토큰들
//
//        Notification notification = Notification.builder().setTitle(messageDTO.getTitle()).setBody(messageDTO.getBody()).setImage(null).build();  // 없으면 알림 안보내짐
//
//        List<AlarmDefaultResponseDto> alarmList = alarmDefaultService.findAllBySurveyAlarm(true);  // 설문 설정해놓은 알람들 DTO 리스트 가져옴
//
//        List<User> users = new ArrayList<>();  // 관리자가 아니면서 알림설정해놓은(alarm=0) 유저들 가져오는 리스트
//        for(int i = 0; i < alarmList.size(); i++) {  // alarmDto로 받아온 리스트를
//            users.add(alarmList.get(i).getUser());  // 유저로 바꿔서 리스트에 넣음
//        }
//        for(int i = 0; i < users.size(); i++) {  // 유저리스트에서
//            registrationTokens.add(users.get(i).getToken());  // 토큰들 추출
//        }
//
//        MulticastMessage message = MulticastMessage.builder()  // 다수에게 보내기 위한 메세지 생성
//                .setNotification(notification)  // 꼭 넣어주기...
//                .putData("title", "hi")
//                .putData("content", "hi")
//                .addAllTokens(registrationTokens)
//                .build();
//        BatchResponse response = FirebaseMessaging.getInstance().sendMulticast(message);  // 결과 리턴
//
//
//
//        if (response.getFailureCount() > 0) {
//            List<SendResponse> responses = response.getResponses();
//            List<String> failedTokens = new ArrayList<>();
//            for (int i = 0; i < responses.size(); i++) {
//                if (!responses.get(i).isSuccessful()) {
//                    // The order of responses corresponds to the order of the registration tokens.
//                    failedTokens.add(registrationTokens.get(i));
//                }
//            }
//
//            return ResponseEntity.status(400).body("FailedTokens presented");
//        } else
//            return ResponseEntity.ok().body("Success");
//    }
//
//}