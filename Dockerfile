FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    nasm \
    wget \
    golang-go \
    qtbase5-dev \
    libqt5websockets5-dev \
    python3-dev \
    mingw-w64 \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Go 1.21
RUN wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz -O /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

# Copy Havoc files
WORKDIR /app
COPY . .

# Fix go.mod version
RUN sed -i 's/go 1.21.0/go 1.21/' teamserver/go.mod

# Download and extract mingw cross-compilers
RUN mkdir -p data && \
    cd data && \
    wget -q https://musl.cc/x86_64-w64-mingw32-cross.tgz && \
    wget -q https://musl.cc/i686-w64-mingw32-cross.tgz && \
    tar xf x86_64-w64-mingw32-cross.tgz && \
    tar xf i686-w64-mingw32-cross.tgz && \
    rm *.tgz

# Build teamserver
RUN cd teamserver && \
    go mod tidy && \
    go build -ldflags="-s -w -X cmd.VersionCommit=$(git rev-parse HEAD 2>/dev/null || echo 'docker')" -o ../havoc main.go

# Set capabilities
RUN setcap 'cap_net_bind_service=+ep' havoc || true

# Expose port
EXPOSE 40056

# Run teamserver
CMD ["./havoc", "server", "--profile", "profiles/havoc.yaotl", "-v"]
