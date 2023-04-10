package com.ssafy.ssafytime.db;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import static com.ssafy.ssafytime.api.controller.SurveyController.cnt;

public class DbConnector {
    private Connection conn;
    private static final String USERNAME = "root";
    private static final String PASSWORD = "Withfavor98!";
    private static final String URL = "jdbc:mysql://localhost:3306/ssafy_web_db";
    public DbConnector() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
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
                      ";");
            stmt.executeUpdate("CREATE EVENT surveyStatusChange" + ++cnt + " \n" +
                      "on schedule \n" +
                      "at " + "'" + endedAt + "'" +
                      "\n do \n" +
                      "\tupdate survey \n" +
                      "    set status = 2" +
                      ";");
              stmt.close();
              conn.close();
        } catch (Exception e) {
            System.out.println("fail");
            System.out.println(e);
        }
    }
    public static void main(LocalDateTime started_at, LocalDateTime ended_at) throws SQLException {
        DbConnector conn = new DbConnector();
        conn.updateStatus(started_at, ended_at);
    }
}


