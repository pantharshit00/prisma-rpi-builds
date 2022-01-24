# most steps taken from: https://stackoverflow.com/questions/60821697/how-to-build-openssl-for-arm-linux
FROM debian:stretch

ENV PATH=/root/.cargo/bin:$PATH

RUN apt-get update && apt-get -y install wget curl git make build-essential clang libz-dev libsqlite3-dev openssl libssl-dev pkg-config gzip mingw-w64 g++ libmpc-dev libmpfr-dev libgmp-dev gcc-arm-linux-gnueabihf libc6-dev-armhf-cross g++-arm-linux-gnueabihf libmagic-dev

# cross compile OpenSSL
# latest version can be found here: https://www.openssl.org/source/
ENV OPENSSL_VERSION=openssl-1.0.2u
ENV DOWNLOAD_SITE=https://www.openssl.org/source/old/1.0.2
RUN wget $DOWNLOAD_SITE/$OPENSSL_VERSION.tar.gz && tar zxf $OPENSSL_VERSION.tar.gz
RUN cd $OPENSSL_VERSION && ./Configure linux-armv4 --cross-compile-prefix=/usr/bin/arm-linux-gnueabihf- --prefix=/opt/openssl-arm --openssldir=/opt/openssl-arm -static && make install
# This env var configures rust-openssl to use the cross compiled version
ENV OPENSSL_DIR=/opt/openssl-arm

ENV ZLIB_VERSION=1.2.11
RUN echo "Building zlib" && \
    cd /tmp && \
    curl -fLO "http://zlib.net/zlib-$ZLIB_VERSION.tar.gz" && \
    tar xzf "zlib-$ZLIB_VERSION.tar.gz" && cd "zlib-$ZLIB_VERSION" && \
    CHOST=arm CC=/usr/bin/arm-linux-gnueabihf-gcc \
    AR=/usr/bin/arm-linux-gnueabihf-ar RANLIB=/usr/bin/arm-linux-gnueabihf-ranlib \
    ./configure --static --prefix=/opt/zlib && \
    make && make install && \
    rm -r /tmp/*

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN rustup target add armv7-unknown-linux-gnueabihf
RUN rustup component add clippy

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc
ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_RUNNER="/linux-runner armv7"
ENV CC_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-gcc
ENV CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++
ENV QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf
ENV LIBZ_SYS_STATIC=1 

