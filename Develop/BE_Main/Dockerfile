FROM openjdk:11
ARG JAR_FILE="build/libs/ssafytime-*-SNAPSHOT.jar"
COPY ${JAR_FILE} build.jar
ENTRYPOINT ["java","-jar","-Duser.timezone=Asia/Seoul","build.jar"]
