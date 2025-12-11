# Sedrila Docker

A Docker container for running [Sedrila](https://github.com/fubinf/sedrila.git), a self-directed learning assistant.

## Building the Docker Image

To build the Docker image, run the following command in the directory containing the Dockerfile:

```bash
docker build -t sedrila .
```

To rebuild with the latest Sedrila code from the repository, use the `--no-cache` flag to force a fresh clone:

```bash
docker build --no-cache -t sedrila .
```

**Note:** The Sedrila repository is cloned during the Docker build process. Without `--no-cache`, Docker's layer caching will reuse the previously cloned version.

## Running the Container

Once the image is built, you can run Sedrila using:

```bash
docker run -it sedrila
```

### Using Sedrila as a Command on Your System

You can create an alias or shell function to use the Docker container as if it were installed locally:

Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
# For bash/zsh
sedrila() {
  docker run -it --rm -p 8077:8077 -v "$(pwd)":/data sedrila "$@"
}
```

Or for Windows (PowerShell):

```powershell
function sedrila {
  docker run -it --rm -p 8077:8077 -v "${PWD}:/data" sedrila $args
}
```

After adding this and restarting your shell (or running `source ~/.bashrc`), you can use Sedrila commands directly:

```bash
# Get help for a command
sedrila --help
```

### Author Mode Example

For course authors working in a propra directory:

```bash
# Run from within your propra directory
sedrila author --include_stage beta out
```

This will build the course website in the `out` directory of your propra folder.

### Mounting Local Directories

To access local files from within the container, you can mount directories:

```bash
docker run -it -v $(pwd):/data sedrila
```

This mounts your current working directory to `/data` inside the container. The container will automatically detect and use this mounted directory as the working directory.

### Debugging

If you're experiencing issues with the container, you can:

1. Enable verbose output:

```bash
docker run -it -e SEDRILA_VERBOSE=1 sedrila
```

2. Run a shell inside the container:

```bash
docker run -it --entrypoint /bin/bash sedrila
```

This will give you a bash shell inside the container where you can explore and debug.

## Release Process

This repository uses GitHub Actions to automatically build and publish Docker images to GitHub Container Registry (ghcr.io).

### Automatic Builds

Every push to the `main` branch triggers an automatic build that creates Docker images tagged with:
- `latest`
- Short commit SHA (e.g., `abc1234`)

### Creating a Release

To create a versioned release:

1. Go to the **Actions** tab in the GitHub repository
2. Select the **Build and Release Docker Image** workflow
3. Click **Run workflow**
4. Enter a version tag (e.g., `v1.0.0`)
5. Click **Run workflow**

This will:
- Create a Git tag with the specified version
- Build and push Docker images with semantic version tags (e.g., `v1.0.0`, `1.0`, `1`)
- Generate a changelog from commit messages
- Create a GitHub release with the changelog

### Using Released Images

Pull a specific version from GitHub Container Registry:

```bash
# Pull latest version
docker pull ghcr.io/OWNER/sedrila-docker:latest

# Pull specific version
docker pull ghcr.io/OWNER/sedrila-docker:v1.0.0
```

Replace `OWNER` with the repository owner's GitHub username or organization name.

## License

See the [Sedrila repository](https://github.com/fubinf/sedrila.git) for license information.