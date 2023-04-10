package com.ssafy.ssafytime.jdbc_connection;

import org.springframework.security.core.parameters.P;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Random;

import static com.ssafy.ssafytime.api.controller.SurveyController.cnt;

/* JDBC를 통한 DB와 연결
==============================|| variable ||================================
conn     : DB 인스턴스
USERNAME : 사용자
PASSWORD : 비밀번호
URL      : DB 연결 URL
 */
public class DbConnector {
    private Connection conn;
    private static final String USERNAME = "root";
    private static final String PASSWORD = "ssafy";
    private static final String URL = "jdbc:mysql://i8a602.p.ssafy.io:3306/ssafy_web_db?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul&zeroDateTimeBehavior=convertToNull&rewriteBatchedStatements=true";

    // 생성자 : DB 연결
    public DbConnector() {
        try {
            System.out.println("create");
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("connect");
        } catch (Exception e) {
            System.out.println("connect fail");
            System.out.println(e);
        }
    }

    public void updateStatus(LocalDateTime started_at, LocalDateTime ended_at) throws SQLException {
        Statement stmt = null;
        stmt = conn.createStatement();

        conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        String startedAt = started_at.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        String endedAt = ended_at.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        try {
            stmt.executeUpdate("CREATE EVENT surveyStatusChange" + ++cnt + " \n" +
                    "on schedule \n" +
                    "at " + "'" + startedAt + "'" +
                    "\n do \n" +
                    "\tupdate survey \n" +
                    "    set status = 1" +
                    "\n where status = 0" +
                    ";");
            stmt.executeUpdate("CREATE EVENT surveyStatusChange" + ++cnt + " \n" +
                    "on schedule \n" +
                    "at " + "'" + endedAt + "'" +
                    "\n do \n" +
                    "\tupdate survey \n" +
                    "    set status = 2" +
                    "\n where status = 1" +
                    ";");
            stmt.close();
            conn.close();
        } catch (Exception e) {
            System.out.println("fail");
            System.out.println(e);
        }
    }

