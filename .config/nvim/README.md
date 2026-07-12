# Neovim config

Neovim 0.12 以降を前提にした軽量構成です。
plugin manager は `lazy.nvim` ではなく builtin の `vim.pack` を使います。

主な方針:

- plugin 定義は `lua/plugin_registry.lua` に集約する。
- plugin 設定は `lua/plugins/specs/*.lua` に分ける。
- feature 単位と plugin 単位の on/off を `default_config.json` / `.nvim/config.json` で制御する。
- 補完は `blink.cmp` / `nvim-cmp` ではなく Neovim builtin LSP completion を使う。
- Treesitter parser install は `tree-sitter-manager.nvim`、runtime は builtin `vim.treesitter.start()` を使う。
- 起動を複雑にしすぎず、default では必要な plugin だけを素直に読み込む。

## Requirements

- Neovim 0.12+
- `git`
- `rg`
- C compiler
- `tree-sitter` CLI
- 必要に応じて `yazi`, `codex`, `uv`, formatter 各種

CI では Neovim `v0.12.4` AppImage、`tree-sitter-cli@0.26.10`、`stylua v2.5.2`、`luacheck` で smoke test します。

## Entry Points

| Path | Role |
| --- | --- |
| `init.lua` | 起動時の基本 option、provider 無効化、色、plugin 読み込み |
| `default_config.json` | 既定の feature/plugin/language 設定 |
| `lua/config/init.lua` | JSONC 対応 config loader |
| `lua/plugin_registry.lua` | `vim.pack` 用 plugin registry |
| `lua/plugins.lua` | registry を解決して `vim.pack.add()` と setup を実行 |
| `lua/plugins/specs/*.lua` | 各 plugin の設定 |
| `lua/features/treesitter.lua` | builtin Treesitter runtime 設定 |
| `lua/python_env.lua` | Python interpreter resolver |
| `nvim-pack-lock.json` | `vim.pack` lock file |

## Config System

既定値は `default_config.json` です。
プロジェクト配下に `.nvim/config.json` があれば、上位ディレクトリを探索してマージします。

JSONC コメントに対応しています。

```jsonc
{
  "features": {
    "debug": { "enabled": true },
    "treesitter": { "context": true },
    "ai": {
      "copilot": { "enabled": true }
    }
  },
  "plugins": {
    "nvim-treesitter-context": { "enabled": true }
  }
}
```

解決順:

1. VSCode などの実行環境制約
2. plugin 個別 override
3. feature group / subfeature
4. default config

`:ConfigInfo` で default/local config の検出状態を確認できます。

## Features

### LSP

LSP runtime は builtin の `vim.lsp.config()` / `vim.lsp.enable()` を使います。
server install 管理は `mason.nvim` / `mason-lspconfig.nvim` を使います。

既定の ensure install:

- `clangd`
- `pyright`
- `ruff`
- `jsonls`
- `bashls`
- `lua_ls`
- `texlab`

主なコマンド:

- `:PythonEnvInfo`
- `:PyrightClientInfo`
- `:BufferDiagnosticsInfo`

Python は `languages.python.resolver = "uv"` が既定です。
`.venv/bin/python` を優先し、見つからない場合は `activated` resolver に fallback します。
pyright には `pythonPath`, `venvPath`, `venv`, `extraPaths`, `cmd_env` を渡します。

### Completion

補完は builtin LSP completion を使います。

既定:

- auto trigger 有効
- manual trigger: `<C-Space>`
- confirm: `<C-y>`
- `completeopt=menuone,noinsert,popup`
- `pumborder=rounded`
- `pumblend=8`
- LSP kind icon 表示あり

`noselect` は使っていません。
そのため、候補 menu が出た状態で `<C-y>` を押すと先頭候補を確定できます。

補完 popup の色は `features.ui.completion_popup` で調整します。

### Inline Completion / Copilot

`copilot-language-server` は opt-in です。
default では起動しません。

有効化例:

```jsonc
{
  "features": {
    "ai": {
      "copilot": {
        "enabled": true
      }
    }
  }
}
```

