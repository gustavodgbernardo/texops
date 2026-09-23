# TeX environment shared by VS Code (Dev Container), local builds and CI.
# Pinning the Debian release pins the TeX Live version, so every machine
# produces the same PDF.
FROM debian:trixie-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        texlive-latex-base \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-fonts-recommended \
        texlive-publishers \
        texlive-science \
        texlive-pictures \
        texlive-plain-generic \
        texlive-bibtex-extra \
        biber \
        latexmk \
        latexdiff \
        chktex \
        git \
        make \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# The workspace is mounted from the host, so its owner differs from the
# container user. Trust it so git commands (used by latexdiff) work.
RUN git config --system --add safe.directory '*'

# Non-root user for the Dev Container (UID is remapped to the host user).
RUN useradd --create-home --uid 1000 --shell /bin/bash writer
USER writer

WORKDIR /workspace
