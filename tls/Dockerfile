FROM alpine

COPY openssl.cnf /etc/ssl/
COPY run.sh /opt/

RUN apk add bash openssl3

VOLUME /tmp/artifacts

ENTRYPOINT [ "/bin/bash", "/opt/run.sh" ]
