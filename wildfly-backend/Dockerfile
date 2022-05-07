FROM alpine

WORKDIR /opt

COPY setup.cli ./

RUN apk add bash curl openjdk11-jre-headless \
 && curl -JLk https://download.jboss.org/wildfly/23.0.2.Final/wildfly-23.0.2.Final.tar.gz > /tmp/wildfly-23.0.2.Final.tar.gz \
 && tar -xzf /tmp/wildfly-23.0.2.Final.tar.gz \
 && /bin/bash /opt/wildfly-23.0.2.Final/bin/jboss-cli.sh -f /opt/setup.cli \
 && useradd jboss \
 && chown -R jboss:jboss /opt/wildfly-23.0.2.Final

EXPOSE 8443

ENTRYPOINT [ "/bin/bash", "/opt/wildfly-23.0.2.Final/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement=0.0.0.0" ]
