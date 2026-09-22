# Base Docker image
FROM node:26.8.2-trixie-slim@sha256:f7bb8247fdb16250dbec7fd0e24f091c6f5f0a29d256f3aef5816a7a369166b2

# Metadata of Docker image
LABEL maintainer="maeda.naoki.md9@gmail.com"
LABEL version="1.0.0"

# Docker image args
## User setting
ARG GID=10000
ARG UID=10000
ARG GroupName="AuthorGroup"
ARG UserName="author"
ARG UserHomeDir="/home/author"

## Node modules setting
ARG NodeModulesDir="${UserHomeDir}/Article/node_modules"
ARG PnpmStoreDir="${UserHomeDir}/HomePage/.pnpm-store"

## pnpm setting
ARG PnpmVersion=12.4.0

# Docker image environment variables
## pnpm environment variables
ENV PNPM_HOME="${UserHomeDir}/.local/share/pnpm"
ENV PATH="${PNPM_HOME}:${PATH}"

# Run command
## Remove default user & Add user (Non-root user)
RUN groupdel -f node && userdel -r node && \
    groupadd -g ${GID} ${GroupName} && \
    adduser --uid ${UID} --gid ${GID} --home ${UserHomeDir} ${UserName}


# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
	sudo=1.9.16p2-3+deb13u2		\
	ca-certificates=20250419    \
    git=1:2.47.3-0+deb13u1      \
	curl=8.14.1-2+deb13u5       && \
	update-ca-certificates && \
	echo "${UserName} ALL=(ALL) NOPASSWD: /usr/bin/chown" > /etc/sudoers.d/${UserName} && \
	chmod 0440 /etc/sudoers.d/${UserName} && \
	rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER ${UID}

# Install pnpm
## https://pnpm.io/ja/installation
RUN curl -fsSL https://get.pnpm.io/install.sh | \
    env PNPM_VERSION=${PnpmVersion} SHELL="$(which bash)" bash -

# Setup working user
WORKDIR ${UserHomeDir}

# Run bash
CMD ["/bin/bash"]
