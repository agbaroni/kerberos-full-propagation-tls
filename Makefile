BUILDAH=buildah
PODMAN=podman
IC_PREFIX=kfp-
CP=cp
MY_IP=$(shell ip a | egrep -E 'inet ' | egrep -v '127\.0\.0' | cut -d ' ' -f 6 | cut -d '/' -f 1)

.PHONY: all certificates clean images
# $(CP) kdc/keytabs/postgres.keytab postgresql/
all: clean certificates
	$(BUILDAH) build -t $(IC_PREFIX)openldap openldap
	$(PODMAN) run --name $(IC_PREFIX)openldap --rm --publish '10636:636' --detach --interactive --tty $(IC_PREFIX)openldap
	$(BUILDAH) build --add-host=mymachine:$(MY_IP) -t $(IC_PREFIX)kdc kdc
	$(PODMAN) run --name $(IC_PREFIX)kdc --rm --add-host=mymachine:$(MY_IP) --publish '10088:88' --publish '10749:749' --publish '10750:750' --detach --interactive --tty --volume $(PWD)/kdc/keytabs:/tmp/keytabs $(IC_PREFIX)kdc
	$(BUILDAH) build --add-host=mymachine:$(MY_IP) -t $(IC_PREFIX)postgresql postgresql
	$(PODMAN) run --name $(IC_PREFIX)postgresql --rm --add-host=mymachine:$(MY_IP) --publish '15432:5432' --detach --interactive --tty $(IC_PREFIX)postgresql

certificates:
	echo -n > tls/artifacts/index.txt
	$(BUILDAH) build -t $(IC_PREFIX)tls tls
	$(PODMAN) run --name $(IC_PREFIX)tls --rm --volume $(PWD)/tls/artifacts:/tmp/artifacts $(IC_PREFIX)tls
	$(CP) tls/artifacts/ca.crt openldap/
	$(CP) tls/artifacts/openldap.crt openldap/
	$(CP) tls/artifacts/openldap.key openldap/
	$(CP) tls/artifacts/postgresql.crt postgresql/
	$(CP) tls/artifacts/postgresql.key postgresql/
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
	-$(RM) postgresql/*.keytab
	-$(PODMAN) rm -f $(IC_PREFIX)openldap
	-$(BUILDAH) rmi $(IC_PREFIX)openldap
	-$(PODMAN) rm -f $(IC_PREFIX)kdc
	-$(BUILDAH) rmi $(IC_PREFIX)kdc
	-$(PODMAN) rm -f $(IC_PREFIX)postgresql
	-$(BUILDAH) rmi $(IC_PREFIX)postgresql
	-$(BUILDAH) rmi $(shell $(BUILDAH) images -f dangling=true -q)
