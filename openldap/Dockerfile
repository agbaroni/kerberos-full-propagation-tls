FROM alpine

COPY server.ldif /tmp/

RUN apk add openldap openldap-back-mdb openldap-overlay-accesslog openldap-overlay-auditlog openldap-overlay-ppolicy openldap-overlay-refint \
 && mkdir -p /etc/openldap/slapd.d \
 && mkdir -p /var/run/openldap/data

COPY openldap.crt /etc/openldap/
COPY openldap.key /etc/openldap/

RUN /usr/sbin/slapadd -F /etc/openldap/slapd.d -n 0 -l /tmp/server.ldif

EXPOSE 389

ENTRYPOINT [ "/usr/sbin/slapd", "-F", "/etc/openldap/slapd.d", "-h", "ldap:///", "-d", "32", "-d", "64", "-d", "128" ]
