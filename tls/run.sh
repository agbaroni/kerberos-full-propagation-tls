#!/bin/bash

set -x

cd /tmp/artifacts

openssl3 req -passout 'pass:password' -out ca.csr -new -keyout ca.key -config /tmp/openssl.cnf -subj "/C=IT/O=Example/CN=CA"
openssl3 ca -config /tmp/openssl.cnf -in ca.csr -passin 'pass:password' -out ca.crt -create_serial -selfsign -keyfile ca.key -batch

openssl3 req -passout 'pass:password' -out openldap.csr -new -keyout openldap.key -config /tmp/openssl.cnf -subj "/C=IT/O=Example/CN=kfp-openldap" -nodes
openssl3 ca -config /tmp/openssl.cnf -in openldap.csr -passin 'pass:password' -out openldap.crt -batch

openssl3 req -passout 'pass:password' -out postgresql.csr -new -keyout postgresql.key -config /tmp/openssl.cnf -subj "/C=IT/O=Example/CN=kfp-postgresql" -nodes
openssl3 ca -config /tmp/openssl.cnf -in postgresql.csr -passin 'pass:password' -out postgresql.crt -batch
