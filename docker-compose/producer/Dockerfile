# Use an official Python base image
FROM python:3.9-slim

RUN apt update && apt install -y \
    build-essential libpq-dev vim

# Set the working directory in the container
WORKDIR /app

# Copy the application files
# COPY producer.py /app/producer.py
COPY models /app/models
COPY views /app/views
COPY controllers /app/controllers
COPY main.py /app/

# Install necessary dependencies
RUN pip install pyyaml psycopg2

# Command to run the producer script
CMD ["python", "/app/main.py"]
