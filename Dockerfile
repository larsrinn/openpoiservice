#--- BEGIN Usual Python stuff ---
FROM python:3.8.2-slim-buster
MAINTAINER Nils Nolde <nils@openrouteservice.org>

ENV POETRY_VERSION=1.0.5

WORKDIR /app

COPY pyproject.toml poetry.lock /app/

RUN apt-get update -y > /dev/null && \
    apt-get install -y build-essential > /dev/null && \
    pip install "poetry==$POETRY_VERSION" && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi && \
    apt purge -y build-essential && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

#--- END Usual Python stuff ---
COPY run.sh manage.py config_categories.yml wsgi.py /app/
COPY openpoiservice/. /app/openpoiservice

RUN mkdir -p /srv/app/conf

EXPOSE 5000

# Start gunicorn
ENTRYPOINT ["/bin/bash", "/app/run.sh"]