有効化すると Mason ensure / `vim.lsp.enable()` に `copilot` が追加されます。
Copilot の sign-in/out command は `nvim-lspconfig` の `copilot` config が提供します。

- `:LspCopilotSignIn`
- `:LspCopilotSignOut`

inline completion key:

| mode | key | action |
| --- | --- | --- |
| insert | `<C-f>` | accept inline completion |
| insert | `<M-[>` | previous inline completion |
| insert | `<M-]>` | next inline completion |

### Treesitter

Parser install/update は `tree-sitter-manager.nvim` を使います。
Highlight runtime は plugin に任せず、FileType autocmd で builtin `vim.treesitter.start()` を呼びます。

Commands:

- `:TreesitterInstallConfigured`
- `:TreesitterUpdateConfigured`
- `:TreesitterBufferInfo`

Notes:

- `jsonc` filetype には `json` parser を登録します。
- `typescriptreact` filetype には `tsx` parser を登録します。
- `latex` parser は現状 build が不安定なため初期 install 対象から外しています。
- `tree-sitter-manager.nvim` の Git 呼び出し差異を吸収する runtime patch があります。

`nvim-treesitter-textobjects` は継続します。
`nvim-treesitter-context` は default off です。

### Search / File

- `telescope.nvim` を継続利用します。
- `yazi.nvim` を継続利用します。

### Git

継続:

- `gitsigns.nvim`
- `diffview.nvim`
- `gitlinker.nvim`

削除:

- `messenger.nvim`

`gitlinker.nvim` は VSCode Neovim でも有効です。
`diffview.nvim` は command 起動のみで、新規 shortcut は追加していません。

### Terminal

`toggleterm.nvim` を使います。
Zellij 連携は削除しました。

| mode | key | action |
| --- | --- | --- |
| normal | `<leader>z` | default shell terminal |
| normal | `<leader>cx` | `codex` terminal |

### Format

`conform.nvim` を継続します。

- format on save 有効
- manual format: `<space>f`
- LSP format は fallback

Python は `ruff_fix + ruff_format` を優先し、なければ `isort + black` に fallback します。

### UI

継続:

- `incline.nvim`
- `nvim-web-devicons`
- builtin `vim` colorscheme
- popup border

削除:

- greeter/dashboard
- animation/smooth scroll
- minimap/scrollbar
- bufferline/statusline plugin
- window manager plugin

`incline.nvim` は shell の `Ctrl-x Ctrl-e` などで 1 行目の長い command を編集するケースに配慮し、短い shell buffer の 1 行目では隠すようにしています。

### Editing

`autoclose.nvim` は継続します。

### Debug

DAP 系は default off で registry に残しています。

有効化例:

```jsonc
{
  "features": {
    "debug": {
      "enabled": true
    }
  }
}
```

有効化される plugin:

- `nvim-dap`
- `nvim-dap-ui`
- `nvim-dap-virtual-text`
- `nvim-dap-python`
- `nvim-nio`

主な key:

| mode | key | action |
| --- | --- | --- |
| normal | `<leader>d` | DAP UI toggle |
| normal | `<leader>w` | add watch |
| normal | `<leader><leader>df` | eval |
| normal | `<F5>` | continue |
| normal | `<F10>` | step over |
| normal | `<F11>` | step into |
| normal | `<F12>` | step out |
| normal | `<leader>b` | toggle breakpoint |
| normal | `<leader>bc` | conditional breakpoint |
| normal | `<leader>l` | log point |
| normal | `<leader>dc` | close DAP REPL |

## Keymaps

`<leader>` は `,` です。

### Common

