# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables for non-interactive apt-get installs
ENV DEBIAN_FRONTEND=noninteractive

# Update apt, install build-essential, wget, bzip2, and ca-certificates
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    bzip2 \
    ca-certificates \
    # Clean up apt cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Define the ARM GCC toolchain version and download URL
ARG ARM_GCC_VERSION="14.2.Rel1"
ARG ARM_GCC_TARBALL="arm-gnu-toolchain-14.2.Rel1-x86_64-arm-none-eabi.tar.xz"
ARG ARM_GCC_DOWNLOAD_URL="https://developer.arm.com/-/media/Files/downloads/gnu/14.2.Rel1/binrel/${ARM_GCC_TARBALL}"
ARG ARM_GCC_INSTALL_DIR="/opt/arm-gnu-toolchain"

# Download, extract, and clean up the ARM GCC toolchain
RUN wget ${ARM_GCC_DOWNLOAD_URL} -O /tmp/${ARM_GCC_TARBALL} && \
    mkdir -p ${ARM_GCC_INSTALL_DIR} && \
    tar -xJf /tmp/${ARM_GCC_TARBALL} -C ${ARM_GCC_INSTALL_DIR} --strip-components=1 && \
    rm /tmp/${ARM_GCC_TARBALL}

# Add the ARM GCC toolchain to the PATH
ENV PATH="${ARM_GCC_INSTALL_DIR}/bin:${PATH}"

# Set the working directory for future commands (e.g., when mounting source code)
WORKDIR /src

# Default command when a container starts (useful for interactive use)
CMD ["bash"]
