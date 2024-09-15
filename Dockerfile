FROM python:3.9-alpine3.13
LABEL maintainer="recipe-app-api"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Update repositories and install dependencies
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev \
    postgresql-client \
    build-base \
    postgresql-dev

# Create a virtual environment and install dependencies
RUN python -m venv /py
RUN /py/bin/pip install --upgrade pip

# Install Python dependencies
RUN /py/bin/pip install -r /tmp/requirements.txt

# Remove build dependencies
RUN apk del build-base postgresql-dev

# Add a non-root user and change ownership of the /app directory
RUN adduser --disabled-password --no-create-home django-user && \
    chown -R django-user:django-user /app

# Install development dependencies if DEV is true
ARG DEV=false
RUN if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi

ENV PATH="/py/bin:$PATH"

# Set the default user to django-user
USER django-user