| mode | key | action |
| --- | --- | --- |
| normal | `\` | `,` として扱う |
| terminal | `<ESC>` | terminal mode から normal mode |
| normal / insert / command | `<D-v>` | Goneovim paste |

### LSP

| mode | key | action |
| --- | --- | --- |
| normal | `gD` | declaration |
| normal | `gd` | definition |
| normal | `K` | hover |
| normal | `gh` | references |
| normal | `gi` | implementation |
| normal | `<C-k>` | signature help |
| normal | `<space>wa` | add workspace folder |
| normal | `<space>wr` | remove workspace folder |
| normal | `<space>wl` | list workspace folders |
| normal | `<space>D` | type definition |
| normal | `<space>rn` | rename |
| normal | `<space>ca` | code action |
| normal | `<leader>cd` | line diagnostic float |
| normal | `[d` | previous diagnostic |
| normal | `]d` | next diagnostic |
| insert | `<C-Space>` | manual LSP completion |

### Telescope

| mode | key | action |
| --- | --- | --- |
| normal | `<leader>ff` | files |
| normal | `<leader>fgr` | live grep |
| normal | `<leader>fgs` | git status |
| normal | `<leader>fb` | buffers |
| normal | `<leader>fh` | help tags |
| normal | `<leader>fq` | quickfix |
| normal | `<leader>fd` | diagnostics |
| normal | `gr` | LSP references |
| normal | `<leader>gr` | LSP references |
| normal | `<leader>fre` | registers |

### Yazi

| mode | key | action |
| --- | --- | --- |
| normal / visual | `<leader>-` | open Yazi at current file |
| normal | `<leader>cw` | open Yazi at cwd |
| normal | `<C-Up>` | resume/toggle last Yazi session |

### Git

| mode | key | action |
| --- | --- | --- |
| normal | `]c` | next hunk |
| normal | `[c` | previous hunk |
| normal / visual | `<leader>hs` | stage hunk |
| normal / visual | `<leader>hr` | reset hunk |
| normal | `<leader>hS` | stage buffer |
| normal | `<leader>hu` | undo stage hunk |
| normal | `<leader>hR` | reset buffer |
| normal | `<leader>hp` | preview hunk |
| normal | `<leader>hb` | line blame |
| normal | `<leader>tb` | toggle line blame |
| normal | `<leader>hd` | diff this |
| normal | `<leader>hD` | diff against `~` |
| normal | `<leader>td` | toggle deleted |
| operator / visual | `ih` | hunk text object |
| normal / visual | `<leader>gb` | open line/range URL |
| normal | `<leader>gY` | copy repository URL |
| normal | `<leader>gB` | open repository URL |

### Treesitter Textobjects

| mode | key | action |
| --- | --- | --- |
| visual / operator | `af` | function outer |
| visual / operator | `if` | function inner |
| visual / operator | `ac` | class outer |
| visual / operator | `ic` | class inner |
| visual / operator | `as` | scope |
| normal / visual / operator | `]f` | next function start |
| normal / visual / operator | `]F` | next function end |
| normal / visual / operator | `[f` | previous function start |
| normal / visual / operator | `[F` | previous function end |

`[c` / `]c` は gitsigns 用に残し、Treesitter class movement には使いません。

## CI

GitHub Actions workflow:

- `.github/workflows/neovim.yml`

Checks:

- download Neovim `v0.12.4` x86_64 AppImage
- extract AppImage and run `AppRun`
- install `tree-sitter-cli@0.26.10`
- install `stylua v2.5.2`
- install `luacheck`
- `stylua --check`
- `luacheck`
- default config headless smoke
- feature-rich config headless smoke
- Python Treesitter parser install/build/load/parse/query/textobjects smoke

Local equivalents:

```sh
/home/user/.cargo/bin/stylua --check --config-path .config/nvim/stylua.toml \
  .config/nvim/init.lua .config/nvim/essential.lua .config/nvim/lua .github/scripts/nvim_smoke.lua

/home/user/.luarocks/bin/luacheck \
  .config/nvim/init.lua .config/nvim/essential.lua .config/nvim/lua .github/scripts/nvim_smoke.lua

NVIM_SMOKE_SCENARIO=default nvim --headless -u .config/nvim/init.lua \
  +'luafile .github/scripts/nvim_smoke.lua' +qa!
```

## Notes

Migration notes are kept under:

- `docs/notes/202607_vim_pack_migration_.md`
