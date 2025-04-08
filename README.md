# Sedrila Docker

A Docker container for running [Sedrila](https://github.com/fubinf/sedrila.git), a self-directed learning assistant.

## Building the Docker Image

To build the Docker image, run the following command in the directory containing the Dockerfile:

```bash
docker build -t sedrila .
```

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
sedrila student --help

# With your current directory mounted to /data in the container
sedrila student /data
```

### Mounting Local Directories

To access local files from within the container, you can mount directories:

```bash
docker run -it -v $(pwd):/data sedrila
```

This mounts your current working directory to `/data` inside the container.

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

## License

See the [Sedrila repository](https://github.com/fubinf/sedrila.git) for license information.