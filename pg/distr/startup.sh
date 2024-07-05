#!/bin/bash

/usr/lib/postgresql/11/bin/postgres -D /var/lib/postgresql/11/main \
    -c config_file=/etc/postgresql/11/main/postgresql.conf \
    -c logging_collector=on \
    -c log_directory=/var/lib/postgresql/11/main \
    -c log_filename=postgresql.log \
    -c log_statement=$PG_LOG_STATEMENT
