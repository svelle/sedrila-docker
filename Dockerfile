FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
    bash \
    pipx \
    gcc \
    g++ \
    musl-dev \
    python3-dev \
    freetype-dev \
    libpng-dev \
    openblas-dev \
    build-base \
    meson \
    cmake

# Install poetry using pipx
RUN pipx install poetry
RUN pipx ensurepath
ENV PATH="/root/.local/bin:$PATH"

# Set working directory
WORKDIR /app

# Clone Sedrila repository
RUN git clone https://github.com/fubinf/sedrila.git . 

# Install dependencies using Poetry's own virtual environment
RUN poetry install --no-interaction --no-ansi && \
    echo 'source $(poetry env info --path)/bin/activate' >> /root/.bashrc

# Set up sedrila command
RUN printf '#!/bin/sh\n\
# Get virtual environment path and run sedrila\n\
# Use SEDRILA_VERBOSE=1 to enable verbose output\n\
VENV_PATH=$(poetry env info --path)\n\
# Change to working directory if it exists (handles /data mount)\n\
if [ -d "/data" ]; then\n\
    cd /data\n\
fi\n\
if [ -n "$SEDRILA_VERBOSE" ]; then\n\
    set -x  # Print commands for debugging\n\
    echo "Using Python from: $VENV_PATH/bin/python"\n\
    echo "Current working directory: $(pwd)"\n\
    echo "Running: $VENV_PATH/bin/python /app/py/sedrila.py $*"\n\
fi\n\
$VENV_PATH/bin/python /app/py/sedrila.py "$@"\n' > /usr/local/bin/sedrila \
    && chmod +x /usr/local/bin/sedrila

# Default command
ENTRYPOINT ["sedrila"]
CMD ["--help"]