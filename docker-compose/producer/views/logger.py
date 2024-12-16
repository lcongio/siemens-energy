import logging

# Set up basic logging configuration
logging.basicConfig(level=logging.INFO,  # Log all levels INFO and above
                    format='%(asctime)s [%(levelname)s] %(message)s')

# Function to log info messages
def log_info(message):
    logging.info(message)

# Function to log warning messages
def log_warning(message):
    logging.warning(message)

# Function to log error messages
def log_error(message):
    logging.error(message)
