FROM rustembedded/cross:armv7-unknown-linux-gnueabihf

COPY openssl.sh /
RUN bash /openssl.sh linux-armv4 arm-linux-gnueabihf- 

RUN apt-get install ca-certificates -y

ENV OPENSSL_DIR=/build/openssl
ENV OPENSSL_INCLUDE_DIR=/build/openssl/include
ENV OPENSSL_LIB_DIR=/build/openssl/lib
ENV PKG_CONFIG_PATH=/build/openssl/lib/pkgconfig
