build VERSION:
  docker run \
    --platform linux/arm64 \
    --rm \
    -v ./:/workspace \
    -w /workspace \
    swift:{{VERSION}} \
    bash -cl "swift build"