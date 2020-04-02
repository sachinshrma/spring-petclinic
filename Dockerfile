FROM openjdk:8-alpine
COPY /target /usr/src/myapp
WORKDIR /usr/src/myapp
CMD java -jar spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar.jar
