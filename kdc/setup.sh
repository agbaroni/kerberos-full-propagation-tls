#!/bin/bash

set -x

(echo 'KAdminD123!' ; echo 'KAdminD123!') | /usr/sbin/kdb5_ldap_util -r EXAMPLE.COM stashsrvpw -f /var/lib/krb5kdc/ldap_service_passwords 'cn=kadmind,ou=kerberos,dc=example,dc=com'
(echo 'KDC123!' ; echo 'KDC123!') | /usr/sbin/kdb5_ldap_util -r EXAMPLE.COM stashsrvpw -f /var/lib/krb5kdc/ldap_service_passwords 'cn=kdc,ou=kerberos,dc=example,dc=com'

/usr/sbin/kdb5_util -r EXAMPLE.COM -P 'Password123!' create -s

/usr/sbin/kadmin.local add_principal -pw 'Admin123!' admin/admin@EXAMPLE.COM

/usr/sbin/kadmin.local add_principal -pw 'Postgres123!' postgres/mymachine@EXAMPLE.COM
/usr/sbin/kadmin.local add_principal -pw 'HTTP123!' HTTP/mymachine@EXAMPLE.COM
/usr/sbin/kadmin.local add_principal -pw 'Remote123!' remote/mymachine@EXAMPLE.COM
