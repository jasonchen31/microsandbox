# Use Debian 10 (Buster) as the base image.
# Debian 10 is known to ship with GLIBC 2.28, ensuring compatibility.
FROM debian:10

# Set environment variables to prevent interactive prompts during package installation.
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install essential build tools.
# build-essential provides gcc, g++, make, libc-dev, etc.
# git is included for general development, though not strictly required if source is mounted.
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    # Clean up apt caches to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# (Optional) Verify the GLIBC version within the container.
# This command will print the GLIBC version when the container starts or when run manually.
# It's commented out by default but useful for debugging.
# RUN ldd --version

# Set the working directory inside the container.
# The project source code will be mounted into this directory by GitHub Actions.
WORKDIR /app

# The Docker image is now ready. The actual build commands will be run by GitHub Actions
# after mounting the source code.
