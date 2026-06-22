#!/bin/bash

set -euo pipefail

# Install
# delta peco ripgrep ghq lazygit yazi fd bat xan broot pastel kubectl k9s

OUTDIR="${HOME}/bin"
BASH_CMP_D="${HOME}/.config/bash_completion.d"

mkdir -p "$OUTDIR"
mkdir -p "$BASH_CMP_D"

TMPDIR=$(mktemp -d -p /tmp)
trap 'rm -rf "$TMPDIR"' EXIT
cd "$TMPDIR"

OS=$(uname -s)
ARCH=$(uname -m)

case "$OS" in
  Darwin)
    PLATFORM=darwin
    ;;
  Linux)
    PLATFORM=linux
    ;;
  *)
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
    ;;
esac

case "$ARCH" in
  arm64|aarch64)
    TARGET_ARCH=aarch64
    ;;
  x86_64|amd64)
    TARGET_ARCH=x86_64
    ;;
  *)
    echo "Your architecture ($ARCH) is not supported."
    exit 1
    ;;
esac

if [ "$PLATFORM" = "darwin" ] && [ "$TARGET_ARCH" != "aarch64" ]; then
  echo "Only macOS arm64/aarch64 is supported."
  exit 1
fi

latest_release_tag() {
  local repo="$1"
  curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/${repo}/releases/latest" | sed 's#.*/##'
}

download_tar() {
  local url="$1"
  curl -fL -O "$url"
  tar zxf "$(basename "$url")"
}

download_zip() {
  local url="$1"
  curl -fL -O "$url"
  unzip -o "$(basename "$url")"
}

copy_if_exists() {
  local src="$1"
  local dst="$2"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
  fi
}

DELTA_VERSION=0.18.2
PECO_VERSION=v0.5.11
RG_VERSION=15.1.0
GH_VERSION=2.83.2
GHQ_VERSION=v1.8.0
LAZYGIT_VERSION=0.57.0
YAZI_VERSION=v25.5.31
FD_VERSION=v10.3.0

BAT_VERSION=$(latest_release_tag sharkdp/bat)
XAN_VERSION=$(latest_release_tag medialab/xan)
BROOT_VERSION=$(latest_release_tag Canop/broot)
PASTEL_VERSION=$(latest_release_tag sharkdp/pastel)
K9S_VERSION=$(latest_release_tag derailed/k9s)

DELTA_URL=""
PECO_URL=""
RG_URL=""
GH_URL=""
GHQ_URL=""
LAZYGIT_URL=""
YAZI_URL=""
FD_URL=""
BAT_URL=""
XAN_URL=""
BROOT_URL=""
PASTEL_URL=""
KUBECTL_URL=""
K9S_URL=""

if [ "$PLATFORM" = "darwin" ]; then
  DELTA_URL="https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-aarch64-apple-darwin.tar.gz"
  PECO_URL="https://github.com/peco/peco/releases/download/${PECO_VERSION}/peco_darwin_arm64.zip"
  RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-aarch64-apple-darwin.tar.gz"
  GH_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_macOS_arm64.zip"
  GHQ_URL="https://github.com/x-motemen/ghq/releases/download/${GHQ_VERSION}/ghq_darwin_arm64.zip"
  LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_darwin_arm64.tar.gz"
  YAZI_URL="https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-aarch64-apple-darwin.zip"
  FD_URL="https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/fd-${FD_VERSION}-aarch64-apple-darwin.tar.gz"
  BAT_URL="https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION}-aarch64-apple-darwin.tar.gz"
  XAN_URL="https://github.com/medialab/xan/releases/download/${XAN_VERSION}/xan-aarch64-apple-darwin.tar.gz"
  BROOT_URL="https://github.com/Canop/broot/releases/download/${BROOT_VERSION}/broot_${BROOT_VERSION#v}.zip"
  PASTEL_URL="https://github.com/sharkdp/pastel/releases/download/${PASTEL_VERSION}/pastel-${PASTEL_VERSION}-aarch64-apple-darwin.tar.gz"
else
  DELTA_LIBC=$([ "$TARGET_ARCH" = "aarch64" ] && echo gnu || echo musl)
  DELTA_URL="https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${TARGET_ARCH}-unknown-linux-${DELTA_LIBC}.tar.gz"
  PECO_ARCH=$([ "$TARGET_ARCH" = "aarch64" ] && echo arm64 || echo amd64)
  PECO_URL="https://github.com/peco/peco/releases/download/${PECO_VERSION}/peco_linux_${PECO_ARCH}.tar.gz"
  RG_LIBC=$([ "$TARGET_ARCH" = "aarch64" ] && echo gnu || echo musl)
  RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-${TARGET_ARCH}-unknown-linux-${RG_LIBC}.tar.gz"
  GH_ARCH=$([ "$TARGET_ARCH" = "aarch64" ] && echo arm64 || echo amd64)
  GH_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${GH_ARCH}.tar.gz"
  GHQ_ARCH=$([ "$TARGET_ARCH" = "aarch64" ] && echo arm64 || echo amd64)
  GHQ_URL="https://github.com/x-motemen/ghq/releases/download/${GHQ_VERSION}/ghq_linux_${GHQ_ARCH}.zip"
  LAZYGIT_ARCH=$([ "$TARGET_ARCH" = "aarch64" ] && echo arm64 || echo x86_64)
  LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_${LAZYGIT_ARCH}.tar.gz"
  YAZI_URL="https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-${TARGET_ARCH}-unknown-linux-musl.zip"
  FD_URL="https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/fd-${FD_VERSION}-${TARGET_ARCH}-unknown-linux-musl.tar.gz"
  BAT_URL="https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION}-${TARGET_ARCH}-unknown-linux-$([ "$TARGET_ARCH" = "aarch64" ] && echo gnu || echo musl).tar.gz"
  XAN_URL="https://github.com/medialab/xan/releases/download/${XAN_VERSION}/xan-${TARGET_ARCH}-unknown-linux-gnu.tar.gz"
  BROOT_URL="https://github.com/Canop/broot/releases/download/${BROOT_VERSION}/broot_${BROOT_VERSION#v}.zip"
  if [ "$TARGET_ARCH" = "aarch64" ]; then
    echo "Skipping pastel: Linux aarch64 release asset is not published as of ${PASTEL_VERSION}."
  else
    PASTEL_URL="https://github.com/sharkdp/pastel/releases/download/${PASTEL_VERSION}/pastel-${PASTEL_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
  fi
