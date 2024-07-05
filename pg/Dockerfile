FROM registry.astralinux.ru/library/alse:1.7.5

ENV TZ=Europe/Moscow

RUN apt-get update && apt-get -y -q dist-upgrade && apt-get -y -q install postgresql-11

ARG FP_USER
ARG FP_REPO
ARG FP_REPO_SCHEMA
ARG FP_USER_AUDIT

USER postgres
RUN /etc/init.d/postgresql start \
  && psql --command "CREATE ROLE \"$FP_USER\" LOGIN ENCRYPTED PASSWORD '$FP_USER' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;" \
  && psql --command "CREATE DATABASE \"$FP_REPO\" WITH OWNER = \"$FP_USER\" ENCODING = 'UTF8' TABLESPACE = pg_default  LC_COLLATE = default LC_CTYPE = default CONNECTION LIMIT = -1;" \
  && psql --command "ALTER DATABASE \"$FP_REPO\" SET lo_compat_privileges = 'on';" \
  && psql --command "GRANT ALL ON DATABASE \"$FP_REPO\" TO \"$FP_USER\";" \
  && psql -d $FP_REPO --command "CREATE SCHEMA \"$FP_REPO_SCHEMA\" AUTHORIZATION \"$FP_USER\";" \
  && psql -d $FP_REPO --command "CREATE FUNCTION loin (cstring) RETURNS lo AS 'oidin' LANGUAGE internal IMMUTABLE STRICT;" \
  && psql -d $FP_REPO --command "CREATE FUNCTION loout (lo) RETURNS cstring AS 'oidout' LANGUAGE internal IMMUTABLE STRICT;" \
  && psql -d $FP_REPO --command "CREATE FUNCTION lorecv (internal) RETURNS lo AS 'oidrecv' LANGUAGE internal IMMUTABLE STRICT;" \
  && psql -d $FP_REPO --command "CREATE FUNCTION losend (lo) RETURNS bytea AS 'oidsend' LANGUAGE internal IMMUTABLE STRICT;" \
  && psql -d $FP_REPO --command "CREATE TYPE lo (INPUT = loin, OUTPUT = loout, RECEIVE = lorecv, SEND = losend, INTERNALLENGTH = 4, PASSEDBYVALUE);" \
  && psql -d $FP_REPO --command "CREATE CAST (lo AS oid) WITHOUT FUNCTION AS IMPLICIT;" \
  && psql -d $FP_REPO --command "CREATE CAST (oid AS lo) WITHOUT FUNCTION AS IMPLICIT;" \
  && psql -d $FP_REPO --command "CREATE OR REPLACE FUNCTION lo_manage() RETURNS pg_catalog.trigger AS '\$libdir/lo' LANGUAGE C;" \
  && psql --command "CREATE ROLE \"$FP_USER_AUDIT\" WITH LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION ENCRYPTED PASSWORD '$FP_USER_AUDIT';" \
  && psql -d $FP_REPO --command "GRANT CONNECT ON DATABASE \"$FP_REPO\" to \"$FP_USER_AUDIT\";" \
  && psql -d $FP_REPO --command "GRANT USAGE ON SCHEMA \"$FP_REPO_SCHEMA\" to \"$FP_USER_AUDIT\";"
  #&& psql -d $FP_REPO --command "GRANT SELECT ON TABLE $FP_REPO_SCHEMA.b_jlo TO \"$FP_USER_AUDIT\";" \
  #&& psql -d $FP_REPO --command "insert into $FP_REPO_SCHEMA.b_sec_dat (vs, dat, id) values('$FP_USER_AUDIT', 1, 'AUDITOR');"\

USER root
RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/11/main/pg_hba.conf \
  && echo "listen_addresses='*'" >> /etc/postgresql/11/main/postgresql.conf \
  && echo "standard_conforming_strings on" >> /etc/postgresql/11/main/postgresql.conf \
  && ln -sf /proc/self/fd/1 /var/lib/postgresql/11/main/postgresql.log

EXPOSE 5432

VOLUME ["/var/lib/postgresql/11/main"]

ADD distr/startup.sh /usr/bin/startup.sh

ARG PG_LOG_STATEMENT
ENV PG_LOG_STATEMENT $PG_LOG_STATEMENT

USER postgres
CMD ["/bin/bash", "-c", "/usr/bin/startup.sh"]