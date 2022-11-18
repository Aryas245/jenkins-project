FROM openjdk:8-alpine

# Required for starting application up.
RUN apk update && apk add /bin/sh

RUN mkdir -p /opt/app
ENV PROJECT_HOME /opt/app

COPY target/jenkins-docker-k8s-project-1.0.jar $PROJECT_HOME/jenkins-docker-k8s-project-1.0.jar

WORKDIR $PROJECT_HOME

CMD ["java" ,"-jar","./jenkins-docker-k8s-project-1.0.jar"]
