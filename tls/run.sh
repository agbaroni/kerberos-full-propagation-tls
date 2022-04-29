#!/bin/bash

set -x

cd /tmp/artifacts

openssl3 req -passout 'pass:password' -out ca.crt -new -keyout ca.key -config /tmp/openssl.cnf -subj '/C=IT/O=Red Hat/OU=Global Professional Services/CN=CA' -x509
