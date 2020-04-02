FROM openjdk:8-alpine
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
CMD ["java", "-jar webapp.jar"]