    public void insertAlarmDefault() throws SQLException {  // 알림설정 데이터 넣기
        String sql = "insert into alarm_default(user_idx, consulting_alarm, notice_alarm, survey_alarm) values(?, true, true, true)";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            for(int i = 101; i < 190; i++) {
                pstmt.setInt(1, i);
                pstmt.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void insertSurveyConduct() throws SQLException {  // 설문 완료 데이터 넣기
        String sql = "insert into survey_conduct(user_idx, survey_idx) values(?, ?)";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);

            for(int i = 1; i <= 10; i++) {
                pstmt.setInt(1, i);
                for(int j = 1; j <= 10; j++) {
                    pstmt.setInt(2, j);
                    pstmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void insertSurveyQuestion() throws SQLException {
        String sql = "insert into survey_question(option_list, question_content, survey_idx) values(?, ?, ?)";
        PreparedStatement pstmt = null;
        String[] options = {"{1,2}", "{4,5,6,7,8}"};
        String[] strs = {"현 팀원들에 대해", "현 프로젝트에 대해", "현 주제에 대해", "오전 라이브에 대해"};
        String[] questions = {" 만족하십니까?", " 얼마나 만족하십니까?"};
        Random random = new Random();
        try {
            pstmt = conn.prepareStatement(sql);

            for(int i = 1; i <= 15; i++) {  // 설문마다
                for (int j = 1; j <= 3; j++) {  // 3개 질문 생성
                    if(j == 3) {  // 주관식
                        pstmt.setString(1, "{3}");
                        pstmt.setString(2, "이유는 무엇입니까?");
                        pstmt.setInt(3, i);
                        pstmt.executeUpdate();
                        continue;
                    }
                    pstmt.setString(1, options[random.nextInt(2)]);
                    pstmt.setString(2, strs[random.nextInt(4)] + questions[random.nextInt(2)]);
                    pstmt.setInt(3, i);
                    pstmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void insertSurveys() throws SQLException {  // 설문조사 데이터 넣기
//        String sql = "insert into survey(created_at, category, ended_at, status, survey_title, made_at) values(?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = null;
        String sql = "update survey set made_at = ? where survey_idx = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            LocalDateTime startDateTime = LocalDateTime.of(2023, 2, 4, 14, 00);
//            LocalDateTime endDateTime = LocalDateTime.of(2023, 2, 23, 18, 00);
//            String[] title = {"만족도", "행복도", "수요", "프로젝트"};
            Random random = new Random();
            for (int i = 1; i < 40; i++) {
//                LocalDateTime x = startDateTime.minusDays(random.nextInt(5)).plusHours(random.nextInt(6));
//                pstmt.setString(1, String.valueOf(x));
//                pstmt.setInt(2, random.nextInt(3));
//                LocalDateTime y = endDateTime.plusDays(random.nextInt(5)).plusDays(random.nextInt(6));
//                pstmt.setString(3, String.valueOf(y));
//                if (LocalDateTime.now().isBefore(x)) {  // 예정중인 설문조사면
//                    pstmt.setInt(4, 0);
//                } else if (LocalDateTime.now().isAfter(x) && LocalDateTime.now().isBefore(y)) {  // 진행중인 설문
//                    pstmt.setInt(4, 1);
//                } else {  // 끝난 설문
//                    pstmt.setInt(4, 2);
//                }
//                pstmt.setString(5, title[random.nextInt(4)] + "설문");
                LocalDateTime x = startDateTime.plusDays(random.nextInt(5)).plusHours(random.nextInt(5));
                pstmt.setString(1, String.valueOf(x));
                pstmt.setInt(2, i);
                pstmt.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /* 공지사항 Fake Data 생성(develop_AJH)
    ================================|| parameter ||================================
     */
    public void insertNotice() throws SQLException {
        String sql = "insert into notice(title, category, content_url, create_date, create_time) values(?,?,?,?,?)";
        PreparedStatement pstmt = null;
//        Faker faker = new Faker();
        try {
            System.out.println("start");
            Random random = new Random();
            pstmt = conn.prepareStatement(sql);
            String[] categoryList = {"운영", "기타", "학습"};
            String[] imageUrlList = {"https://edu.ssafy.com/data/upload_files/namo/images/000049/20230105084050171_3XDOBL5E.png", "https://edu.ssafy.com/data/upload_files/namo/images/000049/20230112120218169_3U0ALM0U.png", "https://edu.ssafy.com/data/upload_files/namo/images/000049/20230118193407840_JZFV852T.png", "https://edu.ssafy.com/data/upload_files/namo/images/000050/20230127101047618_A4N610TL.png", "https://edu.ssafy.com/data/upload_files/namo/images/000050/20230202114009880_IB8SOFKP.png"};
            LocalDateTime localDateTime = LocalDateTime.now();
            for (int i=0; i < 5; i++) {
                pstmt.setString(1, "2학기 공통프로젝트 "+(i+1)+"주차 안내");
                pstmt.setString(2, categoryList[random.nextInt(3)]);
                pstmt.setString(3, imageUrlList[i]);
                String[] datetime = localDateTime.toString().split("T");
                String date = datetime[0].replace("-", "");
                String time = datetime[1].substring(0, 8).replace(":", "");
                pstmt.setString(4, date);
                pstmt.setString(5, time);
                pstmt.executeUpdate();
                localDateTime = localDateTime.plusDays(i + 1).plusSeconds(i + 123);
            }
            System.out.println("Insert Complete");
        } catch (Exception e) {
            System.out.println(conn.prepareStatement(sql));
            System.out.println("fail");
            System.out.println(e);
        }
    }


    public void insertScheduleCategory() throws SQLException {
        String sql = "insert into schedule_category(category) values(?)";
        String[] categoryList = {"알고리즘", "코딩과정", "프로젝트", "기타"};
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            for (String category:categoryList) {
                pstmt.setString(1, category);
                pstmt.executeUpdate();
            }
            System.out.println("Insert Complete");
        } catch (Exception e) {
            System.out.println("Insert Fail");
        }
    }

    /* 한 주간의 Fake 시간표 데이터를 집어 넣는 함수
    date : FakeData를 생성하고 싶은 주의 월요일 날짜 입력(format=yyyymmdd)
     */
    public void insertSchedule(String date) throws SQLException{
        PreparedStatement pstmt = null;
        Random random = new Random();
        String sql = "insert into schedule(date, track_code, title, sub_title, start_time, end_time, category_id, on_off) values(?,?,?,?,?,?,?,?)";
        String[] title = {"팀별 PJT 진행", "[LIVE] Back-End", " [LIVE] Front-End", "취업 특강"};
        LocalDate stdDate = LocalDate.of(Integer.parseInt(date.substring(0,4)), Integer.parseInt(date.substring(4,6)), Integer.parseInt(date.substring(6,8)));
        try {
            System.out.println("start");
            pstmt = conn.prepareStatement(sql);
            for (int i=0; i < 5; i++) {
                for (int j=0; j < 5; j++) {
                    int startTime = 9;
                    pstmt.setString(1, stdDate.toString().replace("-", ""));
                    pstmt.setInt(2, j);
                    pstmt.setString(4, "공통 프로젝트");
                    while (startTime < 12) {
                        pstmt.setString(3, title[random.nextInt(4)]);
                        pstmt.setInt(5, startTime);
                        startTime = startTime + random.nextInt(4) + 1;
                        if (startTime > 12)
                            startTime = 12;
                        pstmt.setInt(6, startTime);
                        pstmt.setLong(7, random.nextInt(4)+1);
                        pstmt.setInt(8, random.nextInt(2));
                        pstmt.executeUpdate();
                    }
                    startTime = 13;
                    while (startTime < 18) {
                        pstmt.setString(3, title[random.nextInt(4)]);
                        pstmt.setInt(5, startTime);
                        startTime = startTime + random.nextInt(4) + 1;
                        if (startTime > 18)
                            startTime = 18;
                        pstmt.setInt(6, startTime);
                        pstmt.setLong(7, random.nextInt(4)+1);
                        pstmt.setInt(8, random.nextInt(2));
                        pstmt.executeUpdate();
                    }
                }
                stdDate = stdDate.plusDays(1);
            }
            System.out.println("Insert Complete");
        } catch (Exception e) {
            System.out.println("fail");
            System.out.println(e);
        }
    }

    public void insertJobInfo() throws SQLException {
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO job_info(company, start_date, end_date, job, link) VALUES(?,?,?,?,?)";
        String[] companyList = {"삼성", "LG", "SK", "카카오", "네이버", "구글 코리아", "라인", "쿠팡", "배달의 민족", "당근", "토스"};
        String[] jobList = {"백엔드", "프론트엔드", "DBA", "DE", "DevOps", "MLOps"};
        Random random = new Random();
        LocalDateTime dateTime = LocalDateTime.now();
        try {
            System.out.println("Start");
            for (int i = 0; i < 30; i++) {
                pstmt = conn.prepareStatement(sql);
                PreparedStatement result = conn.prepareStatement("SELECT * FROM job_info WHERE company = ? and job = ?");
                String company = companyList[random.nextInt(11)];
                String job = jobList[random.nextInt(6)];
                result.setString(1, company);
                result.setString(2, job);
                while (result.executeQuery().next()) {
                    company = companyList[random.nextInt(11)];
                    job = jobList[random.nextInt(6)];
                    result.setString(1, company);
                    result.setString(2, job);
                }
                pstmt.setString(1, company);
                LocalDateTime startDateTime = dateTime.minusDays(random.nextInt(5)).plusDays(random.nextInt(5));
                pstmt.setLong(2, Long.parseLong(startDateTime.toString().substring(0, 19).replace("-", "").replace(":", "").replace("T", "")));
                pstmt.setLong(3, Long.parseLong(startDateTime.plusDays(random.nextInt(7)+14).toString().substring(0, 19).replace("-", "").replace(":", "").replace("T", "")));
                pstmt.setString(4, job);
                pstmt.setString(5, "www.???.com");
                pstmt.executeUpdate();
            }
            System.out.println("Insert Complete");
        } catch (Exception e) {
            System.out.println("Fail");
            System.out.println(e);
        }
    }

    public static void main(String[] args) throws SQLException {
        DbConnector db = new DbConnector();
//        db.insertScheduleCategory(); /*시간표 카테고리가 존재하지 않을 경우에만 실행*/
//        db.insertSchedule("20230206");
//        db.insertNotice();
        db.insertJobInfo();
    }

    public static void main(LocalDateTime started_at, LocalDateTime ended_at) throws SQLException {
        DbConnector conn = new DbConnector();
//        conn.insertNotice();
//        conn.updateStatus(started_at, ended_at);
//        LocalDate date = LocalDate.now();
//        int weekDay = date.getDayOfWeek().getValue();
//        date = date.minusDays(weekDay - 1);
//        LocalDate end_date = date.plusDays(4);
//        System.out.println(date);
//        System.out.println(end_date);
    }
}
