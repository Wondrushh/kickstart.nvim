FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        bash \
        git \
        neovim \
        ripgrep \
        fd-find \
        curl \
        build-essential \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root development user
RUN useradd --create-home --shell /bin/bash dev

# Neovim expects its config here for the `dev` user
RUN git clone https://github.com/Wondrushh/kickstart.nvim \
    /home/dev/.config/nvim && \
    chown -R dev:dev /home/dev/.config

USER dev
WORKDIR /workspace

CMD ["/bin/bash"]
