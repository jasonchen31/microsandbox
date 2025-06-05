# Use Debian 10 (Buster) as the base image.
# Debian 10 is known to ship with GLIBC 2.28, ensuring compatibility.
FROM debian:10

# Set environment variables to prevent interactive prompts during package installation.

ENV DEBIAN_FRONTEND=noninteractive
# Install Rust and Cargo non-interactively
# -s: Read commands from standard input
# --: Treat all subsequent arguments as non-options (for the script)
# -y: Disable confirmation prompt (answer "yes" to all questions)
# --no-modify-path: Do not modify the PATH environment variable in the shell's profile files.
#                   We'll set PATH explicitly in the Dockerfile.
RUN apt-get update && apt-get install -y curl
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y 
ENV CARGO_HOME="/root/.cargo"
ENV PATH="$CARGO_HOME/bin:$PATH"
RUN find / -name rustc
RUN find / -name cargo
RUN rustc --version
RUN cargo --version

# Update the package list and install essential build tools.
# build-essential provides gcc, g++, make, libc-dev, etc.
# git is included for general development, though not strictly required if source is mounted.
# python3 and python3-pip are added for Python 3 and its package installer.
# patchelf, bc, libelf-dev, flex, bison, and curl are added as requested.
RUN apt-get install -y \
    build-essential \
    git \
    python3 \
    python3-pip \
    patchelf \
    bc \
    libelf-dev \
    flex \
    bison \
    curl \
    # Clean up apt caches to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pyelftools using pip3.
# pyelftools is a Python library for analyzing ELF files, which might be relevant
# for projects dealing with executables and their structure.
RUN pip3 install pyelftools

# (Optional) Verify the GLIBC version within the container.
# This command will print the GLIBC version when the container starts or when run manually.
# It's commented out by default but useful for debugging.
# RUN ldd --version

# Set the working directory inside the container.
# The project source code will be mounted into this directory by GitHub Actions.
RUN mkdir /app && mkdir /app/build
WORKDIR /app

# The Docker image is now ready. The actual build commands will be run by GitHub Actions
# after mounting the source code.
