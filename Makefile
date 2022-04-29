BUILDAH=buildah
PODMAN=podman
IC_PREFIX=kfp-

.PHONY: all clean images

all: clean images
	$(PODMAN) run --name $(IC_PREFIX)tls --rm --volume $(PWD)/tls/artifacts:/tmp/artifacts $(IC_PREFIX)tls

clean:
	-$(RM) tls/artifacts/*.crt
	-$(RM) tls/artifacts/*.csr
	-$(RM) tls/artifacts/*.key
	-$(RM) tls/artifacts/index.txt.*
	-$(RM) tls/artifacts/serial
	-$(RM) tls/artifacts/certs/*.pem
	-$(PODMAN) rm -f $(IC_PREFIX)openldap
	-$(PODMAN) rm -f $(IC_PREFIX)tls
	-$(BUILDAH) rmi $(IC_PREFIX)openldap
	-$(BUILDAH) rmi $(IC_PREFIX)tls

images:
	$(BUILDAH) build -t $(IC_PREFIX)tls tls
	$(BUILDAH) build -t $(IC_PREFIX)openldap openldap
