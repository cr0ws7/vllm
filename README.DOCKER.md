# vllm Docker notes

This document shows how to build and run the repository in Docker/Podman and
options to store images privately or as filesystem backups.

Quick build (Docker):

```bash
# build image
docker build -t vllm:local .

# run (mount your models directory)
docker run --gpus all -p 8000:8000 -v $(pwd)/models:/models:ro \
  -e MODEL_PATH=qwen3-14b-gptq vllm:local
```

Quick build (Podman):

```bash
podman build -t vllm:local .
podman run --security-opt=label=disable --device /dev/kfd:/dev/kfd --device /dev/dri:/dev/dri \
  -p 8000:8000 -v $(pwd)/models:/models:ro -e MODEL_PATH=qwen3-14b-gptq vllm:local
```

Using docker-compose:

```bash
docker-compose up --build
```

Storing images privately
- GitHub Container Registry (ghcr.io): you can push private images to GitHub if you
  enable Packages on your account. Example:

```bash
# login
echo $GITHUB_TOKEN | docker login ghcr.io -u <github-user> --password-stdin
# tag and push
docker tag vllm:local ghcr.io/<github-user>/vllm:latest
docker push ghcr.io/<github-user>/vllm:latest
```

- Docker Hub: create a private repository and push similarly.

Storing images on the filesystem (backups)
- Save an image as a tarball. This is portable and easy to back up:

```bash
docker save -o vllm_local.tar vllm:local
# restore on another machine
docker load -i vllm_local.tar
```

- Podman: podman save/load use the same commands and format.

Notes and tips
- Models are large — keep them outside the image and mount at /models to avoid
  rebuilding for each model change.
- Use a private registry (GHCR or Docker Hub private repos) for easier sharing
  across machines. GitHub's Packages support private images with a normal
  GitHub account (you'll need a PAT with write:packages scope).
- To save space on the host, compress the saved tarball with gzip.
