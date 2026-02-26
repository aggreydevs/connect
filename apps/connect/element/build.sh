#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

IMAGE_NAME="element-build"
CONTAINER_NAME="element-tmp"

echo "Building Element Web production image..."
docker build -f Dockerfile.prod -t "$IMAGE_NAME" .

echo "Extracting static files..."
docker create --name "$CONTAINER_NAME" "$IMAGE_NAME"
rm -rf dist
docker cp "$CONTAINER_NAME":/app ./dist
docker rm "$CONTAINER_NAME"
docker rmi "$IMAGE_NAME"

echo "Done. Static files are in ./dist/"
echo "Deploy this directory to Cloudflare Pages."
