FROM python:3.9-slim

RUN apt update && apt install -y \
    build-essential libpq-dev vim

WORKDIR /app

COPY models /app/models
COPY views /app/views
COPY controllers /app/controllers
COPY main.py /app/

RUN pip install pyyaml psycopg2

CMD ["python", "/app/main.py"]
