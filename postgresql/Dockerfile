FROM debian:testing-slim

COPY krb5.conf /etc/

RUN apt-get update \
 && apt-get install -y postgresql krb5-user libssl-dev curl tzdata

COPY --chown=postgres:postgres postgresql.crt /etc/postgresql/14/main/
COPY --chown=postgres:postgres postgresql.key /etc/postgresql/14/main/
COPY --chown=postgres:postgres postgresql.conf /etc/postgresql/14/main/
COPY --chown=postgres:postgres pg_hba.conf /etc/postgresql/14/main/
COPY --chown=postgres:postgres pg_ident.conf /etc/postgresql/14/main/

EXPOSE 5432

USER postgres

ENTRYPOINT [ "/usr/lib/postgresql/14/bin/postgres", "-D", "/etc/postgresql/14/main/" ]
