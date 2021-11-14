FROM ubuntu:focal

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update
RUN apt install -y sudo locales curl gnupg2 git zsh

# Locale UTF8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add -
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list
RUN apt update
RUN apt install -y tailscale

# SSHD
RUN apt install -y openssh-server
RUN passwd -d root
RUN mkdir /var/run/sshd
COPY sshd_config /etc/ssh/sshd_config

# Docker
RUN apt update
RUN apt install -y ca-certificates curl gnupg lsb-release
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt update
RUN apt install -y docker-ce docker-ce-cli containerd.io

# Dotfiles
ADD https://api.github.com/repos/leighmcculloch/dotfiles/commits?per_page=1 /dev/null
RUN git clone https://github.com/leighmcculloch/dotfiles /root/.dotfiles
RUN cd /root/.dotfiles && ./install.sh

# Set default shell to ZSH
RUN chsh -s /usr/bin/zsh

ENV DEBIAN_FRONTEND="dialog"

COPY ./start.sh ./start.sh
CMD ["./start.sh"]
