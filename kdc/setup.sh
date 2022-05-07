#!/bin/bash

set -x

(echo 'password' ; echo 'password') | /usr/sbin/kdb5_ldap_util -r EXAMPLE.COM stashsrvpw -f /var/lib/krb5kdc/ldap_service_passwords 'cn=kadmind,ou=kerberos,dc=example,dc=com'
(echo 'password' ; echo 'password') | /usr/sbin/kdb5_ldap_util -r EXAMPLE.COM stashsrvpw -f /var/lib/krb5kdc/ldap_service_passwords 'cn=kdc,ou=kerberos,dc=example,dc=com'

/usr/sbin/kdb5_util -r EXAMPLE.COM -P 'password' create -s

/usr/sbin/kadmin.local add_principal -pw 'password' admin/admin@EXAMPLE.COM

/usr/sbin/kadmin.local add_principal -pw 'password' postgres/mymachine@EXAMPLE.COM
/usr/sbin/kadmin.local add_principal -pw 'password' HTTP/mymachine@EXAMPLE.COM
/usr/sbin/kadmin.local add_principal -pw 'password' remote/mymachine@EXAMPLE.COM

/usr/sbin/kadmin.local add_principal -pw 'password' ludwig@EXAMPLE.COM
/usr/sbin/kadmin.local add_principal -pw 'password' wolfgang@EXAMPLE.COM
