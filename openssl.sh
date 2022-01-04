set -ex

main() {
    local version=1.1.1m
    local os=$1 \
          triple=$2

    local dependencies=(
        ca-certificates
        curl
        m4
        make
        perl
    )

    # NOTE cross toolchain must be already installed
    apt-get update
    for dep in ${dependencies[@]}; do
        if ! dpkg -L $dep; then
            apt-get install --no-install-recommends -y $dep
        fi
    done

    td=$(mktemp -d)

    pushd $td
    curl --insecure https://www.openssl.org/source/openssl-$version.tar.gz | \
        tar --strip-components=1 -xz
    export AR=${triple}ar 
    export CC=${triple}gcc 
    ./Configure \
      --prefix=/build/openssl \
      no-dso \
      no-shared \
      no-ssl3 \
      no-tests \
      no-comp \
      no-zlib \
      no-zlib-dynamic \
      --libdir=lib \
      $os \
      ${@:3}
    nice make -j$(nproc)
    make install


    popd

    rm -rf $td
    rm $0
}

main "${@}"
