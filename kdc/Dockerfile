FROM alpine

COPY setup.sh /tmp/

RUN apk add bash krb5 krb5-server krb5-server-ldap python3 py3-pip \
 && pip3 install supervisor

COPY kadm5.acl /var/lib/krb5kdc/
COPY kdc.conf /var/lib/krb5kdc/
COPY krb5.conf /etc/
COPY ldaprc /
COPY supervisord.conf /etc/

RUN /bin/bash /tmp/setup.sh

EXPOSE 88
EXPOSE 749
EXPOSE 750

ENTRYPOINT [ "/usr/bin/supervisord", "-n" ]
