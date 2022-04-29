BUILDAH=buildah
PODMAN=podman
IC_PREFIX=kfp-
CP=cp

.PHONY: all certificates clean images

all: clean certificates images
	$(PODMAN) run --name $(IC_PREFIX)openldap --rm --publish '10636:636' --detach --interactive --tty $(IC_PREFIX)openldap

certificates:
	echo -n > tls/artifacts/index.txt
	$(BUILDAH) build -t $(IC_PREFIX)tls tls
	$(PODMAN) run --name $(IC_PREFIX)tls --rm --volume $(PWD)/tls/artifacts:/tmp/artifacts $(IC_PREFIX)tls
	$(CP) tls/artifacts/ca.crt openldap/
	$(CP) tls/artifacts/openldap.crt openldap/
	$(CP) tls/artifacts/openldap.key openldap/
	$(BUILDAH) rmi $(IC_PREFIX)tls

clean:
	-$(RM) tls/artifacts/*.crt
	-$(RM) tls/artifacts/*.csr
	-$(RM) tls/artifacts/*.key
	-$(RM) tls/artifacts/index.txt.*
	-$(RM) tls/artifacts/serial
	-$(RM) tls/artifacts/serial.*
	-$(RM) tls/artifacts/certs/*.pem
	-$(PODMAN) rm -f $(IC_PREFIX)openldap
	-$(BUILDAH) rmi $(IC_PREFIX)openldap
	-$(BUILDAH) rmi $(shell $(BUILDAH) images -f dangling=true -q)

images:
	$(BUILDAH) build -t $(IC_PREFIX)openldap openldap
