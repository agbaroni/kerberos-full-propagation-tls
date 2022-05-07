FROM alpine

COPY . /tmp/

WORKDIR /tmp/

RUN apk add maven openjdk11-jdk \
 && mvn clean package

VOLUME /root/.m2
VOLUME /tmp/output