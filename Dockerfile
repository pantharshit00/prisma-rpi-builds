FROM rustembedded/cross:armv7-unknown-linux-gnueabihf

COPY openssl.sh /
RUN bash /openssl.sh linux-armv4 arm-linux-gnueabihf- 

ENV OPENSSL_DIR=/openssl \
    OPENSSL_INCLUDE_DIR=/openssl/include \
    OPENSSL_LIB_DIR=/openssl/lib \
