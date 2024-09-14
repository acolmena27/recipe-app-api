FROM python:3.9-alpine3.13
LABEL maintainer="recipe-app-api"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Install dependencies
RUN apk add --no-cache gcc musl-dev python3-dev libffi-dev openssl-dev

# Create a virtual environment and install dependencies
RUN python -m venv /py
RUN /py/bin/pip install --upgrade pip
RUN /py/bin/pip install -r /tmp/requirements.txt

# Add a non-root user and change ownership of the /app directory
RUN adduser --disabled-password --no-create-home django-user && \
    chown -R django-user:django-user /app

# Install development dependencies if DEV is true
ARG DEV=false
RUN if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi

ENV PATH="/py/bin:$PATH"

# Set the default user to django-user
USER django-user