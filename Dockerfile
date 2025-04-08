FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
    bash \
    && pip3 install --no-cache-dir poetry

# Set working directory
WORKDIR /app

# Clone Sedrila repository
RUN git clone https://github.com/fubinf/sedrila.git . 

# Install sedrila using Poetry
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Set up sedrila command
RUN echo '#!/bin/sh\npython3 /app/py/sedrila.py "$@"' > /usr/local/bin/sedrila \
    && chmod +x /usr/local/bin/sedrila

# Default command
ENTRYPOINT ["sedrila"]
CMD ["--help"]