FROM debian:stretch

ENV PATH=/root/.cargo/bin:$PATH


RUN apt-get update && apt-get -y install wget curl git make build-essential clang libz-dev libsqlite3-dev openssl libssl-dev pkg-config gzip mingw-w64 g++ zlib1g-dev libmpc-dev libmpfr-dev libgmp-dev gcc-arm-linux-gnueabihf

ENV OPENSSL_VERSION=openssl-1.1.1h
ENV DOWNLOAD_SITE=https://www.openssl.org/source
RUN wget $DOWNLOAD_SITE/$OPENSSL_VERSION.tar.gz && tar zxf $OPENSSL_VERSION.tar.gz
RUN cd $OPENSSL_VERSION && ./Configure linux-armv4 --cross-compile-prefix=/usr/bin/arm-linux-gnueabihf- --prefix=/opt/openssl-arm --openssldir=/opt/openssl-arm -static && make install

ENV OPENSSL_DIR=/opt/openssl-arm


# compile zlib

ARG ZLIB_VERSION=1.2.11
RUN echo "Building zlib" && \
    cd /tmp && \
    curl -fLO "http://zlib.net/zlib-$ZLIB_VERSION.tar.gz" && \
    tar xzf "zlib-$ZLIB_VERSION.tar.gz" && cd "zlib-$ZLIB_VERSION" && \
    CHOST=arm CC=/usr/bin/arm-linux-gnueabihf-gcc \
    AR=/usr/bin/arm-linux-gnueabihf-ar RANLIB=/usr/bin/arm-linux-gnueabihf-ranlib \
    ./configure --static --prefix=/opt/zlib && \
    make && make install && \
    rm -r /tmp/*

ENV LIBZ_SYS_STATIC=1

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN rustup target add armv7-unknown-linux-gnueabihf
RUN rustup component add clippy

ENV CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc \
    CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABIHF_RUNNER=qemu-arm \
    CC_arm_unknown_linux_gnueabihf=arm-linux-gnueabihf-gcc \
    CXX_arm_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++ \
    QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf/arm-linux-gnueabihf/libc \
    LD_LIBRARY_PATH=/usr/arm-linux-gnueabihf/arm-linux-gnueabihf/libc/lib:/usr/arm-linux-gnueabihf/arm-linux-gnueabihf/lib:/usr/arm-linux-gnueabihf/lib \
    RUST_TEST_THREADS=1
