#!/bin/bash

# Check if grafana_storage database is ready
pg_isready -U siemens -d grafana_storage
if [ $? -ne 0 ]; then
  echo "grafana_storage is not ready"
  exit 1
fi

# Check if sensor_storage database is ready
pg_isready -U siemens -d sensor_storage
if [ $? -ne 0 ]; then
  echo "sensor_storage is not ready"
  exit 1
fi

# Both databases are ready
echo "grafana_storage and sensor_storage are ready"
exit 0
