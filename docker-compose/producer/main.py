import os
import yaml
import glob
import threading
from controllers.producer import insert_sensors, run_sensor
from models.sensor import create_connection, create_tables
from views.logger import log_info, log_error

# Load the sensor configuration from the YAML file
try:
    # Check if POD_NAME exists
    pod_name = os.getenv('POD_NAME')
    file = None

    if pod_name and pod_name.startswith("producer-") and pod_name.split("-")[-1].isdigit():
        # Use the replica number from POD_NAME to determine the file name
        replica_number = pod_name.split("-")[-1]
        file = f'/config/sensors-{replica_number}.yaml'

    # Fall back to the default logic if POD_NAME is not set or the file does not exist
    if not file:
        file = next(iter(glob.glob('/config/sensors-*.yaml')), None)

    if not file:
        log_error("No sensor configuration file found. Exiting.")
        exit()

    # Load the sensor configuration file
    with open(file, 'r') as f:
        sensor_config = yaml.safe_load(f)
        log_info(f"Loaded sensor configuration file: {file}")

except Exception as e:
    log_error(f"Error loading sensor configuration: {e}")
    exit()

# List of configured sensors
sensors = sensor_config['sensors']

# Establish an initial connection to the PostgreSQL database
conn = create_connection()

# Exit if the initial connection fails
if conn is None:
    log_error("Failed to connect to the database on startup. Exiting.")
    exit()

# Create tables if they don't exist
if not create_tables(conn):
    log_error("Failed to create tables. Exiting.")
    exit()

# Insert sensors into the database (ensure they are populated first)
insert_sensors(conn, sensors)

# Create and start a thread for each sensor
threads = []
for sensor in sensors:
    t = threading.Thread(target=run_sensor, args=(sensor, conn))
    threads.append(t)
    t.start()

# Keep the main script running
for t in threads:
    t.join()

# Close the database connection when the script finishes
conn.close()
