# Base Docker image
FROM node:23.6.1-bookworm

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

# Run command
## Remove default user & Add user (Non-root user)
RUN groupdel -f node && userdel -r node && \
    groupadd -g ${GID} ${GroupName} && \
    adduser --uid ${UID} --gid ${GID} --home ${UserHomeDir} ${UserName}

# Install pnpm
## https://pnpm.io/ja/installation
RUN corepack enable && \
    corepack prepare pnpm@8.3.1 --activate

## Add node_modules directory data volume
RUN mkdir -p ${NodeModulesDir} && chown ${UID} ${NodeModulesDir}
VOLUME ${NodeModulesDir}

# Setup working user
USER ${UID}
WORKDIR ${UserHomeDir}

# Run bash
CMD ["/bin/bash"]
