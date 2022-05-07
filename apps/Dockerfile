FROM alpine

COPY . /tmp/

WORKDIR /tmp/

RUN apk add maven openjdk11-jdk \
 && mvn clean package

VOLUME /tmp/output