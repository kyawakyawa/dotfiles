#!/bin/bash

# Install
# delta peco ripgrep ghq git-graph lazygit yazi fd

OUTDIR=${HOME}/bin/
BASH_CMP_D=${HOME}/.config/bash_completion.d

mkdir -p $OUTDIR
mkdir -p $BASH_CMP_D

TMPDIR=$(mktemp -d -p /tmp)
cd $TMPDIR

DELTA_LINUX_ARCH=x86_64 # aarch64
DELTA_VERSION=0.18.2

PECO_LINUX_ARCH=amd64 # arm64, arm
PECO_VERSION=v0.5.11

RG_LINUX_ARCH=x86_64 # armv7, aarch64
RG_VERSION=15.1.0

GHQ_LINUX_ARCH=amd64 # arm64
GHQ_VERSION=v1.8.0

LAZYGIT_LINUX_ARCH=x86_64 # arm64
LAZYGIT_VERSION=0.57.0

YAZI_LINUX_ARCH=x86_64 # aarch64
YAZI_VERSION=v25.5.31

FD_LINUX_ARCH=x86_64 # aarch64
FD_VERSION=v10.3.0

DELTA_URL=""
PECO_URL=""
RG_URL=""
GHQ_URL=""
LAZYGIT_URL=""
YAZI_URL=""
FD_URL=""

if [ "$(uname)" == 'Darwin' ]; then
  DELTA_URL=https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-aarch64-apple-darwin.tar.gz
  PECO_URL=https://github.com/peco/peco/releases/download/${PECO_VERSION}/peco_linux_${PECO_LINUX_ARCH}.tar.gz
  RG_URL=https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-aarch64-apple-darwin.tar.gz
  GHQ_URL=https://github.com/x-motemen/ghq/releases/download/${GHQ_VERSION}/ghq_darwin_arm64.zip
  LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_darwin_arm64.tar.gz"
  YAZI_URL="https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-aarch64-apple-darwin.zip"
  FD_URL="https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/fd-v10.3.0-aarch64-apple-darwin.tar.gz"
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then

  DELTA_URL=https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${DELTA_LINUX_ARCH}-unknown-linux-musl.tar.gz
  PECO_URL=https://github.com/peco/peco/releases/download/${PECO_VERSION}/peco_linux_amd64.tar.gz
  RG_URL=https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-${RG_LINUX_ARCH}-unknown-linux-musl.tar.gz
  GHQ_URL=https://github.com/x-motemen/ghq/releases/download/${GHQ_VERSION}/ghq_linux_${GHQ_LINUX_ARCH}.zip
  LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_${LAZYGIT_LINUX_ARCH}.tar.gz"
  YAZI_URL="https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-${YAZI_LINUX_ARCH}-unknown-linux-musl.zip"
  FD_URL="https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/fd-${FD_VERSION}-${FD_LINUX_ARCH}-unknown-linux-musl.tar.gz"
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

# delta
curl -LO $DELTA_URL 
# https://qiita.com/ksugimori/items/c61843d9353134b92cc7
tar zxvf $(basename $DELTA_URL)
cp $(basename $DELTA_URL .tar.gz)/delta $OUTDIR/

# PECO
curl -LO $PECO_URL 
if [ "$(uname)" == 'Darwin' ]; then
  unzip $(basename $PECO_URL)
  cp $(basename $PECO_URL .zip)/peco $OUTDIR/
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  tar zxvf $(basename $PECO_URL)
  cp $(basename $PECO_URL .tar.gz)/peco $OUTDIR/
fi

# RG
curl -LO $RG_URL 
tar zxvf $(basename $RG_URL)
cp $(basename $RG_URL .tar.gz)/rg $OUTDIR/
cp $(basename $RG_URL .tar.gz)/complete/rg.bash $BASH_CMP_D/

# GHQ
curl -LO $GHQ_URL 
unzip $(basename $GHQ_URL)
cp $(basename $GHQ_URL .zip)/ghq $OUTDIR/

# LAZYGIT
curl -LO $LAZYGIT_URL 
tar zxvf $(basename $LAZYGIT_URL)
cp ./lazygit $OUTDIR/

# YAZI
curl -LO $YAZI_URL
unzip $(basename $YAZI_URL)
cp $(basename $YAZI_URL .zip)/ya $OUTDIR/
cp $(basename $YAZI_URL .zip)/yazi $OUTDIR/
cp $(basename $YAZI_URL .zip)/completions/ya.bash $BASH_CMP_D/
cp $(basename $YAZI_URL .zip)/completions/yazi.bash $BASH_CMP_D/

# FD
curl -LO $FD_URL 
tar zxvf $(basename $FD_URL)
cp $(basename $FD_URL .tar.gz)/fd $OUTDIR/
cp $(basename $FD_URL .tar.gz)/autocomplete/fd.bash $BASH_CMP_D/

# Finalize
cd .. && rm -r $TMPDIR
