BUILDAH=buildah
PODMAN=podman
IC_PREFIX=kfp-
MV=mv

.PHONY: all certificates clean images

all: clean certificates images

certificates:
	$(BUILDAH) build -t $(IC_PREFIX)tls tls
	$(PODMAN) run --name $(IC_PREFIX)tls --rm --volume $(PWD)/tls/artifacts:/tmp/artifacts $(IC_PREFIX)tls
	$(MV) tls/artifacts/openldap.crt openldap/
	$(MV) tls/artifacts/openldap.key openldap/
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
	-echo -n > tls/artifacts/index.txt

images:
	$(BUILDAH) build -t $(IC_PREFIX)openldap openldap