fi

KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
KUBECTL_ARCH=$([ "$TARGET_ARCH" = "aarch64" ] && echo arm64 || echo amd64)
KUBECTL_URL="https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${PLATFORM}/${KUBECTL_ARCH}/kubectl"

K9S_OS=$([ "$PLATFORM" = "darwin" ] && echo Darwin || echo Linux)
K9S_ARCH=$([ "$TARGET_ARCH" = "aarch64" ] && echo arm64 || echo amd64)
K9S_URL="https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_${K9S_OS}_${K9S_ARCH}.tar.gz"

# delta
download_tar "$DELTA_URL"
cp "$(basename "$DELTA_URL" .tar.gz)/delta" "$OUTDIR/"

# PECO
if [ "$PLATFORM" = "darwin" ]; then
  download_zip "$PECO_URL"
  cp "$(basename "$PECO_URL" .zip)/peco" "$OUTDIR/"
else
  download_tar "$PECO_URL"
  cp "$(basename "$PECO_URL" .tar.gz)/peco" "$OUTDIR/"
fi

# RG
download_tar "$RG_URL"
cp "$(basename "$RG_URL" .tar.gz)/rg" "$OUTDIR/"
copy_if_exists "$(basename "$RG_URL" .tar.gz)/complete/rg.bash" "$BASH_CMP_D/"

# GH
if [ "$PLATFORM" = "darwin" ]; then
  download_zip "$GH_URL"
else
  download_tar "$GH_URL"
fi
cp "$(basename "$GH_URL" | sed -E 's/\.(tar\.gz|zip)$//')/bin/gh" "$OUTDIR/"

# GHQ
download_zip "$GHQ_URL"
cp "$(basename "$GHQ_URL" .zip)/ghq" "$OUTDIR/"

# LAZYGIT
download_tar "$LAZYGIT_URL"
cp "./lazygit" "$OUTDIR/"
rm -f ./lazygit

# YAZI
download_zip "$YAZI_URL"
cp "$(basename "$YAZI_URL" .zip)/ya" "$OUTDIR/"
cp "$(basename "$YAZI_URL" .zip)/yazi" "$OUTDIR/"
copy_if_exists "$(basename "$YAZI_URL" .zip)/completions/ya.bash" "$BASH_CMP_D/"
copy_if_exists "$(basename "$YAZI_URL" .zip)/completions/yazi.bash" "$BASH_CMP_D/"

# FD
download_tar "$FD_URL"
cp "$(basename "$FD_URL" .tar.gz)/fd" "$OUTDIR/"
copy_if_exists "$(basename "$FD_URL" .tar.gz)/autocomplete/fd.bash" "$BASH_CMP_D/"

# BAT
download_tar "$BAT_URL"
cp "$(basename "$BAT_URL" .tar.gz)/bat" "$OUTDIR/"
copy_if_exists "$(basename "$BAT_URL" .tar.gz)/autocomplete/bat.bash" "$BASH_CMP_D/"

# XAN
download_tar "$XAN_URL"
cp "./xan" "$OUTDIR/"
rm -f ./xan

# BROOT
download_zip "$BROOT_URL"
if [ "$PLATFORM" = "darwin" ]; then
  BROOT_DIR="aarch64-apple-darwin"
else
  BROOT_DIR="${TARGET_ARCH}-unknown-linux-gnu"
fi
cp "${BROOT_DIR}/broot" "$OUTDIR/"
copy_if_exists "completion/broot.bash" "$BASH_CMP_D/"

# PASTEL
if [ -n "$PASTEL_URL" ]; then
  download_tar "$PASTEL_URL"
  cp "$(basename "$PASTEL_URL" .tar.gz)/pastel" "$OUTDIR/"
fi

# KUBECTL
curl -fL -o kubectl "$KUBECTL_URL"
chmod +x kubectl
cp kubectl "$OUTDIR/"
"$OUTDIR/kubectl" completion bash > "$BASH_CMP_D/kubectl"

# K9S
download_tar "$K9S_URL"
cp ./k9s "$OUTDIR/"
rm -f ./k9s
"$OUTDIR/k9s" completion bash > "$BASH_CMP_D/k9s"
