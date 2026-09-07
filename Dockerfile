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

RUN useradd --create-home --shell /bin/bash dev

RUN git clone https://github.com/Wondrushh/kickstart.nvim \
      /home/dev/.config/nvim && \
    chown -R dev:dev /home/dev/.config

USER dev
WORKDIR /workspace

CMD ["/bin/bash"]
