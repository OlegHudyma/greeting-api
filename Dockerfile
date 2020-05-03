FROM openjdk:8-jre-alpine
MAINTAINER Oleg Hudyma <oleg_hudyma@epam.com>

COPY ["target/greeting-api.jar", "greeting-api.jar"]
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "greeting-api.jar"]
