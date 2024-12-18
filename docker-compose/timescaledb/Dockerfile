FROM timescale/timescaledb:latest-pg15

# COPY ./check_databases.sh /usr/local/bin/check_databases.sh

# RUN chmod +x /usr/local/bin/check_databases.sh

EXPOSE 5432

# FROM timescale/timescaledb:latest-pg15

# ENV POSTGRES_USER=siemens
# ENV POSTGRES_PASSWORD=energy

# COPY ./check_databases.sh /usr/local/bin/check_databases.sh

# RUN chmod +x /usr/local/bin/check_databases.sh

# RUN docker-entrypoint.sh postgres & \
#     until pg_isready -U ${POSTGRES_USER} -d postgres; do sleep 1; done && \
#     psql -U ${POSTGRES_USER} -d postgres -c "CREATE DATABASE grafana_storage;" && \
#     psql -U ${POSTGRES_USER} -d postgres -c "CREATE DATABASE data_storage;" && \
#     killall postgres

# EXPOSE 5432
