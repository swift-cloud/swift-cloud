build VERSION PLATFORM:
  docker run \
    --platform linux/arm64 \
    --rm \
    -v ./:/workspace \
    -w /workspace \
    swift:{{VERSION}}-{{PLATFORM}} \
    bash -cl "swift build"