# Use the official TimescaleDB image
FROM timescale/timescaledb:latest-pg15

# Copy the healthcheck script
COPY ./check_databases.sh /usr/local/bin/check_databases.sh

# Make sure the script is executable
RUN chmod +x /usr/local/bin/check_databases.sh
