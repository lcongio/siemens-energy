import psycopg2 # type: ignore
import os
from views.logger import log_info, log_error

# Database connection details
db_host = os.getenv('DB_HOST', 'localhost')
db_port = os.getenv('DB_PORT', '5432')
db_name = os.getenv('DB_NAME', 'postgres')
db_user = os.getenv('DB_USER', 'user')
db_password = os.getenv('DB_PASSWORD', 'pass')

# Function to create a new database connection
def create_connection():
    try:
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password
        )
        log_info("Database connection established.")
        return conn
    except Exception as e:
        log_error(f"Failed to create database connection: {e}")
        return None

# Function to create the necessary tables
def create_tables(conn):
    try:
        with conn.cursor() as cur:
            log_info("Starting table creation process...")
            
            # Create the sensors table if it doesn't exist
            cur.execute("""
                CREATE TABLE IF NOT EXISTS sensors (
                    id SERIAL PRIMARY KEY,
                    sensor_id VARCHAR(255) UNIQUE NOT NULL,
                    sensor_type VARCHAR(50) NOT NULL,
                    unit VARCHAR(50) NOT NULL
                );
            """)

            # Create the sensor_data table if it doesn't exist
            cur.execute("""
                CREATE TABLE IF NOT EXISTS sensor_data (
                    id SERIAL PRIMARY KEY,
                    sensor_id VARCHAR(255) NOT NULL,
                    value FLOAT NOT NULL,
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id) ON DELETE CASCADE
                );
            """)

            conn.commit()
            log_info("Tables created successfully (if they didn't exist).")
    except Exception as e:
        log_error(f"Error creating tables: {e}")
        return False
    return True
