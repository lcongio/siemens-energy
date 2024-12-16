import yaml
import threading
from controllers.producer import insert_sensors, run_sensor
from models.sensor import create_connection, create_tables
from views.logger import log_error

# Load the sensor configuration from the YAML file
with open('/config/sensors.yaml', 'r') as file:
    sensor_config = yaml.safe_load(file)

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
