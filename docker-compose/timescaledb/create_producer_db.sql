-- Create the data_storage database
CREATE DATABASE data_storage;

-- Connect to the database
\c data_storage;

-- Create the sensor_data table if it doesn't exist
CREATE TABLE IF NOT EXISTS sensor_data (
    id SERIAL PRIMARY KEY,
    sensor_id VARCHAR(255) NOT NULL,
    sensor_type VARCHAR(50) NOT NULL,
    unit VARCHAR(50) NOT NULL,
    value FLOAT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
