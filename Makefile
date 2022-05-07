BUILDAH=buildah
PODMAN=podman
IC_PREFIX=kfp-
CP=cp
MY_IP=$(shell ip a | egrep -E 'inet ' | egrep -v '127\.0\.0' | cut -d ' ' -f 6 | cut -d '/' -f 1)

.PHONY: all certificates clean images

all: clean certificates
	$(BUILDAH) build -t $(IC_PREFIX)openldap openldap
	$(PODMAN) run --name $(IC_PREFIX)openldap --rm --publish '10636:636' --detach --interactive --tty $(IC_PREFIX)openldap
	$(BUILDAH) build --add-host=mymachine:$(MY_IP) -t $(IC_PREFIX)kdc kdc
	$(PODMAN) run --name $(IC_PREFIX)kdc --rm --add-host=mymachine:$(MY_IP) --publish '10088:88' --publish '10749:749' --publish '10750:750' --detach --interactive --tty --volume $(PWD)/kdc/keytabs:/tmp/keytabs $(IC_PREFIX)kdc
	$(CP) kdc/krb5.conf postgresql/
	$(BUILDAH) build --add-host=mymachine:$(MY_IP) -t $(IC_PREFIX)postgresql postgresql
	chmod 0644 kdc/keytabs/services.keytab
	$(PODMAN) run --name $(IC_PREFIX)postgresql --rm --add-host=mymachine:$(MY_IP) --publish '15432:5432' --detach --interactive --tty --volume $(PWD)/kdc/keytabs:/tmp/keytabs $(IC_PREFIX)postgresql
	if [ ! -e wildfly-backend/wildfly-23.0.2.Final.tar.gz ]; then curl -JLk https://download.jboss.org/wildfly/23.0.2.Final/wildfly-23.0.2.Final.tar.gz > wildfly-backend/wildfly-23.0.2.Final.tar.gz ; fi
	$(BUILDAH) build --add-host=mymachine:$(MY_IP) -t $(IC_PREFIX)wildfly-backend wildfly-backend
	$(PODMAN) exec -it $(IC_PREFIX)postgresql /usr/bin/psql -c 'CREATE USER "ludwig@EXAMPLE.COM" WITH NOCREATEDB NOCREATEROLE NOSUPERUSER'
	$(PODMAN) exec -it $(IC_PREFIX)postgresql /usr/bin/psql -c 'CREATE USER "wolfgang@EXAMPLE.COM" WITH NOCREATEDB NOCREATEROLE NOSUPERUSER'
	$(PODMAN) exec -it $(IC_PREFIX)postgresql /usr/bin/psql -c 'CREATE DATABASE DB1 WITH OWNER "ludwig@EXAMPLE.COM"'
	$(PODMAN) exec -it $(IC_PREFIX)postgresql /usr/bin/psql -c 'CREATE DATABASE DB2 WITH OWNER "wolfgang@EXAMPLE.COM"'
	$(PODMAN) run --name $(IC_PREFIX)wildfly-backend --rm --add-host=mymachine:$(MY_IP) --publish '18443:8443' --detach --interactive --tty --volume $(PWD)/kdc/keytabs:/tmp/keytabs $(IC_PREFIX)wildfly-backend

certificates:
	echo -n > tls/artifacts/index.txt
	$(BUILDAH) build -t $(IC_PREFIX)tls tls
	$(PODMAN) run --name $(IC_PREFIX)tls --rm --volume $(PWD)/tls/artifacts:/tmp/artifacts $(IC_PREFIX)tls
	$(CP) tls/artifacts/ca.crt openldap/
	$(CP) tls/artifacts/openldap.crt openldap/
	$(CP) tls/artifacts/openldap.key openldap/
	$(CP) tls/artifacts/ca.crt postgresql/
	$(CP) tls/artifacts/postgresql.crt postgresql/
	$(CP) tls/artifacts/postgresql.key postgresql/
	$(CP) tls/artifacts/ca.crt wildfly-backend/
	$(CP) tls/artifacts/wildfly-backend.crt wildfly-backend/
	$(CP) tls/artifacts/wildfly-backend.key wildfly-backend/
	$(CP) tls/artifacts/ca.crt wildfly-frontend/
	$(CP) tls/artifacts/wildfly-frontend.crt wildfly-frontend/
	$(CP) tls/artifacts/wildfly-frontend.key wildfly-frontend/
	$(BUILDAH) rmi $(IC_PREFIX)tls

clean:
	-$(RM) tls/artifacts/*.crt
	-$(RM) tls/artifacts/*.csr
	-$(RM) tls/artifacts/*.key
	-$(RM) tls/artifacts/index.txt.*
	-$(RM) tls/artifacts/serial
	-$(RM) tls/artifacts/serial.*
	-$(RM) tls/artifacts/certs/*.pem
	-$(RM) kdc/keytabs/*.keytab
	-$(RM) openldap/*.crt
	-$(RM) openldap/*.key
	-$(RM) postgresql/*.crt
	-$(RM) postgresql/*.key
	-$(RM) postgresql/krb5.conf
	-$(RM) wildfly-backend/*.crt
	-$(RM) wildfly-backend/*.key
	-$(RM) wildfly-frontend/*.crt
	-$(RM) wildfly-frontend/*.key
	-$(PODMAN) rm -f $(IC_PREFIX)openldap
	-$(BUILDAH) rmi $(IC_PREFIX)openldap
	-$(PODMAN) rm -f $(IC_PREFIX)kdc
	-$(BUILDAH) rmi $(IC_PREFIX)kdc
	-$(PODMAN) rm -f $(IC_PREFIX)postgresql
	-$(BUILDAH) rmi $(IC_PREFIX)postgresql
	-$(PODMAN) rm -f $(IC_PREFIX)wildfly-backend
	-$(BUILDAH) rmi $(IC_PREFIX)wildfly-backend
	-$(PODMAN) rm -f $(IC_PREFIX)wildfly-frontend
	-$(BUILDAH) rmi $(IC_PREFIX)wildfly-frontend
	-$(BUILDAH) rmi $(shell $(BUILDAH) images -f dangling=true -q)
