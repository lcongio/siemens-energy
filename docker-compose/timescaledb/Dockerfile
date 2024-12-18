FROM timescale/timescaledb:latest-pg15

COPY ./check_databases.sh /usr/local/bin/check_databases.sh

RUN chmod +x /usr/local/bin/check_databases.sh

EXPOSE 5432
