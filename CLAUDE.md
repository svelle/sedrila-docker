# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository provides a Docker container for running [Sedrila](https://github.com/fubinf/sedrila.git), a self-directed learning assistant. The container is based on Alpine Linux and uses Poetry for Python dependency management. The container clones the Sedrila repository at build time and sets up a command-line interface to run Sedrila from within Docker.

## Building and Testing

```bash
# Build the Docker image
docker build -t sedrila .

# Rebuild with latest Sedrila code (bypasses Docker cache to re-clone repository)
docker build --no-cache -t sedrila .

# Run the container (shows help)
docker run -it sedrila

# Run with mounted directory for local file access
docker run -it -v $(pwd):/data sedrila

# Example: Author mode with current directory mounted
docker run -it --rm -p 8077:8077 -v "$(pwd)":/data sedrila author --include_stage beta out

# Enable verbose debugging output
docker run -it -e SEDRILA_VERBOSE=1 sedrila

# Open a shell inside the container for debugging
docker run -it --entrypoint /bin/bash sedrila
```

## Architecture

### Docker Image Structure

- **Base Image**: Alpine Linux (minimal footprint)
- **Package Manager**: Uses `pipx` to install Poetry globally
- **Working Directory**: `/app` contains the cloned Sedrila repository
- **Data Mount**: The container expects a `/data` directory for mounting local files; the entrypoint script automatically switches to `/data` if it exists
- **Entrypoint**: Custom shell script at `/usr/local/bin/sedrila` that:
  - Activates Poetry's virtual environment
  - Changes to `/data` if mounted (for volume support)
  - Runs the Sedrila Python application with all passed arguments
  - Supports verbose debugging via `SEDRILA_VERBOSE` environment variable

### Build Dependencies

The Dockerfile installs several build tools required for Python packages with native extensions:
- `gcc`, `g++`, `musl-dev`, `python3-dev`: C/C++ compilation
- `freetype-dev`, `libpng-dev`, `openblas-dev`: Graphics and numerical libraries
- `build-base`, `meson`, `cmake`: Build systems

These are needed by Sedrila's Python dependencies (likely matplotlib, numpy, or similar scientific packages).

## CI/CD Workflows

### docker-build.yml
Runs on every push to `main` and on manual trigger. Builds the Docker image and pushes it to GitHub Container Registry (ghcr.io) with tags:
- `latest` (for main branch)
- Short commit SHA

### docker-build-release.yml
More comprehensive workflow for releases, triggered by:
- Push of version tags (pattern: `v*`)
- Pull requests to main
- Manual workflow dispatch with optional version tag input

Features:
- Builds and pushes Docker images with semantic versioning tags
- Creates Git tags when manually triggered with a tag input
- Generates changelog using `mikepenz/release-changelog-builder-action`
- Creates GitHub releases with the generated changelog

When creating a release manually via workflow dispatch, provide a version tag like `v1.0.0`.

## Important Notes

- The Sedrila repository is cloned at Docker build time, not runtime. To update Sedrila to the latest version, rebuild the Docker image with `--no-cache` to force a fresh clone: `docker build --no-cache -t sedrila .`
- The container exposes port 8077 for Sedrila's web interface (used in author mode).
- Volume mounting at `/data` is the standard way to provide local files to the containerized Sedrila.
