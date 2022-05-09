FROM alpine

RUN apk add chrony tzdata

ENV TZ=Europe/Rome

COPY krb5.conf /etc/
COPY postgresql-42.3.5.jar /tmp/
COPY wildfly-23.0.2.Final.tar.gz /tmp/
COPY kfp-apps-backend-application-0.1.0-SNAPSHOT.ear /tmp/
COPY openldap.crt /tmp/
COPY openldap.key /tmp/

WORKDIR /opt

COPY setup.cli ./

RUN apk add bash curl openjdk11-jre-headless openssl3 \
 && tar -xzf /tmp/wildfly-23.0.2.Final.tar.gz \
 && openssl3 pkcs12 -export -in /tmp/openldap.crt -inkey /tmp/openldap.key -out /tmp/openldap.p12 -passout pass:password \
 && keytool -importkeystore -srckeystore /tmp/openldap.p12 -srcstoretype PKCS12 -destkeystore /tmp/openldap.jks -deststoretype JKS -srcstorepass password -deststorepass password \
 && /bin/bash /opt/wildfly-23.0.2.Final/bin/jboss-cli.sh --file=/opt/setup.cli \
 && adduser -D jboss \
 && chown -R jboss:jboss /opt/wildfly-23.0.2.Final \

EXPOSE 8443

ENTRYPOINT [ "/bin/bash", "/opt/wildfly-23.0.2.Final/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement=0.0.0.0", "-c", "standalone-full.xml" ]
