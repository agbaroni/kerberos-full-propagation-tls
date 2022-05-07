FROM alpine

COPY krb5.conf /etc/
COPY wildfly-23.0.2.Final.tar.gz /tmp/
COPY kfp-apps-frontend-application-0.1.0-SNAPSHOT.ear /tmp/
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
 && /bin/bash -c '/usr/bin/openssl3 s_client -showcerts -connect mymachine:18443 2>/dev/null < /dev/null | /bin/sed -n -e "/-.BEGIN/,/-.END/p" > /tmp/mymachine_remote.crt' \
 && keytool -importcert -file /tmp/mymachine_remote.crt -keystore /tmp/mymachine_remote.jks -storepass password -noprompt

EXPOSE 8443

ENTRYPOINT [ "/bin/bash", "/opt/wildfly-23.0.2.Final/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement=0.0.0.0", "-c", "standalone-full.xml" ]
