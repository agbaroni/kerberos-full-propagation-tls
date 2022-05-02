FROM alpine

COPY init_com.ldif /tmp/
COPY server.ldif /tmp/

RUN apk add bash curl openldap openldap-back-mdb openldap-overlay-accesslog openldap-overlay-auditlog openldap-overlay-ppolicy openldap-overlay-refint \
 && mkdir -p /etc/openldap/slapd.d \
 && mkdir -p /var/run/openldap/data \
 && curl -JLk https://raw.githubusercontent.com/krb5/krb5/master/src/plugins/kdb/ldap/libkdb_ldap/kerberos.openldap.ldif > /tmp/kerberos.openldap.ldif

COPY ca.crt /etc/openldap/
COPY openldap.crt /etc/openldap/
COPY openldap.key /etc/openldap/

RUN /usr/sbin/slapadd -F /etc/openldap/slapd.d -n 0 -l /tmp/server.ldif
RUN /usr/sbin/slapadd -F /etc/openldap/slapd.d -n 1 -l /tmp/init_com.ldif

EXPOSE 636

ENTRYPOINT [ "/usr/sbin/slapd", "-F", "/etc/openldap/slapd.d", "-h", "ldaps:///", "-d", "-1" ]
