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

### Running with Custom Commands

To run Sedrila with specific commands:

```bash
docker run -it sedrila [command]
```

For example:

```bash
docker run -it sedrila --version
```

### Mounting Local Directories

To access local files from within the container, you can mount directories:

```bash
docker run -it -v $(pwd):/data sedrila
```

This mounts your current working directory to `/data` inside the container.

## License

See the [Sedrila repository](https://github.com/fubinf/sedrila.git) for license information.