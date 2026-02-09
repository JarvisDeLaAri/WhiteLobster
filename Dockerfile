# White Lobster — Clean Debian + Ollama + LocalGPT + code-server + Apache
# CPU-only, minimal, everything from scratch

FROM debian:bookworm-slim

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
RUN curl -fsSL -o /usr/local/bin/ollama https://ollama.com/download/ollama-linux-amd64 \
    && chmod +x /usr/local/bin/ollama

# ============================================
# 3. Install Rust + LocalGPT
# ============================================
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install localgpt

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
