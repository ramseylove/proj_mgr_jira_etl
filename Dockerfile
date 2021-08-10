# Pull base image
FROM python:3.7-slim-buster

ENV PATH="/scripts:${PATH}"

# Create and Set working directory
RUN useradd app -m -d /app

#expoose the port for dokku
EXPOSE 8000

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

# set work directory
WORKDIR /app

# Install dependencies
RUN apt-get update \
    && apt-get install gcc python3-dev libpq-dev -y  \
    && pip install --upgrade pip \
    && apt-get clean

# Copy project
COPY . /app/

RUN pip install -r reqs/dev-requirements.txt

RUN chmod +x /app/scripts/*

##run in container as unprivileged app user
USER app

ENTRYPOINT ["scripts/entrypoint.sh"]
################  Start New Image  :  Debugger  ############
# FROM base as debug
# RUN pipenv install ptvsd

# WORKDIR /code/
# CMD python -m ptvsd --host 0.0.0.0 --port 5678 --wait --multiprocess manage.py runserver 127.0.0.1:8000