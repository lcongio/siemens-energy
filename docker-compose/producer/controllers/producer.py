import random
import time
from psycopg2 import sql # type: ignore
from datetime import datetime
from views.logger import log_info, log_error

# Function to insert sensors into the database
def insert_sensors(conn, sensors):
    try:
        with conn.cursor() as cur:
            for sensor in sensors:
                insert_query = sql.SQL("""
                    INSERT INTO sensors (sensor_id, sensor_type, unit)
                    VALUES (%s, %s, %s)
                    ON CONFLICT (sensor_id) DO NOTHING
                """)
                cur.execute(insert_query, (
                    sensor['id'],
                    sensor['type'],
                    sensor['unit']
                ))
            conn.commit()
            log_info(f"Successfully registry {len(sensors)} sensors.")
    except Exception as e:
        log_error(f"Error inserting sensors: {e}")

# Function to generate random data for a sensor
def generate_data(sensor, conn):
    value = random.uniform(sensor['lower_limit'], sensor['upper_limit'])
    log_info(f"{sensor['id']} ({sensor['type']}): {value:.2f} {sensor['unit']}")
    
    try:
        with conn.cursor() as cur:
            insert_query = sql.SQL("""
                INSERT INTO sensor_data (sensor_id, value, timestamp)
                VALUES (%s, %s, %s)
            """)
            cur.execute(insert_query, (
                sensor['id'],
                value,
                datetime.utcnow()
            ))
            conn.commit()
    except Exception as e:
        log_error(f"Error inserting data for {sensor['id']}: {e}")

# Function to run each sensor based on its interval
def run_sensor(sensor, conn):
    while True:
        generate_data(sensor, conn)
        time.sleep(sensor['interval'])
