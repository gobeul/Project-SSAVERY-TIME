//package com.ssafy.ssafytime.api.firebase;
//
//import com.google.api.client.util.Value;
//import com.google.auth.oauth2.GoogleCredentials;
//import com.google.firebase.FirebaseApp;
//import com.google.firebase.FirebaseOptions;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.core.io.ClassPathResource;
//import org.springframework.stereotype.Component;
//
//import javax.annotation.PostConstruct;
//import java.io.FileInputStream;
//import java.io.FileNotFoundException;
//import java.io.IOException;
//import java.io.InputStream;
//import java.util.Arrays;
//
//@Component
//@Slf4j
//public class FCMInitializer {
//
////    @Value("${firebase/ssafytime-firebase-adminsdk-uq8xh-c0ce82262a.json}")
////    private String credential;
//    @Value("${project.properties.firebase-create-scoped}")
//    String fireBaseCreateScoped;
//
//
//    @PostConstruct
//    public void initialize() throws IOException {
//        ClassPathResource resource = new ClassPathResource("firebase/ssafytime-firebase-adminsdk-uq8xh-c0ce82262a.json");
//        GoogleCredentials googleCredentials = GoogleCredentials.fromStream(new ClassPathResource("/firebase/ssafytime-firebase-adminsdk-uq8xh-c0ce82262a.json").getInputStream())
//                .createScoped((Arrays.asList(fireBaseCreateScoped)));
////        GoogleCredentials googleCredentials = GoogleCredentials
////                .fromStream(new ClassPathResource("firebase/ssafytime-firebase-adminsdk-uq8xh-c0ce82262a.json").getInputStream())
////                .createScoped(Arrays.asList("https://www.googleapis.com/auth/firebase",
////                        "https://www.googleapis.com/auth/cloud-platform",
////                        "https://www.googleapis.com/auth/firebase.readonly"));
//        try (InputStream stream = resource.getInputStream()) {
//            FirebaseOptions options = FirebaseOptions.builder()
//                    .setCredentials(googleCredentials)
//                    .build();
//
//            if (FirebaseApp.getApps().isEmpty()) {
//                FirebaseApp.initializeApp(options);
//                log.info("FirebaseApp initialization complete");
//            }
//        }catch (Exception e){
//            e.printStackTrace();
////            throw new ApiException(ExceptionEnum.INTERNAL_SERVER_ERROR);
//        }
//
//    }
//}

package com.ssafy.ssafytime.api.firebase;

import com.google.api.client.util.Value;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.Arrays;

@Component
@Slf4j
public class FCMInitializer {


    @Value("${project.properties.firebase-create-scoped}")
    String fireBaseCreateScoped;

    @PostConstruct
    public void initialize() throws IOException {
        ClassPathResource resource = new ClassPathResource("firebase/ssafytime-firebase-adminsdk-uq8xh-c0ce82262a.json");

        try {
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(resource.getInputStream())
                            .createScoped((Arrays.asList("https://www.googleapis.com/auth/firebase.messaging"))))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                log.info("FirebaseApp initialization complete");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}