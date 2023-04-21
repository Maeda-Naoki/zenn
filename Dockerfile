# Base Docker image
FROM node:20.0.0-bullseye-slim

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
