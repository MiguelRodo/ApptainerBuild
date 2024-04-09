#!/usr/bin/env bash
set -e
# install rust 
pushd /tmp
if [ -d "xet-core" ]; then
    rm -rf xet-core
fi
git clone https://github.com/xetdata/xet-core
cd xet-core
export RUSTUP_INIT_SKIP_PATH_CHECK=yes
apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    protobuf-compiler \
    clang \
    libclang-dev \
    cmake \
    libudev-dev \
    zlib1g-dev \
    libasound2-dev \
    libdbus-1-dev \
    libgtk-3-dev
curl --proto '=https' --tlsv1.2 -sSf -o rustup-init.sh https://sh.rustup.rs
sh rustup-init.sh -y
rm rustup-init.sh
cd rust
$HOME/.cargo/bin/cargo build --release --features openssl_vendored
mkdir -p /usr/local/bin
cp rust/target/release/git-xet /usr/local/bin/
git-xet install
popd
echo "xet-core installed"
