# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT=debian
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get upgrade -y \
    && apt-get install -y texlive-base texlive-latex-base texlive-pictures texlive-lang-polish texlive-latex-extra pandoc \
    && rm -rf /var/lib/apt/lists/*