# White Lobster — Clean Debian + Ollama + LocalGPT + code-server + Apache
# CPU-only, minimal, everything from scratch

FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# ============================================
# 1. Base system packages
# ============================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    ca-certificates \
    gnupg \
    git \
    build-essential \
    pkg-config \
    libssl-dev \
    cmake \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    apache2 \
    sqlite3 \
    jq \
    htop \
    procps \
    nano \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# ============================================
# 2. Install Ollama (binary download — install.sh fails in Docker)
# ============================================
RUN apt-get update && apt-get install -y --no-install-recommends zstd \
    && curl -fsSL https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tar.zst -o /tmp/ollama.tar.zst \
    && mkdir -p /tmp/ollama-extract \
    && tar --use-compress-program=unzstd -xf /tmp/ollama.tar.zst -C /tmp/ollama-extract \
    && cp /tmp/ollama-extract/bin/ollama /usr/local/bin/ollama \
    && chmod +x /usr/local/bin/ollama \
    && cp -r /tmp/ollama-extract/lib/ollama /usr/lib/ollama 2>/dev/null || true \
    && rm -rf /tmp/ollama.tar.zst /tmp/ollama-extract \
    && rm -rf /var/lib/apt/lists/*

# ============================================
# 3. Install Rust + LocalGPT
# ============================================
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install --git https://github.com/localgpt-app/localgpt.git --no-default-features

# ============================================
# 4. Install code-server (VS Code in browser)
# ============================================
RUN curl -fsSL https://code-server.dev/install.sh | sh

# ============================================
# 5. Configure Apache
# ============================================
RUN a2enmod proxy proxy_http rewrite headers
# Apache will serve whatever the model builds at /var/www/html

# ============================================
# 6. Create workspace
# ============================================
# Allow pip install without venv (Debian Bookworm blocks it by default)
RUN printf "[global]\nbreak-system-packages = true\n" > /etc/pip.conf

RUN mkdir -p /workspace /root/.localgpt/workspace
WORKDIR /workspace

# ============================================
# 7. Startup script
# ============================================
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh /scripts/*.py
# Stage workspace files (volume may mount over /workspace, so keep copies)
COPY challenge-prompt.md /opt/whitelobster/challenge-prompt.md
COPY scripts/TOOLS_GUIDE.md /opt/whitelobster/TOOLS_GUIDE.md
COPY scripts/MEMORY.md /opt/whitelobster/MEMORY.md
COPY localgpt-config.toml /root/.localgpt/config.toml

EXPOSE 11434 8585 8443 80

ENTRYPOINT ["/scripts/entrypoint.sh"]
