
```
make

sudo vim /etc/hosts:
   ...
   mymachine <any host IP address>
   ...

ldapsearch -x -H 'ldaps://mymachine:10636' -b 'dc=example,dc=com' -D 'cn=Administrator,dc=example,dc=com' -w 'Admin123!' -o TLS_REQCERT=allow

export KRB5_CONFIG=$PWD/kdc/krb5.conf

kinit ludwig@EXAMPLE.COM

psql -U ludwig@EXAMPLE.COM -d xxx -h mymachine -p 15432

rm -f cookies.txt ; curl -vk -H 'Content-Type: application/json' -u ':' --delegation always --negotiate -b cookies.txt -c cookies.txt https://mymachine:28443/test/remote
```
