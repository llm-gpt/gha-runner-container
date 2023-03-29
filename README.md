# GitHub Actions Runner on Red Hat Universal Base Image (UBI)

This repository provides a Dockerfile to create a container with the GitHub Actions Runner using Red Hat Universal Base Image (UBI) 8-minimal.

## Usage

1. Build the Docker image:

   ```
   docker build -t your-image-name:latest .
   ```

2. Run the Docker container:

   Replace `YOUR_REPO_URL` with your GitHub repository URL and `YOUR_PERSONAL_ACCESS_TOKEN` with your GitHub personal access token.

   ```
   docker run -d --name github-runner \
     -e REPO_URL=YOUR_REPO_URL \
     -e TOKEN=YOUR_PERSONAL_ACCESS_TOKEN \
     your-image-name:latest
   ```

   To use image already built to GitHub Container Registry: ghcr.io/kaovilai/gha-runner-container
   ```
   docker run -d --name github-runner \
     -e REPO_URL=YOUR_REPO_URL \
     -e TOKEN=YOUR_PERSONAL_ACCESS_TOKEN \
     ghcr.io/kaovilai/gha-runner-container:latest
    ```
