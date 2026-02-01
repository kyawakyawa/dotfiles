#! /bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.codex
if [ ! -e ~/.codex/AGENTS.md ]; then ln -s "$DOTFILES_DIR/.codex/AGENTS.md" ~/.codex/AGENTS.md ; else echo ~/.codex/AGENTS.md is exist; fi
