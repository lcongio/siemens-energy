import os
import yaml
import logging
import random
import time
import threading
import psycopg2  # type: ignore
from psycopg2 import sql  # type: ignore
from datetime import datetime

# Set up basic logging configuration
logging.basicConfig(level=logging.DEBUG,  # Log all levels DEBUG and above
                    format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Read database connection details from environment variables
db_host = os.getenv('DB_HOST', 'localhost')
db_port = os.getenv('DB_PORT', '5432')
db_name = os.getenv('DB_NAME', 'postgres')
db_user = os.getenv('DB_USER', 'user')
db_password = os.getenv('DB_PASSWORD', 'pass')

# Function to create a new database connection
def create_connection():
    try:
        return psycopg2.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password
        )
    except Exception:
        return None

# Function to generate random data for a sensor
def generate_data(sensor, conn):
    if conn is None or conn.closed:
        conn = create_connection()
        if conn is None:
            logger.warning(f"Database connection failed for {sensor['id']}. Skipping insertion.")
            return  # Skip if we cannot reconnect to the database
    
    # Generate random sensor value
    value = random.uniform(sensor['lower_limit'], sensor['upper_limit'])
    logger.info(f"{sensor['id']} ({sensor['type']}): {value:.2f} {sensor['unit']}")
    
    try:
        # Insert the data into the database
        with conn.cursor() as cur:
            insert_query = sql.SQL("""
                INSERT INTO sensor_data (sensor_id, sensor_type, value, unit, timestamp)
                VALUES (%s, %s, %s, %s, %s)
            """)
            cur.execute(insert_query, (
                sensor['id'],
                sensor['type'],
                value,
                sensor['unit'],
                datetime.utcnow()
            ))
            conn.commit()
    except Exception as e:
        logger.error(f"Error inserting data for {sensor['id']}: {e}")

# Function to run each sensor based on its interval
def run_sensor(sensor, conn):
    while True:
        generate_data(sensor, conn)
        time.sleep(sensor['interval'])

# Load the sensor configuration from the YAML file
with open('/config/sensors.yaml', 'r') as file:
    sensor_config = yaml.safe_load(file)

# List of configured sensors
sensors = sensor_config['sensors']

# Establish an initial connection to the PostgreSQL database
conn = create_connection()

# Exit if the initial connection fails
# if conn is None:
#     logger.error("Failed to connect to the database on startup. Exiting.")
#     exit()

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
