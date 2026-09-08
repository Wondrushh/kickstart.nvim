FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG NVIM_VERSION=v0.12.5

RUN apt-get update && \
    apt-get install -y \
        bash \
        git \
        curl \
        ca-certificates \
        build-essential \
        ripgrep \
        fd-find \
        unzip \
        gzip \
        tar \
        nodejs \
        npm \
        python3 \
        python3-pip \
        python3-venv \
        python3-debugpy \
        python3-pytest \
        cargo \
        rustc && \
    rm -rf /var/lib/apt/lists/*

# Ubuntu names fd "fdfind"
RUN ln -s /usr/bin/fdfind /usr/local/bin/fd

# Install modern Neovim instead of Ubuntu's old 0.9.5 package
RUN curl -L \
      "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz" \
      -o /tmp/nvim.tar.gz && \
    tar -C /opt -xzf /tmp/nvim.tar.gz && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim.tar.gz

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN set -eux; \
    existing_user="$(getent passwd "${USER_ID}" | cut -d: -f1 || true)"; \
    existing_group="$(getent group "${GROUP_ID}" | cut -d: -f1 || true)"; \
    \
    if [ -n "$existing_group" ]; then \
        groupmod --new-name dev "$existing_group"; \
    else \
        groupadd --gid "${GROUP_ID}" dev; \
    fi; \
    \
    if [ -n "$existing_user" ]; then \
        usermod \
            --login dev \
            --home /home/dev \
            --move-home \
            --gid "${GROUP_ID}" \
            --shell /bin/bash \
            "$existing_user"; \
    else \
        useradd \
            --uid "${USER_ID}" \
            --gid "${GROUP_ID}" \
            --create-home \
            --home-dir /home/dev \
            --shell /bin/bash \
            dev; \
    fi

RUN git clone https://github.com/Wondrushh/kickstart.nvim \
      /home/dev/.config/nvim && \
    chown -R dev:dev /home/dev/.config

USER dev
WORKDIR /workspace

CMD ["/bin/bash"]
