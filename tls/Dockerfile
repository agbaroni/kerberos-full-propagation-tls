FROM alpine

COPY openssl.cnf /tmp/
COPY run.sh /tmp/

RUN apk add bash openssl3

VOLUME /tmp/artifacts

ENTRYPOINT [ "/bin/bash", "/tmp/run.sh" ]
