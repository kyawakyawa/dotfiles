# Neovim vim.pack migration notes

このメモは、2026-07 の Neovim 0.12 向け大幅改修で検討した論点と意思決定の記録です。
実装後の運用情報は `.config/nvim/README.md` を正とし、このファイルは背景・棚卸し・移行判断のアーカイブとして管理します。
「候補」「要検討」「次に詰める」といった表現は、検討当時の状態を残したものです。

## 現在の到達点

- `lazy.nvim` から builtin `vim.pack` へ移行済み。
- plugin registry は `lua/plugin_registry.lua` に集約済み。
- plugin setup は `lua/plugins/specs/*.lua` に分割済み。
- config loader は JSONC 対応済み。
- `blink.cmp` / `nvim-cmp` 系は削除し、builtin LSP completion に移行済み。
- completion popup は `rounded` border、`pumblend=8`、LSP kind icon 付き。
- `textDocument/inlineCompletion` は Copilot opt-in として実装済み。
- Treesitter parser install は `tree-sitter-manager.nvim`、runtime は builtin `vim.treesitter.start()` に分離済み。
- `tree-sitter-manager.nvim` の Git 引数差異に対する runtime patch を追加済み。
- `jsonc` は `json` parser、`typescriptreact` は `tsx` parser に登録済み。
- `latex` parser は build 問題があるため初期 install 対象外。
- Python resolver は `uv` default、`.venv` 優先、`activated` fallback。
- pyright は `.venv` の `pythonPath` / `venvPath` / `extraPaths` / `cmd_env` を反映済み。
- `toggleterm.nvim` は Zellij 連携を削除し、default shell と `codex` terminal に変更済み。
- DAP 系は registry に残し、`features.debug.enabled = false` の default off。
- Copilot は `features.ai.copilot.enabled = false` の opt-in。
- GitHub Actions で Neovim 0.12.4 AppImage smoke、Treesitter parser build、`stylua --check`、`luacheck` を実行する。

## 目的

Neovim 0.12 以降の builtin 機能を前提に、現在の `.config/nvim` を軽量化・単純化する。

主な動機:

- builtin で賄える範囲が増えたため、依存プラグインを減らす。
- AI Agent 利用が増え、Neovim は「長時間コードを書く環境」より「素早く開いて確認・修正する環境」として使う比重が高い。
- プラグイン数を減らし、遅延読み込みや複雑な起動最適化への依存を下げる。

当初検討していた大きな置き換え:

- `lazy.nvim` -> `vim.pack`
- `blink.cmp` / `nvim-cmp` -> native completion
- Treesitter parser のインストールは `tree-sitter-manager.nvim` を使い、起動や設定は Neovim 0.12 builtin の `vim.treesitter` に寄せる

継続利用の意向があるもの:

- `telescope.nvim`
- `yazi.nvim`
- `toggleterm.nvim`
- Zellij 連携はやめて、default shell を素早く立てる方針にする。

## 実装済み構成

初期実装では `lazy.nvim` から `vim.pack` へ移行し、プラグイン定義を `lua/plugin_registry.lua` に集約する。
各プラグインの設定は `lua/plugins/specs/*.lua` に分け、feature 単位・plugin 単位の on/off は `default_config.json` と project local `.nvim/config.json` で制御する。

| 領域 | 採用方針 | 実装メモ |
| --- | --- | --- |
| plugin manager | `vim.pack` | `lua/plugins.lua` が registry を読み、依存と feature/plugin override を解決する。 |
| config system | JSONC 対応 | `vim.json.decode(..., { skip_comments = true })` を使い、local config は `.nvim/config.json`。 |
| completion | native completion | `blink.cmp` / `nvim-cmp` 系は削除。`<C-Space>` manual、`<C-y>` confirm、snippet は既定 off。 |
| LSP | builtin LSP + Mason | `vim.lsp.config()` / `vim.lsp.enable()` を使い、server install 管理は Mason を継続。 |
| Python | config 切替 | 既定は `uv`、`.venv` がなければ `activated` に fallback。`manual` / `system` も選択可能。 |
| Treesitter | builtin runtime + manager install | parser install/update は `tree-sitter-manager.nvim`、起動は FileType autocmd から `vim.treesitter.start()`。 |
| Git | `gitsigns.nvim`, `diffview.nvim`, `gitlinker.nvim` | `messenger.nvim` は削除。`diffview` はコマンド起動のみ。`gitlinker` は VSCode Neovim でも有効。 |
| terminal | `toggleterm.nvim` | `<leader>z` は default shell、`<leader>cx` は `codex`。Zellij 連携は削除。 |
| format | `conform.nvim` | format on save と `<space>f` を維持。LSP format は fallback。 |
| UI | `incline.nvim` + builtin theme | `nvim-web-devicons` は維持。greeter/animation/minimap/scrollbar/window UI は削除。 |
| editing | `autoclose.nvim` | builtin に完全同等がないため継続。 |
| debug | `nvim-dap` 系 | 既定 off で registry に残す。必要な project/local config で有効化する。 |

現在の plugin registry:

| Plugin | Feature | 方針 |
| --- | --- | --- |
| `plenary.nvim` | dependency | Telescope/Yazi/gitlinker 用。 |
| `nvim-web-devicons` | `ui.icons` | incline/Telescope/Yazi 用に維持。 |
| `mason.nvim` | `lsp.server_manager` | LSP server install 管理。 |
| `mason-lspconfig.nvim` | `lsp.server_manager` | Mason と builtin LSP の接続。 |
| `nvim-lspconfig` | `lsp.runtime` | server 定義を利用。 |
| `telescope.nvim` | `search.picker` | 継続。 |
| `yazi.nvim` | `file.explorer` | 継続。 |
| `incline.nvim` | `ui.status` | 継続。1行目が長い shell edit では隠す。 |
| `gitsigns.nvim` | `git.signs` | 継続。既存 keymap 維持。 |
| `diffview.nvim` | `git.diff_view` | 継続。追加 shortcut は作らない。 |
| `gitlinker.nvim` | `git.linker` | 継続。VSCode Neovim でも有効。 |
| `autoclose.nvim` | `editing.autoclose` | 継続。 |
| `tree-sitter-manager.nvim` | `treesitter.parser_manager` | install/update 用。 |
| `nvim-treesitter-textobjects` | `treesitter.textobjects` | 継続。`[f/]f/[F/]F` を維持し、`[c/]c` は使わない。 |
| `nvim-treesitter-context` | `treesitter.context` | 既定 off。必要なら config で有効化。 |
| `toggleterm.nvim` | `terminal` | default shell と Codex 起動。 |
| `conform.nvim` | `format` | 継続。 |
| `nvim-dap` | `debug` | 既定 off。DAP 本体と keymap。 |
| `nvim-dap-ui` | `debug.ui` | 既定 off。DAP UI。 |
| `nvim-dap-virtual-text` | `debug.virtual_text` | 既定 off。inline value 表示。 |
| `nvim-dap-python` | `debug.python` | 既定 off。Python debug adapter 設定。 |
| `nvim-nio` | dependency | `nvim-dap-ui` 依存。 |

Treesitter parser install の注意:

- `jsonc` は `tree-sitter-manager.nvim` の repo 定義に存在しないため install 対象から外し、`json` parser を `jsonc` filetype に登録する。
- `typescriptreact` は `tsx` parser に登録する。
- `latex-lsp/tree-sitter-latex` は現行定義だと `tree-sitter build` 時に `src/parser.c` が見つからず失敗するため、初期 install 対象から外す。LaTeX の Treesitter 化は個別に再検討する。

## 棚卸しの見方

このドキュメントでは、各機能を「残す」「builtin 等へ置き換える」「廃止する」の意思決定がしやすいように並べる。

| 列 | 意味 |
| --- | --- |
| 状態 | `有効`, `条件付き`, `休眠`, `builtin`, `独自設定` のいずれか |
| 現状の役割 | 現在この設定が提供している機能 |
| 利用判断 | 今後 `残す` / `置換` / `廃止` / `要検討` を記入する欄 |
| 置き換え候補・論点 | builtin 置換候補、継続理由、削除時の影響など |
| メモ | キーマップ、依存、衝突、VSCode 分岐など |

## 改修前に有効だったプラグイン

旧 `plugins.lua` から読み込まれていたもの、および旧 `default_config.json` の既定値で有効だったもの。

| プラグイン | 状態 | 現状の役割 | 利用判断 | 置き換え候補・論点 | メモ |
| --- | --- | --- | --- | --- | --- |
| `lazy.nvim` | 有効 | プラグインマネージャ。bootstrap、lazy loading、lock 管理を担当。 | 置換候補 | `vim.pack` へ移行する本命。遅延読み込み前提の指定をどこまで残すか整理が必要。 | `lua/plugins.lua` 冒頭で clone して `require("lazy").setup()`。 |
| `mason.nvim` | 有効 | LSP server 等のインストール管理。 | 要検討 | LSP 管理は現状維持候補。builtin LSP とは役割が異なる。 | `mason-lspconfig.nvim` の dependency。 |
| `mason-lspconfig.nvim` | 有効 | Mason と builtin LSP 設定の接続、LSP の ensure install。 | 要検討 | Mason 継続なら残す候補。Neovim 0.12 の `vim.lsp.config/enable` との責務分担を再確認。 | `automatic_enable = false`、`ensure_installed` を使用。 |
| `nvim-lspconfig` | 有効 | LSP server 定義の提供。 | 要検討 | 0.12 の builtin LSP だけで足りるか検討。server 定義を自前化するなら削減可能だが保守負荷あり。 | 設定本体は `vim.lsp.config()` / `vim.lsp.enable()` を使用。 |
| `blink.cmp` | 条件付き有効 | 補完 UI / source / fuzzy matcher。既定 engine。 | 置換候補 | Neovim native completion へ移行する本命。LSP, path, buffer, snippets 相当の扱いを確認。 | `plugins.complement.enabled = true`, `engine = "blink-cmp"`。 |
| `friendly-snippets` | 条件付き有効 | `blink.cmp` の snippet source 用。 | 置換候補 | native completion 移行時に snippet を使うか決める。使わないなら削除。 | `blink.cmp` dependency。 |
| `telescope.nvim` | 有効 | find files, live grep, buffers, help, quickfix, diagnostics, registers, LSP references。 | 残す方針 | 継続利用予定。builtin picker が十分なら将来再検討。 | `<leader>ff`, `<leader>fgr`, `<leader>fb`, `gr` など。 |
| `plenary.nvim` | 有効 | Telescope, yazi, gitlinker の共通 dependency。 | 残す方針 | 依存元が残る限り必要。 | 直接機能ではなく依存。 |
| `yazi.nvim` | 条件付き有効 | yazi を Neovim 内から開くファイラ連携。 | 残す方針 | 継続利用予定。netrw 置換はしていない。 | `plugins.file_explorer.name = "yazi"`。`<leader>-`, `<leader>cw`, `<C-Up>`。 |
| `incline.nvim` | 有効 | バッファ名、変更状態、Git 差分、診断数、アイコンを表示する軽量 UI。 | 残す | 軽量で実用的。1行目の長文に被る問題は改善対象。 | `gitsigns.nvim`, `nvim-web-devicons` に依存。 |
| `nvim-web-devicons` | 有効 | filetype icon 表示。 | 残す | `incline.nvim` を残すため維持。Telescope/Yazi でも使われうる。 | `incline.nvim` dependency。 |
| `gitsigns.nvim` | 有効 | Git hunk sign、hunk 移動、stage/reset、preview、blame、diff、deleted toggle。 | 要検討 | builtin sign + `git` コマンドで一部代替可能だが、操作 UI はプラグイン継続が現実的。 | `]c/[c`, `<leader>h*`, `<leader>tb`, `ih`。Treesitter textobjects と `[c/]c` が衝突。 |
| `messenger.nvim` | 有効 | GitHub notifications 表示。 | 廃止 | 不要。新 config では default off にし、実装移行時に削除候補として扱う。 | 現状は `<leader>gm`。 |
| `diffview.nvim` | 有効 | Git diff / history UI。 | 要検討 | builtin `:diffsplit`, `nvim.difftool`, fugitive 系なし運用で足りるか確認。 | float panel 設定あり。 |
| `gitlinker.nvim` | 有効 | 現在行・選択範囲・repository URL を取得/ブラウザで開く。 | 要検討 | `gh browse` や自作 Lua で代替可能。VSCode でも有効。 | `<leader>gb`, `<leader>gY`, `<leader>gB`。 |
| `autoclose.nvim` | 有効 | 括弧・クォートの自動 close。 | 残す | builtin には完全同等がないため継続。 | 新 config では `features.editing.autoclose` / `plugins["autoclose.nvim"].enabled` で制御。 |
| `nvim-treesitter` | 有効 | 現状は parser install/update と filetype ごとの `vim.treesitter.start()` を担当。 | 置換候補 | parser install/update は `tree-sitter-manager.nvim` へ移行し、起動・highlight 設定は Neovim 0.12 builtin の `vim.treesitter` で行う。 | `branch = "main"`。`:MyTSInstall` あり。VSCode でも有効。改修後は削除候補。 |
| `tree-sitter-manager.nvim` | 新規導入候補 | Tree-sitter parser の install/remove/update と管理 UI。 | 追加候補 | インストール用途に限定して使う。`highlight`/FileType autocmd などの実行時設定はできるだけ無効または最小化し、Neovim builtin 側で `vim.treesitter.start()` する。 | `romus204/tree-sitter-manager.nvim`。Neovim 0.12+、tree-sitter CLI、git、C compiler が必要。`vim.pack` 対応あり。 |
| `nvim-treesitter-context` | 有効 | 現在スコープの context を画面上部に表示。 | 要検討 | 便利機能。軽量化優先なら削除候補。 | `max_lines = 5`。 |
| `nvim-treesitter-textobjects` | 有効 | function/class/scope textobject と移動。 | 要検討 | builtin textobject では代替困難。AI 確認・修正用途で必要か判断。 | `af/if/ac/ic/as`, `]f/[f`, `]c/[c`。`gitsigns` と `[c/]c` 衝突。 |
| `toggleterm.nvim` | 有効 | 現状は floating terminal で Zellij session を起動。 | 残す方針 | Zellij 連携は廃止し、default shell を簡単に開く用途へ変更する。複数 terminal の扱いも追加検討。 | 現状は `<leader>z` で `zellij attach -c <cwd>-neovim`。改修後の keymap は要設計。 |
| `conform.nvim` | 有効 | format on save と手動 format。formatter 選択。 | 残す | builtin LSP formatting だけでは外部 formatter 選択・chain・fallback を置き換えきれない。 | Python は `ruff_fix + ruff_format` or `isort + black`。JSON/C++/CUDA/Lua/YAML 対応。 |

## 条件付き・休眠中のプラグイン候補

設定ファイルはあるが、現在の `plugins.lua` ではコメントアウトされているもの、または `default_config.json` の既定では選ばれないもの。
大幅改修では、まず「今後も候補として残すか」「設定ファイルごと削除するか」を決める。

| プラグイン | 状態 | 現状の役割 | 利用判断 | 置き換え候補・論点 | メモ |
| --- | --- | --- | --- | --- | --- |
| `nvim-cmp` | 休眠/条件付き | 旧補完 engine。 | 廃止候補 | native completion 移行なら削除。比較検証用に一時保持するかだけ判断。 | `plugins.complement.engine = "nvim-cmp"` で選択可能。 |
| `lspkind.nvim` | 休眠/条件付き | `nvim-cmp` の補完 item 表示装飾。 | 廃止候補 | `nvim-cmp` を消すなら不要。 | `nvim-web-devicons` に依存。 |
| `cmp-nvim-lsp` | 休眠/条件付き | `nvim-cmp` の LSP source。 | 廃止候補 | native completion へ移行するなら不要。 |  |
| `cmp-nvim-lsp-signature-help` | 休眠/条件付き | `nvim-cmp` の signature help source。 | 廃止候補 | builtin `vim.lsp.buf.signature_help` / native UI を検討。 |  |
| `cmp-buffer` | 休眠/条件付き | buffer completion source。 | 廃止候補 | native completion の buffer 補完可否を確認。 |  |
| `cmp-path` | 休眠/条件付き | path completion source。 | 廃止候補 | native completion の path 補完可否を確認。 |  |
| `cmp-cmdline` | 休眠/条件付き | cmdline completion source。 | 廃止候補 | builtin cmdline completion で足りるか確認。 |  |
| `cmp-nvim-lsp-document-symbol` | 休眠/条件付き | document symbol completion source。 | 廃止候補 | 使用実績がなければ削除。 |  |
| `LuaSnip` | 休眠/条件付き | snippet engine。 | 廃止候補 | snippets を残すかどうか次第。 | `nvim-cmp` path のみ。 |
| `cmp_luasnip` | 休眠/条件付き | `LuaSnip` と `nvim-cmp` の接続。 | 廃止候補 | `nvim-cmp` / `LuaSnip` を消すなら不要。 |  |
| `neo-tree.nvim` | 休眠/条件付き | yazi 以外を選んだ場合の file explorer。 | 廃止候補 | yazi 継続なら削除候補。 | `plugins.file_explorer.name != "yazi"` の分岐。 |
| `nui.nvim` | 休眠/条件付き | neo-tree / hardtime 依存。 | 廃止候補 | 依存元を消すなら不要。 |  |
| `todo-comments.nvim` | 休眠 | TODO/FIXME などの強調・検索。 | 要検討 | Treesitter/builtin highlight だけで足りるか確認。 | `plugins_syntax_highlight.lua` は未 require。 |
| `vim-illuminate` | 休眠 | cursor word/reference highlight。 | 廃止候補 | LSP document highlight が既にあるため重複気味。 | `on_attach` で document highlight 設定済み。 |
| `nvim-dap` | 休眠 | Debug Adapter Protocol client。 | 残す/default off | `features.debug.enabled = true` で復活。AI Agent 主体では常時有効にしない。 | 新 registry に保持。 |
| `nvim-dap-ui` | 休眠 | DAP UI。 | 残す/default off | `debug.ui` で制御。 | `nvim-dap` 有効時の依存。 |
| `nvim-dap-virtual-text` | 休眠 | DAP の inline value 表示。 | 残す/default off | `debug.virtual_text` で制御。 |  |
| `nvim-dap-python` | 休眠 | Python DAP support。 | 残す/default off | `debug.python` で制御し、Python resolver の interpreter を使う。 |  |
| `nvim-nio` | 休眠 | `nvim-dap-ui` 依存。 | 残す/default off | 依存としてのみ導入。 |  |
| `transfer.nvim` | 休眠 | rsync upload/download、保存時 upload。 | 要検討 | 使用していなければ削除候補。CLI rsync で代替可能。 | `.nvim/deployment.lua` があると保存時 upload。 |
| `rest.nvim` | 休眠/既定無効 | REST client。 | 廃止候補 | 使用頻度が低ければ削除。`curl`/外部 client で代替可能。 | `plugins.rest.enabled = false`。 |
| `lua-json5` | 休眠 | JSON5 parse。 | 廃止候補 | Neovim 0.12 の `vim.json.decode(..., { skip_comments = true })` で JSONC 対応する方針。JSON5 ではなく JSONC に寄せる。 | cargo がある場合のみ追加する設定だが、改修後は不要になる見込み。 |
| `hardtime.nvim` | 休眠/既定無効 | Vim 操作訓練、入力制限。 | 廃止候補 | 現在の利用目的からは優先度低。 | `plugins.inputBehavior.hardtime.enabled = false`。 |
| `which-key.nvim` | 休眠 | keymap hint UI。 | 要検討 | キーマップ整理後に必要性を判断。軽量化なら削除候補。 | 未 require。 |
| `neoscroll.nvim` | 休眠/既定無効 | smooth scroll。 | 廃止候補 | 軽量化方針なら削除候補。 | `plugins.animation.enabled = false`。 |
| `specs.nvim` | 休眠/既定無効 | cursor jump animation。 | 廃止候補 | 軽量化方針なら削除候補。 | 多数の移動キーへ hook。 |
| `alpha-nvim` | 休眠 | greeter/dashboard。 | 廃止候補 | 「サクッと開く」方針とは相性が薄い。 | 未 require。 |
| `codewindow.nvim` | 休眠 | minimap。 | 廃止候補 | 確認・修正中心で必要性を再確認。 | 未 require。 |
| `nvim-scrollview` | 休眠 | scrollbar。 | 廃止候補 | builtin 代替なし。必要なければ削除。 | 未 require。 |
| `windows.nvim` | 休眠 | window resize/maximize 操作補助。 | 廃止候補 | builtin window command と keymap で足りる。 | `middleclass`, `animation.nvim` 依存。 |
| `middleclass` | 休眠 | `windows.nvim` 依存。 | 廃止候補 | 依存元と同時判断。 |  |
| `animation.nvim` | 休眠 | `windows.nvim` 依存。 | 廃止候補 | 依存元と同時判断。 |  |
| `lualine.nvim` | 休眠 | statusline。 | 廃止候補 | 現在は `incline.nvim` + `laststatus=3`。 | `lualine_cfg` は残存。 |
| `barbar.nvim` | 休眠 | bufferline。 | 廃止候補 | 現在は使っていない。 |  |
| `sidebar.nvim` | 休眠 | sidebar UI。 | 廃止候補 | 現在は使っていない。 |  |
| `sections-dap` | 休眠 | sidebar DAP section。 | 廃止候補 | sidebar/DAP と同時判断。 |  |
| `tokyonight.nvim` | 休眠 | colorscheme。 | 廃止候補 | 現在 `colorscheme vim`。テーマ候補を残すか判断。 | `plugins.lua` では色設定 block がコメントアウト。 |
| `solarized-osaka.nvim` | 休眠 | colorscheme。 | 廃止候補 | 現在 `colorscheme vim`。テーマ候補を残すか判断。 |  |
| `neovim-ayu` | 休眠 | colorscheme。 | 廃止候補 | 現在 `colorscheme vim`。テーマ候補を残すか判断。 |  |
| `indent-blankline.nvim` | 休眠/コメント | indent guide。 | 廃止候補 | builtin listchars 等で足りるか確認。 | `plugins_brackets.lua` 内コメント。 |
| `mini.indentscope` | 休眠/コメント | current indent scope 表示。 | 廃止候補 | 使用していなければ削除。 |  |
| `nvim-autopairs` | 休眠/コメント | bracket auto pair。 | 廃止候補 | `autoclose.nvim` を残すなら不要。 |  |
| `nvim-ts-rainbow` | 休眠/コメント | bracket rainbow highlight。 | 廃止候補 | 現在使っていない。 |  |
| `cmp-treesitter` | 休眠/コメント | Treesitter completion source。 | 廃止候補 | native completion 移行なら不要。 |  |

## 非プラグイン機能

`init.lua`, `essential.lua`, `util.lua`, `nvim_lsp_cfg/*` にある機能。
ユーザー方針として「基本的に残す」前提だが、移行時に壊しやすいので明示的に棚卸しする。

| 機能 | 状態 | 現状の役割 | 利用判断 | 置き換え候補・論点 | メモ |
| --- | --- | --- | --- | --- | --- |
| `vim.loader.enable()` | builtin | Lua module loading cache。 | 残す候補 | そのまま残す。 | 起動直後に有効化。 |
| 基本 editor options | builtin | 行番号、インデント、検索、カーソル行、`termguicolors`, `laststatus=3` など。 | 残す候補 | 整理して `options.lua` へ分離するか検討。 | `.vimrc` 的な中核設定。 |
| provider 無効化 | builtin | Python/Node/Perl/Ruby provider を無効化して起動を軽くする。 | 残す候補 | そのまま残す。 | Python provider を使う場合だけ再検討。 |
| leader 設定 | builtin | leader を `,` にし、`\` を `,` へ map。 | 残す候補 | そのまま残す。 | 既存 keymap の前提。 |
| 独自 config system | 独自設定 | `default_config.json` と project local `.nvim/config.json` を merge。 | 残す方針 | `vim.pack` 移行後も plugin 選択に使うなら維持。Neovim 0.12 の `vim.json.decode(..., { skip_comments = true })` で JSONC コメント対応を入れる。 | `:ConfigInfo` あり。現状は `vim.fn.json_decode` なのでコメント付き JSON は読めない。 |
| VSCode 分岐 | 独自設定 | VSCode Neovim では不要 plugin を読み込まない。 | 残す方針 | `vim.pack` 移行時の plugin load 条件を再設計。 | `util.add_plugin(..., { vscode = false/true })`。 |
| Goneovim 分岐 | 独自設定 | `<D-v>` paste keymap。 | 残す候補 | 利用継続なら維持。 | `lua/gui/goneovim.lua`。 |
| OpenCL filetype | builtin | `*.cl` を `cl` filetype に設定。 | 残す候補 | そのまま残す。 | LSP clangd の filetypes にも `cl`。 |
| terminal `<ESC>` map | builtin | terminal mode から normal mode へ戻る。 | 残す候補 | そのまま残す。 | VSCode では無効。 |
| colorscheme `vim` | builtin | デフォルト色。`SignColumn` と `NormalFloat` 背景を NONE。 | 残す候補 | popup border など 0.12 UI と合わせて調整。 | テーマ plugin は休眠。 |
| WSL clipboard | builtin/外部コマンド | `win32yank` で `+/*` register を Windows 側 clipboard と接続。 | 残す候補 | そのまま残す。 | WSL 判定は `/proc/version`。 |
| OS 別 IME off | 独自設定/外部コマンド | InsertLeave で IME を英数へ戻す。 | 残す候補 | `essential.lua` 側の executable check 付き実装へ寄せると堅い。 | WSL/Windows `zenhan`, macOS `im-select`, Linux `fcitx5-remote`。 |
| builtin `nvim.undotree` | builtin package | undo tree 機能を `packadd`。 | 要検討 | 使っているなら残す。keymap 有無を確認。 | `init.lua` と `essential.lua` で `packadd nvim.undotree`。 |
| builtin `nvim.difftool` | builtin package | diff tool 機能を `packadd`。 | 要検討 | `diffview.nvim` 代替になりうるか確認。 | `init.lua` のみ。 |
| LSP keymaps | builtin | definition, hover, references, rename, code action, diagnostic jump など。 | 残す候補 | Neovim 0.12 builtin defaults と重複するものを整理。 | LSP attach 時に設定。 |
| LSP diagnostics config | builtin | virtual text format, diagnostic sign icon。 | 残す候補 | 0.12 の UI 変更に合わせて見直し。 | `vim.diagnostic.config()`。 |
| LSP document highlight | builtin | cursor hold で symbol reference highlight。 | 残す候補 | `vim-illuminate` は削除候補。 | server capability がある場合のみ。 |
| Python env 検出 | 独自設定 | `python` 実行ファイルから base dir を取り、pyright に渡す。 | 要検討 | `.venv` / poetry 検出のコメントアウト実装と統合するか検討。 | 現状は shell command に依存。 |
| `essential.lua` | 独自設定 | 最小構成の Neovim 設定。 | 要検討 | 大幅改修後の fallback/minimal config として活用できる。 | plugin なしで provider/IME/builtin undotree を設定。 |

## 新 config system の方針

新バージョンでは、プラグイン単位の on/off と、機能グループ単位の on/off の両方を持つ。
グループ設定で大まかな機能を有効化し、必要に応じて個別プラグイン設定で上書きできる構造にする。

想定する優先順位:

1. VSCode / GUI / OS などの実行環境制約で読み込めないものは無効。
2. 個別プラグインの `enabled` が明示されていれば、それを優先。
3. 個別指定がなければ機能グループの `enabled` を使う。
4. どちらも未指定なら default config の値を使う。

設定例:

```jsonc
{
  "features": {
    "completion": { "enabled": true, "engine": "native" },
    "lsp": { "enabled": true, "manager": "mason" },
    "treesitter": { "enabled": true, "parser_manager": "tree-sitter-manager" },
    "search": { "enabled": true, "picker": "telescope" },
    "file": { "enabled": true, "explorer": "yazi" },
    "git": { "enabled": true },
    "format": { "enabled": true, "format_on_save": true },
    "terminal": { "enabled": true, "backend": "toggleterm" },
    "ui": { "enabled": true }
  },
  "plugins": {
    "telescope.nvim": { "enabled": true },
    "yazi.nvim": { "enabled": true },
    "gitsigns.nvim": { "enabled": true },
    "messenger.nvim": { "enabled": false },
    "nvim-treesitter-context": { "enabled": false }
  }
}
```

初期の機能グループ案:

| グループ | 含める候補 | 方針 |
| --- | --- | --- |
| `completion` | native completion, 旧 `blink.cmp` / `nvim-cmp` | 既定は native。旧 engine は移行中のみ残すか判断。 |
| `lsp` | builtin LSP, `mason.nvim`, `mason-lspconfig.nvim`, `nvim-lspconfig` | LSP 本体設定と server 管理を分けて扱えるようにする。 |
| `treesitter` | builtin `vim.treesitter`, `tree-sitter-manager.nvim`, textobjects/context | parser 管理と実行時設定を分ける。 |
| `search` | `telescope.nvim`, `plenary.nvim` | 継続利用。Telescope は LSP/Git からも picker として参照される。 |
| `file` | `yazi.nvim` | 継続利用。旧 `neo-tree.nvim` 分岐は削除候補。 |
| `git` | `gitsigns.nvim`, `diffview.nvim`, `gitlinker.nvim`, `messenger.nvim` | 使用頻度で個別 off しやすくする。 |
| `format` | `conform.nvim`, LSP format | conform 継続/削除の判断をしやすくする。 |
| `terminal` | `toggleterm.nvim`, builtin terminal | Zellij 廃止後の default shell 起動を扱う。 |
| `ui` | `incline.nvim`, `nvim-web-devicons`, `treesitter-context` | 装飾系をまとめて落とせるようにする。 |
| `debug` | DAP 系 | 既定 off 候補。 |
| `rest` | REST client | 既定 off 候補。 |
| `remote_transfer` | rsync/transfer | 既定 off 候補。 |

区割りを決めるための観点:

| 観点 | 内容 | 判断例 |
| --- | --- | --- |
| ユーザーがまとめて切りたい単位 | ローカル config で「この種類の機能はいらない」と指定しやすい粒度。 | `git = false` で Git UI をまとめて落とす。 |
| 実装上の依存単位 | ある plugin が別 plugin のためだけに必要な場合、ユーザー向け group とは別に依存として扱う。 | `plenary.nvim` は `fuzzy_finder` ではなく dependency。 |
| builtin への置換単位 | builtin に寄せる範囲と plugin に残す範囲が混ざらない粒度。 | `treesitter.parser_manager` と `treesitter.runtime` を分ける。 |
| 起動時に必要な単位 | 起動直後から必要なものと、コマンド実行時だけ必要なものを分ける。 | native completion/LSP 設定と Telescope/Yazi は読み込みタイミングが違う。 |
| VSCode でも必要な単位 | VSCode Neovim で有効にしたいものを分ける。 | `gitlinker.nvim` や textobjects は VSCode でも使う可能性がある。 |

現時点では、機能グループを「大分類」だけで完結させず、必要なものは subfeature を持たせる方針にする。

```jsonc
{
  "features": {
    "treesitter": {
      "enabled": true,
      "parser_manager": true,
      "highlight": true,
      "textobjects": true,
      "context": false
    },
    "git": {
      "enabled": true,
      "signs": true,
      "diff_view": true,
      "linker": true,
      "notifications": false
    },
    "ui": {
      "enabled": true,
      "status": true,
      "icons": true,
      "animations": false,
      "greeter": false
    }
  }
}
```

区割りの暫定案:

| 大分類 | サブ機能 | 対応候補 | 備考 |
| --- | --- | --- | --- |
| `core` | options, keymaps, clipboard, IME, config loader | builtin/独自設定 | plugin on/off とは独立して原則有効。 |
| `lsp` | runtime | builtin `vim.lsp` | LSP client 設定、keymap、diagnostic。 |
| `lsp` | server_manager | `mason.nvim`, `mason-lspconfig.nvim` | server install 管理。LSP runtime とは別。 |
| `completion` | runtime | native completion | 既定。snippet を入れるかは別サブ機能にする。 |
| `completion` | snippets | builtin/native snippet または plugin | snippet を使わない選択をしやすくする。 |
| `treesitter` | parser_manager | `tree-sitter-manager.nvim` | install/remove/update のみ plugin 依存。 |
| `treesitter` | runtime_highlight | builtin `vim.treesitter.start()` | FileType autocmd と start 対象を管理。 |
| `treesitter` | textobjects | `nvim-treesitter-textobjects` | builtin 代替が弱いので独立 on/off。 |
| `treesitter` | context | `nvim-treesitter-context` | UI 寄りだが Treesitter 依存なのでここに置く。 |
| `search` | picker | `telescope.nvim` | file/search/buffer/help/diagnostic picker。 |
| `file` | explorer | `yazi.nvim` | file explorer。 |
| `git` | signs | `gitsigns.nvim` | hunk sign と hunk 操作。 |
| `git` | diff_view | `diffview.nvim`, builtin difftool | diff UI。 |
| `git` | linker | `gitlinker.nvim` | URL 生成/ブラウザ連携。 |
| `git` | notifications | `messenger.nvim` | GitHub notifications。既定 off 候補。 |
| `format` | format_on_save/manual_format | `conform.nvim`, LSP format | formatter chain が必要なら conform。 |
| `terminal` | shell | `toggleterm.nvim`, builtin terminal | default shell 起動。 |
| `terminal` | session_manager | なし | Zellij は廃止。必要なら将来別扱い。 |
| `ui` | status/winbar | `incline.nvim`, builtin statusline/winbar | `treesitter-context` はここではなく `treesitter.context`。 |
| `ui` | icons | `nvim-web-devicons` | dependency として扱うか、UI subfeature として扱うか要検討。 |
| `ui` | theme | builtin `vim` colorscheme | テーマ plugin は削除候補。 |
| `debug` | dap | DAP 系 plugin | 既定 off 候補。 |
| `tooling` | rest, remote_transfer | `rest.nvim`, `transfer.nvim` | 常用しない作業補助。既定 off 候補。 |

区割りで未決の点:

- `nvim-web-devicons` を `ui.icons` としてユーザーが明示的に切れるようにするか、依存 plugin として暗黙管理にするか。
- `nvim-treesitter-context` は UI 表示だが Treesitter に強く依存するため、`ui` ではなく `treesitter.context` に置く方がよさそう。
- `telescope.nvim` は search だけでなく LSP references / diagnostics / git status も扱うため、`search` group に置きつつ、各機能から picker として参照する形がよさそう。
- `format` は plugin group ではなく editor workflow なので、`conform.nvim` を消しても `format.enabled` は残す。
- `lsp.server_manager` は `lsp.runtime` が無効なら基本的に無効にする。ただし server install だけしたいケースを許すかは未決。

実装時の注意:

- `features` はユーザーの意図を表す上位概念、`plugins` は具体的な依存の上書きとして扱う。
- plugin 名は repository 名か short name に統一する。曖昧さを避けるなら `repo = "owner/name"` と `id = "name"` を分ける。
- dependency plugin は、依存元が有効な場合だけ自動で有効化する。ただし個別に `enabled = false` が明示された場合の扱いはエラーにするか警告にする。
- JSONC 対応後はコメントで「なぜ off にしているか」を残せるので、ローカル `.nvim/config.json` での運用がしやすくなる。

### Config レイヤ改修構想

現状の `util.load_config()` は便利だが、今後の `vim.pack` 移行、機能グループ on/off、プラグイン単位 on/off の中心にするには責務を増やす必要がある。
単なる JSON loader ではなく、起動時に一度だけ読み込み、正規化・検証した config を返す小さな設定レイヤとして作り直す。

基本方針:

- `default_config.json` と project local `.nvim/config.json` は継続する。
- JSON parser は Neovim 0.12 の `vim.json.decode(..., { skip_comments = true })` を使い、JSONC を正式対応にする。
- `load_config()` を各 plugin module が何度も呼ぶ形はやめ、起動時に一度 `setup()` / `load()` して cache する。
- 読み込んだ生 config をそのまま使わず、schema の既定値を埋めた normalized config を使う。
- plugin 登録側は raw table を直接見ず、`is_feature_enabled()` / `is_plugin_enabled()` などの判定 API を使う。
- 旧 config との互換が必要な間は migration layer で吸収する。

想定 module:

| module | 役割 |
| --- | --- |
| `config/init.lua` | public API。load/cache/normalize/validate/lookup を提供。 |
| `config/schema.lua` | default 値、schema version、feature/plugin 定義。 |
| `config/migrate.lua` | 旧 `plugins.*` 形式から新 `features.*` 形式への移行補助。 |
| `config/env.lua` | VSCode/Goneovim/OS/WSL/SSH など環境条件の判定。 |
| `config/plugins.lua` | plugin id、repo、feature 所属、dependency、環境制約の対応表。 |

想定 API:

```lua
local config = require("config")

config.setup({
  default_config_path = init_dir .. "/default_config.json",
})

local cfg = config.get()

if config.is_feature_enabled("git.signs") then
  -- gitsigns を登録する
end

if config.is_plugin_enabled("gitsigns.nvim") then
  -- plugin 個別 override も加味した判定
end

local formatter_cfg = config.get_feature("format")
```

判定 API の責務:

- `features.git.enabled = false` なら、原則 `git.*` 配下を無効化する。
- `features.git.enabled = true` かつ `features.git.signs = false` なら、`gitsigns.nvim` は無効。
- `plugins["gitsigns.nvim"].enabled = true/false` が明示されていれば、feature 判定より優先する。
- VSCode など環境制約で使えない plugin は、個別 enabled が true でも無効または警告にする。
- dependency plugin は、依存元が有効な場合に自動で有効化する。
- dependency を個別に false 指定された場合は、黙って壊すのではなく warning/error を出す。

schema version:

```jsonc
{
  "version": 1,
  "features": {},
  "plugins": {}
}
```

schema version を持たせる理由:

- 大改修後に古い `.nvim/config.json` が読み込まれたとき、壊れ方を明確にする。
- 将来 `features` の名前や plugin id を変えたときに migration できる。
- `:ConfigInfo` で config path だけでなく version と migration 状態も表示できる。

移行方針:

1. `util.lua` から config 関連だけを `lua/config/` に分離する。
2. JSONC parser と cache 付き loader を作る。
3. 現行 `default_config.json` を新 schema に変換する。
4. 旧キーを読む migration を一時的に入れる。
   例: `plugins.complement` -> `features.completion`、`plugins.file_explorer` -> `features.file`。
5. plugin 登録側の `config["plugins"]["..."]` 直接参照を判定 API に置き換える。
6. `util.add_plugin()` は `config` の判定 API を使うか、plugin registry 側に責務を移す。
7. `:ConfigInfo` を拡張し、default/local config path、schema version、有効 feature、有効 plugin を表示できるようにする。

現 config から直したい点:

- `load_config()` が複数箇所から呼ばれ、読み込みタイミングと回数が曖昧。
- `config_path`, `json_decoder`, `json` など local なし代入があり、グローバル汚染している。
- `plugins.complement.engine` のように、ユーザー意図より plugin 実装に寄った名前がある。
- JSON5 対応 TODO は JSONC 対応方針へ置き換える。
- plugin の enabled 判定、feature の enabled 判定、VSCode 分岐が別々の場所に散りやすい。
- dependency plugin の扱いが明示的ではない。
- schema version がなく、将来の破壊的変更時に local config の移行が難しい。

### Python 環境 resolver 構想

Python は仮想環境の作り方が多様化しており、LSP の Python 解決を固定ロジックにすると補完・診断・import 解決が壊れやすい。
現状は Neovim を起動した shell の `python` から base path を作って `pyright` に渡しているが、これは pyenv 前提の時代には十分でも、uv/mise/nix/conda などが混ざると意図とずれやすい。

Python 環境は専用 resolver を作り、プロジェクトごとに「どの思想で Python を解決するか」を config で手動選択する。
自動検出は便利だが誤判定すると LSP/formatter/debugger がまとめてずれるため、主経路にはしない。
解決結果は pyright だけでなく、ruff、formatter、debugger、terminal 実行にも流用できる形にする。

想定 config:

```jsonc
{
  "features": {
    "python": {
      "enabled": true,
      "resolver": "activated",
      "lsp": {
        "type_checker": "pyright",
        "lint": "ruff"
      }
    }
  },
  "languages": {
    "python": {
      "resolver": "uv",
      "project_root_markers": ["pyproject.toml", "uv.lock", ".git"],
      "python_path": null
    }
  }
}
```

resolver の候補:

| resolver | 想定する思想 | 解決方法の候補 | 向いているケース |
| --- | --- | --- | --- |
| `activated` | shell で仮想環境を activate してから Neovim を起動する | `VIRTUAL_ENV`, `CONDA_PREFIX`, `python` / `python3` の実体を見る | `.venv/bin/activate`, conda activate, direnv など。 |
| `venv` | project 配下に仮想環境を置く | `.venv`, `venv`, `.virtualenv`, `virtualenv` を root から探索 | 昔ながらの project-local venv。 |
| `uv` | 実行時に uv が環境を解決する | `uv python find`, `uv run python -c ...`, `uv.lock`, `pyproject.toml` を見る | 最近の uv project。補完の Python と実行時 Python を合わせたい場合。 |
| `conda` | conda env を明示的に使う | `CONDA_PREFIX`, `conda info --json`, env name 指定 | data science 系 project。 |
| `pyenv` | pyenv の shim / local version を使う | `.python-version`, `pyenv which python`, `pyenv prefix` | 既存設定の思想に近い。 |
| `mise` | mise が runtime を切り替える | `.mise.toml`, `mise which python`, `mise exec -- python ...` | Python 以外の runtime もまとめて管理する project。 |
| `nix` | nix develop / devShell が環境を作る | `IN_NIX_SHELL`, `nix develop --command python ...` | shell に入って使うか、Neovim から command 経由で実行する project。 |
| `manual` | config で明示する | `python_path`, `venv_path`, `extra_paths` を指定 | 自動検出を信用したくない project。 |
| `system` | system Python を使う | `python3` / `python` をそのまま使う | 小さい script や仮想環境不要の用途。 |
| `auto` | 複数 resolver を順に試す | 優先順位に従って最初に valid なものを採用 | 補助用途。既定にはしない。 |

resolver が返す情報:

```lua
{
  kind = "uv",
  root = "/path/to/project",
  python = "/path/to/.venv/bin/python",
  venv_path = "/path/to/.venv",
  env = {
    VIRTUAL_ENV = "/path/to/.venv",
    PATH = "/path/to/.venv/bin:..."
  },
  run = { "uv", "run" },
  source = "uv.lock"
}
```

用途ごとの使い方:

| 用途 | resolver 結果の使い方 |
| --- | --- |
| `pyright` | `settings.python.pythonPath` / `venvPath` に反映する。pyright 側の推奨設定と衝突しないか要確認。 |
| `ruff` LSP | Neovim から起動する `ruff` の command/env を resolver に合わせるか検討する。 |
| formatter | `ruff_format`, `ruff_fix`, `black`, `isort` を project の環境から実行するか、Mason/global の formatter を使うか選べるようにする。 |
| DAP | `debugpy` / Python executable を resolver の Python に合わせる。 |
| terminal | default shell では環境を勝手に activate しない。必要なら `uv run` / `mise exec` / `nix develop` 用の明示コマンドを別途用意する。 |
| `:ConfigInfo` | 採用された resolver、Python path、root、source を表示する。 |

初期実装方針:

1. まず `manual`, `activated`, `venv`, `uv`, `system` を実装する。
2. `conda`, `pyenv`, `mise`, `nix` は resolver interface を先に決め、実装は段階的に追加する。
3. 切り替えは config system で手動指定する。project local `.nvim/config.json` の `languages.python.resolver` を第一の入力にする。
4. resolver は shell command を多用しすぎない。必要な command は timeout と executable check を入れる。
5. LSP 起動後に resolver 結果が変わった場合は、`:LspRestart` 相当の案内か専用 command を用意する。

現行実装からの移行:

- `nvim_lsp_cfg/find_python.lua`, `venv.lua`, `poetry.lua` は `lua/python_env/` または `lua/languages/python/` に統合する。
- `pyright.before_init` に直接検出ロジックを書かず、`python_env.resolve(config.root_dir)` の結果を反映するだけにする。
- コメントアウトされている `.venv` / poetry 検出は resolver として再整理する。
- pyenv 時代の「起動 shell の `python` を信じる」挙動は `activated` または `pyenv` resolver に分離する。

## 現在の主なキーマップ

後続の判断で「機能を消すと何が消えるか」を確認するための一覧。

| 領域 | キー | 機能 | 提供元 | 判断メモ |
| --- | --- | --- | --- | --- |
| 共通 | `\` | `,` として扱う | builtin map | 残す候補 |
| Terminal | `<ESC>` | terminal mode から normal mode | builtin map | 残す候補 |
| LSP | `gD` | declaration | builtin LSP | 残す候補 |
| LSP | `gd` | definition | builtin LSP | 残す候補 |
| LSP | `K` | hover | builtin LSP | 残す候補 |
| LSP | `gh` | references | builtin LSP | Telescope の `gr` と使い分け確認 |
| LSP | `gi` | implementation | builtin LSP | 残す候補 |
| LSP | `<C-k>` | signature help | builtin LSP | native completion との関係を確認 |
| LSP | `<space>rn` | rename | builtin LSP | 残す候補 |
| LSP | `<space>ca` | code action | builtin LSP | 残す候補 |
| LSP | `<leader>cd` | line diagnostic float | builtin diagnostic | 残す候補 |
| LSP | `[d` / `]d` | diagnostic jump + float | builtin diagnostic | 残す候補 |
| Telescope | `<leader>ff` | find files | `telescope.nvim` | 残す方針 |
| Telescope | `<leader>fgr` | live grep | `telescope.nvim` | 残す方針 |
| Telescope | `<leader>fgs` | git status | `telescope.nvim` | 残す方針 |
| Telescope | `<leader>fb` | buffers | `telescope.nvim` | 残す方針 |
| Telescope | `<leader>fh` | help tags | `telescope.nvim` | 残す方針 |
| Telescope | `<leader>fq` | quickfix | `telescope.nvim` | 残す方針 |
| Telescope | `<leader>fd` | diagnostics | `telescope.nvim` | 残す方針 |
| Telescope | `gr` / `<leader>gr` | LSP references picker | `telescope.nvim` | builtin `vim.lsp.buf.references` との差分確認 |
| Telescope | `<leader>fre` | registers | `telescope.nvim` | 残す方針 |
| Yazi | `<leader>-` | current file 位置で Yazi | `yazi.nvim` | 残す方針 |
| Yazi | `<leader>cw` | cwd で Yazi | `yazi.nvim` | 残す方針 |
| Yazi | `<C-Up>` | Yazi session toggle | `yazi.nvim` | 残す方針 |
| Git | `]c` / `[c` | hunk 移動 | `gitsigns.nvim` | Treesitter と衝突 |
| Git | `<leader>hs` / `<leader>hr` | hunk stage/reset | `gitsigns.nvim` | 維持 |
| Git | `<leader>hp` | hunk preview | `gitsigns.nvim` | 維持 |
| Git | `<leader>hb` / `<leader>tb` | blame 表示/toggle | `gitsigns.nvim` | 維持 |
| Git | `<leader>hd` / `<leader>hD` | diff | `gitsigns.nvim` | `diffview`/`nvim.difftool` と整理 |
| Git | `<leader>gm` | GitHub notifications | `messenger.nvim` | 廃止。keymap も削除 |
| Git | `<leader>gb` | line/range URL を browser で開く | `gitlinker.nvim` | 維持。VSCode Neovim でも有効 |
| Git | `<leader>gY` / `<leader>gB` | repo URL 取得/browser | `gitlinker.nvim` | 維持。VSCode Neovim でも有効 |
| Treesitter | `af` / `if` | function textobject | `nvim-treesitter-textobjects` | 要検討 |
| Treesitter | `ac` / `ic` | class textobject | `nvim-treesitter-textobjects` | 要検討 |
| Treesitter | `as` | scope textobject | `nvim-treesitter-textobjects` | 要検討 |
| Treesitter | `]f` / `[f` | function 移動 | `nvim-treesitter-textobjects` | 要検討 |
| Treesitter | `]c` / `[c` | class 移動 | `nvim-treesitter-textobjects` | Git と衝突 |
| Terminal | `<leader>z` | default shell を float terminal で開く | `toggleterm.nvim` | Zellij 連携は廃止 |
| Terminal | `<leader>cx` | Codex を terminal で起動 | `toggleterm.nvim` | `codex` command を float terminal で起動 |
| Format | `<space>f` | format | `conform.nvim` | 維持 |

## 初期論点

次に詰めるとよさそうな論点:

1. 独自 config system を先に設計する。
   JSONC loader、schema version、正規化、migration、機能グループ単位とプラグイン単位の on/off、判定 API を固める。
2. `lazy.nvim` から `vim.pack` へ移行した場合の plugin 定義形式を決める。
   config の判定 API と plugin registry をどう接続するかも含めて決める。
3. native completion で必要な体験を決める。
   LSP 補完、path 補完、buffer 補完、snippet、documentation popup、signature help、popup border を確認する。
4. Treesitter 構成を `tree-sitter-manager.nvim` + Neovim builtin へ移行する。
   parser の install/remove/update は `tree-sitter-manager.nvim` に限定し、起動・highlight・FileType autocmd は `vim.treesitter.start()` など Neovim 0.12 builtin で管理する。
5. Git 周辺をどこまで残すか決める。
   `messenger.nvim` は off 決定済み。残りの `gitsigns`, `diffview`, `gitlinker` は役割が分かれているため、使用頻度ベースで判断する。
6. UI 表示系を削るか決める。
   `incline`, `devicons`, `treesitter-context` は便利だが、軽量化対象になりやすい。
7. terminal 方針を決める。
   Zellij attach は廃止し、default shell、複数 terminal、cwd の扱いを設計する。
8. 休眠プラグイン設定を削除するか、別ファイルへ隔離するか決める。

## 変更時に壊しやすい点

- `util.add_plugin()` は VSCode 分岐を兼ねているため、`vim.pack` 移行時に同等の条件分岐が必要。
- `default_config.json` の値で補完 engine と file explorer が切り替わるため、削除する場合は config schema も整理する。JSONC 対応時は `vim.fn.json_decode` から `vim.json.decode(..., { skip_comments = true })` への移行も必要。
- 機能グループ単位の on/off とプラグイン単位の on/off は優先順位を明確にしないと、依存 plugin の扱いが曖昧になる。
- `gitsigns.nvim` と `nvim-treesitter-textobjects` が `[c` / `]c` を共有している。
- `tree-sitter-manager.nvim` は highlighting や FileType autocmd も持つため、実行時挙動まで plugin 側へ寄せすぎないように設定を確認する。
- `incline.nvim` は `gitsigns_status_dict` を参照しているため、`gitsigns.nvim` を消す場合は表示側も変更が必要。
- `nvim-web-devicons` は直接の機能ではないが、複数 UI plugin から参照される。
- `conform.nvim` を消す場合、format on save と Python の formatter chain をどうするか決める必要がある。
- `nvim-lspconfig` を消す場合、server ごとの default command / filetype / root marker をどこまで自前で持つか検討が必要。

## 仕様決定フェーズ

ここからは実装前に詰めるべき仕様を順番に決める。
会話で決めた内容はこのセクションへ追記し、未決事項は次の候補として残す。

進め方:

1. 次に決めるべき仕様候補をいくつか出す。
2. その中から優先して詰めるものを選ぶ。
3. 選んだ項目について、選択肢・推奨案・理由・未決リスクを整理する。
4. 決定した内容を「決定ログ」に追記する。
5. 実装フェーズに入るまでこれを繰り返す。

### 決定ログ

| 日付 | 項目 | 決定 | 理由・メモ |
| --- | --- | --- | --- |
| 2026-07-10 | Zellij 連携 | 廃止し、terminal は default shell 起動を中心にする | `toggleterm.nvim` は残す方針だが、Zellij session attach はやめる。 |
| 2026-07-10 | JSON config format | JSONC を正式採用する | Neovim 0.12 の `vim.json.decode(..., { skip_comments = true })` を使う。`lua-json5` は廃止候補。 |
| 2026-07-10 | Treesitter parser 管理 | `tree-sitter-manager.nvim` を使う | parser install/remove/update のみ plugin に依存し、起動・highlight は builtin `vim.treesitter` に寄せる。 |
| 2026-07-10 | Python 環境切り替え | config system で手動指定する | auto detection は主経路にしない。project local config の `languages.python.resolver` を第一の入力にする。 |
| 2026-07-10 | Config schema top-level | `version`, `features`, `plugins`, `languages` を基本構造にする | schema version は top-level `version`。機能設定は `features`、言語別詳細は `languages`、plugin 個別 override は `plugins`。 |
| 2026-07-10 | Plugin config key | plugin 個別設定は short id を primary key にする | repository full name は registry 側に持つ。config 側は `gitsigns.nvim` のような short id を使う。 |
| 2026-07-10 | Feature/plugin 優先順位 | plugin override を feature より優先する | ただし dependency を壊す指定は warning/error にする。 |
| 2026-07-10 | Unknown key の扱い | default は warning、strict mode では error | local config の運用しやすさと typo 検出のバランスを取る。 |
| 2026-07-11 | `default_config.json` top-level | `version`, `strict`, `features`, `languages`, `plugins` にする | top-level は増やしすぎず、詳細は `features` / `languages` / `plugins` に寄せる。 |
| 2026-07-11 | Feature group 初期セット | `core`, `lsp`, `completion`, `treesitter`, `search`, `file`, `git`, `format`, `terminal`, `ui`, `python`, `debug`, `tooling` を採用 | まずこの単位で group on/off を設計する。 |
| 2026-07-11 | Plugin override の粒度 | 当面は `enabled` のみ | lazy 条件や dependency は plugin registry 側に置く。 |
| 2026-07-11 | Local config の plugin override | 許可する | project ごとに重い plugin や不要 plugin を切れるようにする。 |
| 2026-07-11 | Python default resolver | `uv` を主にし、`.venv` が見つからなければ `activated` に fallback | config で明示された resolver chain として扱い、無差別な auto detection にはしない。 |
| 2026-07-11 | `messenger.nvim` | 廃止候補ではなく不要として off | GitHub notifications は使わない前提。 |
| 2026-07-11 | Plugin registry の配置 | `lua/plugin_registry.lua` に置く | plugin metadata を一箇所に集約し、config layer と plugin setup layer から参照する。 |
| 2026-07-11 | Plugin id 命名 | repo の最後の path component を id にする | 例: `lewis6991/gitsigns.nvim` -> `gitsigns.nvim`。重複時だけ alias を許可する。 |
| 2026-07-11 | Registry の形式 | `vim.pack` の spec に合わせる | `lazy.nvim` 互換を目指さず、`src`, `name`, `version` を生成できる metadata を持つ。 |
| 2026-07-11 | Lazy loading | 原則として再現しない | plugin 削減を主軸にし、event/key lazy の自前再実装はしない。必要なら setup 側で軽い keymap/command を別途検討する。 |
| 2026-07-11 | Dependency handling | 依存元が有効なら dependency は自動有効化 | dependency を明示 off して壊れる場合は warning/error。strict mode では error。 |
| 2026-07-11 | Feature/plugin 解決順 | env 制約 -> plugin override -> feature enabled -> dependency resolution -> final validation | plugin override は feature より優先するが、環境制約と dependency validation は最後に守る。 |
| 2026-07-11 | 環境条件 | まず `vscode = false/true/any` を registry に持つ | Goneovim/OS 条件は必要になったら拡張する。 |
| 2026-07-11 | Plugin setup 分割 | registry は metadata、setup は別 module に分ける | 大きい設定を registry に直書きしない。`lua/plugins/specs/<id>.lua` または機能別 module を使う。 |
| 2026-07-11 | Lock/update 方針 | Neovim 標準の lockfile を使う | `vim.pack` は `packlockfile` と `:packupdate` を持つため、独自 lock は作らない。 |
| 2026-07-11 | 既存 plugin module 移行単位 | 一気に移行する | 互換レイヤを長く残さず、新 config/registry 前提でまとめて切り替える。 |
| 2026-07-11 | Completion engine | builtin native completion のみ使う | `blink.cmp` / `nvim-cmp` は削除方向。 |
| 2026-07-11 | Completion trigger | default は `autotrigger = true` | LSP の `triggerCharacters` に基づいて自動補完する。重い言語は local config で off 可能にする。 |
| 2026-07-11 | Completion keymap | 手動補完は `<C-Space>`、確定は `<C-y>` | `<Tab>` / `<CR>` 確定は複雑化するため入れない。 |
| 2026-07-11 | Completion UI | `completeopt = menuone,noselect,popup` | popup preview を使う。border は Neovim 0.12 builtin UI に寄せる。 |
| 2026-07-11 | Completion sources | 自動化するのは LSP completion のみ | path/buffer は builtin 操作に任せる。snippet は default off。 |
| 2026-07-11 | Signature help | `<C-k>` 手動を継続 | 自動 signature popup は入れない。 |
| 2026-07-11 | Completion display/sort | 初期は default | icon や凝った sorting は入れず、必要になったら `convert` / `cmp` option を検討する。 |
| 2026-07-11 | Python resolver scope | Python executable と run prefix を返す責務に限定 | LSP install、formatter 選択、環境 activate、terminal shell 変更は resolver の責務にしない。 |
| 2026-07-11 | Python resolver 初期実装 | `uv`, `activated`, `manual`, `system` を実装 | `conda`, `pyenv`, `mise`, `nix` は schema 予約のみで後回し。 |
| 2026-07-11 | Python resolver default | `uv` -> `activated` fallback | system Python までは自動 fallback しない。 |
| 2026-07-11 | Python uv resolver | `.venv/bin/python`、次に `uv python find`、実行 prefix は `uv run` | 補完用 Python は実体 path、実行系は `uv run` に寄せる。 |
| 2026-07-11 | Python activated resolver | `VIRTUAL_ENV`, `CONDA_PREFIX`, `python/python3` の順に見る | pyenv の「起動 shell の python を信じる」挙動もここで扱う。 |
| 2026-07-11 | Python LSP 反映 | まず pyright の `pythonPath` に反映 | `venvPath/venv` は resolver が venv 情報を返せる場合だけ追加検討。 |
| 2026-07-11 | Python formatter/ruff 反映 | 初期は既存方針を維持 | 将来的に resolver の `run_prefix` を formatter 実行へ使えるように設計する。 |
| 2026-07-11 | Python resolver failure | warning。strict mode では error 可能 | pyright は起動するが `pythonPath` は設定しない。 |
| 2026-07-11 | Treesitter runtime | parser 管理は `tree-sitter-manager.nvim`、runtime は builtin `vim.treesitter.start()` | `nvim-treesitter` は削除方向。 |
| 2026-07-11 | Treesitter parser list | 現行 list を維持 | まず現状維持で移行し、削るのは後で判断する。 |
| 2026-07-11 | Treesitter context | default off | 便利だが必須ではなく、軽量化方針では優先度を下げる。 |
| 2026-07-11 | Treesitter textobjects | default on | `[f`, `]f`, `[F`, `]F` を使っているため残す。 |
| 2026-07-11 | Treesitter keymap 衝突 | `[c`, `]c`, `[C`, `]C` は割り当てない | `[c` / `]c` は `gitsigns` に譲る。 |
| 2026-07-11 | Treesitter install command | 自前 command を用意する | `tree-sitter-manager.nvim` を直接意識しすぎない `:TreesitterInstallConfigured` / `:TreesitterUpdateConfigured` を想定。 |
| 2026-07-12 | `gitsigns.nvim` | 残す。既存 keymap も維持 | hunk 操作、blame、diff、deleted 表示を継続する。Treesitter の `[c` / `]c` は使わず Git hunk 移動に譲る。 |
| 2026-07-12 | `messenger.nvim` | 廃止。keymap も削除 | GitHub notifications は不要。`<leader>gm` も削除する。 |
| 2026-07-12 | `diffview.nvim` | 残す | 起動 shortcut は追加せず、当面は command line から起動する。 |
| 2026-07-12 | `gitlinker.nvim` | 残す。VSCode Neovim でも有効 | 現在行/選択範囲/repository URL の取得・ブラウザ起動を継続する。 |
| 2026-07-12 | Terminal backend | `toggleterm.nvim` を残す | Zellij は廃止し、default shell 起動に使う。 |
| 2026-07-12 | Terminal keymap | `<leader>z` で default shell を開く | 従来の keymap を維持しつつ、起動対象を Zellij から shell に変える。 |
| 2026-07-12 | Codex terminal | toggleterm で `codex` を `<leader>cx` から起動する | `<leader>cd` diagnostic と直接衝突しない keymap として採用。 |
| 2026-07-12 | Format provider | `conform.nvim` を残す | builtin LSP formatting だけでは外部 formatter 選択・chain・fallback を置き換えきれない。 |
| 2026-07-12 | Format on save | 維持 | `features.format.format_on_save = true` を default にする。 |
| 2026-07-12 | Manual format key | `<space>f` を維持 | `conform.format()` を呼ぶ。 |
| 2026-07-12 | LSP format fallback | `lsp_format = "fallback"` を基本にする | external formatter がない場合だけ LSP formatting に fallback。 |
| 2026-07-12 | Python formatter chain | 維持 | `ruff_fix` + `ruff_format`、なければ `isort` + `black`。 |
| 2026-07-12 | `incline.nvim` | 残す | Git 差分・diagnostic・ファイル名の軽量表示として維持。1行目長文に被る問題は改善対象。 |
| 2026-07-12 | `nvim-web-devicons` | 残す | `incline.nvim` の icon 表示に必要。依存元がなくなったら再検討。 |
| 2026-07-12 | Colorscheme | builtin `vim` を維持 | colorscheme plugin は削除候補。`NormalFloat` / `SignColumn` 背景調整は維持。popup border も builtin UI で調整する。 |
| 2026-07-12 | Greeter/dashboard | 廃止 | `alpha-nvim` は不要。default greeter で十分。 |
| 2026-07-12 | Animation/smooth scroll | 廃止 | `neoscroll.nvim`, `specs.nvim`, `animation.nvim` は削除候補。 |
| 2026-07-12 | Scrollbar/minimap | 廃止 | `codewindow.nvim`, `nvim-scrollview` は削除候補。 |
| 2026-07-12 | Statusline/bufferline | `incline.nvim` のみ残す | `lualine.nvim`, `barbar.nvim` は削除候補。 |
| 2026-07-12 | Window UI | 廃止 | `windows.nvim`, `middleclass`, `animation.nvim` は削除候補。 |
| 2026-07-12 | LSP runtime | builtin `vim.lsp` を使う | `vim.lsp.config()` / `vim.lsp.enable()` を主経路にする。 |
| 2026-07-12 | LSP server install 管理 | `mason.nvim` / `mason-lspconfig.nvim` を残す | Mason は install 管理に寄せ、`automatic_enable = false` を維持する。 |
| 2026-07-12 | LSP server 定義 | `nvim-lspconfig` を残す | server ごとの cmd/filetype/root marker を自前管理しない。 |
| 2026-07-12 | LSP ensure list | 現状維持 | `clangd`, `pyright`, `ruff`, `jsonls`, `bashls`, `lua_ls`, `texlab`。 |
| 2026-07-12 | LSP keymap/diagnostics | 現状維持 | 既存 keymap、diagnostic virtual text/sign/jump float、document highlight、codelens を維持する。 |
| 2026-07-12 | Python resolver LSP 反映 | `pyright` に反映 | 初期は `settings.python.pythonPath` 中心。 |
| 2026-07-12 | LSP 補助 plugin | `vim-illuminate` / `lsp_signature` は削除候補 | document highlight と signature help は builtin で扱う。 |

### 実装前チェックリスト

主要仕様は一通り決定済み。
実装に入る前に、以下を最終確認する。

| 優先度 | 項目 | 状態 | メモ |
| --- | --- | --- | --- |
| 高 | 実装順序 | 要確認 | 一気に移行する方針だが、作業ブランチ内では config layer -> registry -> plugin specs -> cleanup の順がよい。 |
| 高 | rollback 方針 | 要確認 | 旧 `lazy.nvim` 構成を git で戻せる前提にし、互換 layer は長く残さない。 |
| 中 | 休眠設定ファイル | 実装中に整理 | 使わない plugin module は削除するか、必要なら `archive` 的に隔離する。 |
| 中 | README 更新 | 実装後 | 新 keymap、config schema、install/update command を `.config/nvim/README.md` に反映する。 |
| 中 | 動作確認 | 実装後 | `nvim --headless` で起動確認、通常起動で主要 keymap を確認する。 |

### `default_config.json` skeleton 決定

新 `default_config.json` は JSONC として扱う。
default は軽量な標準構成を表し、project local `.nvim/config.json` で必要な差分だけ上書きする。

```jsonc
{
  "version": 1,
  "strict": false,
  "features": {
    "core": {
      "enabled": true
    },
    "lsp": {
      "enabled": true,
      "runtime": true,
      "server_manager": "mason"
    },
    "completion": {
      "enabled": true,
      "engine": "native",
      "autotrigger": true,
      "manual_key": "<C-Space>",
      "confirm_key": "<C-y>",
      "completeopt": ["menuone", "noselect", "popup"],
      "snippets": false,
      "signature_help": {
        "enabled": true,
        "auto": false,
        "key": "<C-k>"
      }
    },
    "treesitter": {
      "enabled": true,
      "parser_manager": true,
      "runtime_highlight": true,
      "textobjects": true,
      "context": false
    },
    "search": {
      "enabled": true,
      "picker": "telescope"
    },
    "file": {
      "enabled": true,
      "explorer": "yazi"
    },
    "git": {
      "enabled": true,
      "signs": true,
      "diff_view": true,
      "linker": true,
      "notifications": false
    },
    "format": {
      "enabled": true,
      "provider": "conform",
      "format_on_save": true,
      "manual_key": "<space>f",
      "lsp_format": "fallback"
    },
    "terminal": {
      "enabled": true,
      "backend": "toggleterm",
      "default_shell": true,
      "codex": {
        "enabled": true,
        "cmd": "codex",
        "key": "<leader>cx"
      }
    },
    "ui": {
      "enabled": true,
      "status": true,
      "icons": true,
      "theme": "vim",
      "animations": false,
      "greeter": false,
      "minimap": false,
      "scrollbar": false,
      "window_manager": false,
      "popup_border": true
    },
    "python": {
      "enabled": true
    },
    "debug": {
      "enabled": false
    },
    "tooling": {
      "enabled": false,
      "rest": false,
      "remote_transfer": false
    }
  },
  "languages": {
    "treesitter": {
      "parsers": [
        "c",
        "cpp",
        "cmake",
        "make",
        "cuda",
        "glsl",
        "rust",
        "python",
        "latex",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "jsonc",
        "json5",
        "tsx",
        "toml",
        "yaml",
        "vim",
        "bash",
        "regex",
        "markdown",
        "markdown_inline"
      ],
      "start_filetypes": [
        "c",
        "cpp",
        "cmake",
        "make",
        "cuda",
        "glsl",
        "rust",
        "python",
        "latex",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "typescriptreact",
        "json",
        "jsonc",
        "json5",
        "toml",
        "yaml",
        "vim",
        "bash",
        "regex",
        "markdown"
      ],
      "textobjects": {
        "select": ["af", "if", "ac", "ic", "as"],
        "move": ["]f", "[f", "]F", "[F"]
      }
    },
    "python": {
      "resolver": "uv",
      "fallback_resolver": "activated",
      "project_root_markers": ["pyproject.toml", "uv.lock", ".venv", ".git"],
      "python_path": null,
      "venv_path": null,
      "run_prefix": ["uv", "run"],
      "lsp": {
        "type_checker": "pyright",
        "lint": "ruff"
      },
      "format": {
        "provider": "ruff",
        "fallback": ["isort", "black"]
      }
    }
  },
  "plugins": {
    "messenger.nvim": {
      "enabled": false
    }
  }
}
```

補足:

- `plugins` は当面 `enabled` だけを受け付ける。
- plugin の `repo`, dependency, load timing, VSCode 対応は `default_config.json` ではなく plugin registry 側に持つ。
- local `.nvim/config.json` でも `plugins.*.enabled` による override を許可する。
- Python は `resolver = "uv"` を default とし、uv project の `.venv` が見つからない場合だけ `activated` に fallback する。
- `messenger.nvim` は default で off。GitHub notifications は不要なものとして扱う。

local config の例:

```jsonc
{
  "languages": {
    "python": {
      "resolver": "activated",
      "fallback_resolver": null
    }
  },
  "features": {
    "format": {
      "format_on_save": false
    }
  },
  "plugins": {
    "diffview.nvim": {
      "enabled": false
    }
  }
}
```

### Plugin registry / `vim.pack` 設計決定

Plugin registry は `lua/plugin_registry.lua` に置く。
`lazy.nvim` の spec を再現するのではなく、Neovim 0.12 の `vim.pack.add()` に渡す spec を生成するための metadata として設計する。

基本方針:

- config 側では plugin short id を使う。
- registry 側で short id と repo URL を対応させる。
- repo の最後の path component を plugin id にする。
- id が重複した場合だけ alias を許可する。
- lazy loading は原則再現しない。
- dependency は registry で宣言し、依存元が有効なら自動で有効化する。
- setup/config は registry に直書きせず、別 module に分離する。
- lock/update は Neovim 標準の `packlockfile` / `:packupdate` に任せる。

想定 registry:

```lua
return {
  {
    id = "gitsigns.nvim",
    src = "https://github.com/lewis6991/gitsigns.nvim",
    feature = "git.signs",
    dependencies = {},
    env = { vscode = false },
    setup = "plugins.specs.gitsigns",
  },
  {
    id = "telescope.nvim",
    src = "https://github.com/nvim-telescope/telescope.nvim",
    version = "v0.2.1",
    feature = "search.picker",
    dependencies = { "plenary.nvim" },
    env = { vscode = false },
    setup = "plugins.specs.telescope",
  },
  {
    id = "plenary.nvim",
    src = "https://github.com/nvim-lua/plenary.nvim",
    dependency = true,
    env = { vscode = "any" },
  },
}
```

`vim.pack.add()` に渡す spec への変換:

```lua
local pack_specs = vim.tbl_map(function(plugin)
  local spec = {
    src = plugin.src,
    name = plugin.id,
  }

  if plugin.version then
    spec.version = plugin.version
  end

  return spec
end, enabled_plugins)

vim.pack.add(pack_specs)
```

解決順:

1. `env` 制約を確認する。
2. `plugins.<id>.enabled` の明示 override を見る。
3. `feature` に対応する `features.*` の enabled/subfeature を見る。
4. 有効 plugin の dependency を自動で有効化する。
5. dependency が明示 off されているなど、壊れる指定を validation する。

環境条件:

```lua
env = {
  vscode = false, -- false: VSCode では無効, true: VSCode のみ, "any": 両方
}
```

最初は `vscode` だけを registry の標準条件にする。
Goneovim/OS 条件は必要になった時点で拡張する。

setup 分割:

- registry は metadata のみ。
- 大きい設定は `lua/plugins/specs/<id>.lua` または機能別 module に置く。
- setup module は plugin が有効化された後に呼ぶ。
- `lazy.nvim` の `config = function()` 互換は作らない。

lock/update:

- Neovim 0.12 の標準 lockfile を使う。
- `packlockfile` の default は `nvim-pack-lock.json`。
- update は `:packupdate` を使う。
- 独自 lockfile は作らない。
- version pin が必要な plugin は registry の `version` に tag/branch/commit を書く。

移行方針:

- 既存 plugin module は一気に移行する。
- `lazy.nvim` と `vim.pack` の併用期間は作らないか、最小限にする。
- `lua/plugins.lua` は registry resolve -> `vim.pack.add()` -> setup 呼び出し、という薄い orchestrator にする。

### Completion 仕様決定

Completion は Neovim 0.12 builtin の LSP completion を使う。
`blink.cmp` / `nvim-cmp` は削除方向とし、互換 layer は作らない。

決定:

| 項目 | 決定 | メモ |
| --- | --- | --- |
| engine | `native` | `vim.lsp.completion` を使う。 |
| 自動補完 | `autotrigger = true` | LSP server の `triggerCharacters` に従う。 |
| 手動補完 | `<C-Space>` | `vim.lsp.completion.get()` を呼ぶ。 |
| 補完確定 | `<C-y>` | builtin completion の標準挙動に寄せる。`<Tab>` / `<CR>` 確定は入れない。 |
| `completeopt` | `menuone,noselect,popup` | completion item resolve の popup preview を使う。 |
| 自動化する source | LSP のみ | path/buffer は builtin 操作に任せる。 |
| snippets | default off | snippet 運用は必要になったら再検討。 |
| signature help | `<C-k>` 手動 | 既存 keymap を継続。自動 popup は入れない。 |
| sorting/display | default | icon 表示や凝った sort は入れない。必要なら `convert` / `cmp` option を追加検討。 |

想定 config:

```jsonc
{
  "features": {
    "completion": {
      "enabled": true,
      "engine": "native",
      "autotrigger": true,
      "manual_key": "<C-Space>",
      "confirm_key": "<C-y>",
      "completeopt": ["menuone", "noselect", "popup"],
      "snippets": false,
      "signature_help": {
        "enabled": true,
        "auto": false,
        "key": "<C-k>"
      }
    }
  }
}
```

実装メモ:

```lua
vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
      })
    end
  end,
})

vim.keymap.set("i", "<C-Space>", function()
  vim.lsp.completion.get()
end)
```

削除対象:

- `blink.cmp`
- `friendly-snippets`
- `nvim-cmp`
- `lspkind.nvim`
- `cmp-nvim-lsp`
- `cmp-nvim-lsp-signature-help`
- `cmp-buffer`
- `cmp-path`
- `cmp-cmdline`
- `cmp-nvim-lsp-document-symbol`
- `LuaSnip`
- `cmp_luasnip`

### Python resolver 仕様決定

Python resolver は、Python executable と実行 prefix を解決するための薄い layer にする。
LSP server の install、formatter の選択、conda/mise/nix の activate、terminal shell の変更は resolver の責務にしない。

決定:

| 項目 | 決定 | メモ |
| --- | --- | --- |
| resolver の責務 | `python`, `venv_path`, `run_prefix`, `env`, `source` を返す | 実行環境そのものを勝手に切り替えない。 |
| default resolver | `uv` | 最近の利用実態に合わせる。 |
| fallback resolver | `activated` | uv で `.venv` / Python が取れない場合だけ使う。 |
| system fallback | しない | system Python へ勝手に落ちると誤判定しやすい。 |
| 初期実装 | `uv`, `activated`, `manual`, `system` | `system` は明示指定時のみ。 |
| schema 予約 | `conda`, `pyenv`, `mise`, `nix` | interface だけ見越し、実装は後回し。 |
| pyright 反映 | `settings.python.pythonPath` 中心 | `venvPath/venv` は必要になったら追加。 |
| ruff/formatter 反映 | 初期は既存方針維持 | 将来 `run_prefix` を使えるようにする。 |
| root markers | `uv.lock`, `pyproject.toml`, `.venv`, `.git` | この順で project root を探す。 |
| 失敗時 | warning | strict mode では error 可能。pyright は起動するが `pythonPath` は設定しない。 |

想定 config:

```jsonc
{
  "languages": {
    "python": {
      "resolver": "uv",
      "fallback_resolver": "activated",
      "project_root_markers": ["uv.lock", "pyproject.toml", ".venv", ".git"],
      "python_path": null,
      "venv_path": null,
      "run_prefix": ["uv", "run"],
      "lsp": {
        "type_checker": "pyright",
        "lint": "ruff"
      },
      "format": {
        "provider": "ruff",
        "fallback": ["isort", "black"]
      }
    }
  }
}
```

resolver が返す値:

```lua
{
  kind = "uv",
  root = "/path/to/project",
  python = "/path/to/project/.venv/bin/python",
  venv_path = "/path/to/project/.venv",
  run_prefix = { "uv", "run" },
  env = {},
  source = ".venv"
}
```

`uv` resolver:

1. project root 配下の `.venv/bin/python` を探す。
2. なければ `uv python find` を試す。
3. `run_prefix = { "uv", "run" }` を返す。
4. 解決できなければ fallback resolver へ渡す。

`activated` resolver:

1. `VIRTUAL_ENV/bin/python` を見る。
2. `CONDA_PREFIX/bin/python` を見る。
3. `python` / `python3` の実体を見る。
4. `run_prefix = {}` を返す。

`manual` resolver:

```jsonc
{
  "languages": {
    "python": {
      "resolver": "manual",
      "python_path": "/abs/path/to/python",
      "venv_path": "/abs/path/to/.venv",
      "run_prefix": []
    }
  }
}
```

`system` resolver:

- 明示指定時のみ使う。
- `python3` 優先、なければ `python`。
- `venv_path = null`。
- `run_prefix = {}`。

用途:

| 用途 | 初期方針 |
| --- | --- |
| pyright | resolver の `python` を `settings.python.pythonPath` に入れる。 |
| ruff LSP | 初期は Mason/global の server 起動を維持。 |
| formatter | 初期は conform の既存 formatter chain を維持。 |
| DAP | debug 機能を復活させる時に resolver の Python を使う。 |
| terminal | shell は勝手に activate しない。必要なら別 command として `uv run` 等を使う。 |
| `:ConfigInfo` | resolver kind、fallback 使用有無、python、venv_path、run_prefix、source を表示する。 |

移行:

- `nvim_lsp_cfg/find_python.lua`, `venv.lua`, `poetry.lua` は Python resolver へ統合する。
- `pyright.before_init` は resolver 結果を反映するだけにする。
- poetry は初期実装対象から外す。必要なら `manual` か将来 resolver で対応する。

### Treesitter runtime 仕様決定

Treesitter は parser の install/update と runtime 起動の責務を分ける。
`tree-sitter-manager.nvim` は parser 管理に限定し、highlight 起動は Neovim builtin の `vim.treesitter.start()` で行う。

決定:

| 項目 | 決定 | メモ |
| --- | --- | --- |
| parser manager | `tree-sitter-manager.nvim` | install/remove/update 用。 |
| runtime 起動 | builtin `vim.treesitter.start()` | FileType autocmd で起動する。 |
| `nvim-treesitter` | 削除方向 | parser 管理も runtime 設定も移行する。 |
| parser list | 現行 list 維持 | 移行後に削るか判断する。 |
| start filetypes | parser list と分離 | `tsx` は parser 名、filetype は `typescriptreact`。 |
| `treesitter-context` | default off | 便利だが必須ではなく、軽量化方針では優先度を下げる。 |
| `treesitter-textobjects` | default on | `[f`, `]f`, `[F`, `]F` を使っているため残す。 |
| `[c` / `]c` 系 | 削除 | `gitsigns` に譲る。 |
| install/update command | 自前 command を用意 | `:TreesitterInstallConfigured`, `:TreesitterUpdateConfigured` を想定。 |

想定 config:

```jsonc
{
  "features": {
    "treesitter": {
      "enabled": true,
      "parser_manager": true,
      "runtime_highlight": true,
      "textobjects": true,
      "context": false
    }
  },
  "languages": {
    "treesitter": {
      "parsers": [
        "c",
        "cpp",
        "cmake",
        "make",
        "cuda",
        "glsl",
        "rust",
        "python",
        "latex",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "jsonc",
        "json5",
        "tsx",
        "toml",
        "yaml",
        "vim",
        "bash",
        "regex",
        "markdown",
        "markdown_inline"
      ],
      "start_filetypes": [
        "c",
        "cpp",
        "cmake",
        "make",
        "cuda",
        "glsl",
        "rust",
        "python",
        "latex",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "typescriptreact",
        "json",
        "jsonc",
        "json5",
        "toml",
        "yaml",
        "vim",
        "bash",
        "regex",
        "markdown"
      ],
      "textobjects": {
        "select": ["af", "if", "ac", "ic", "as"],
        "move": ["]f", "[f", "]F", "[F"]
      }
    }
  }
}
```

runtime 起動:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = config.get("languages.treesitter.start_filetypes"),
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
```

Textobjects keymap:

| key | 方針 |
| --- | --- |
| `af`, `if` | 残す |
| `ac`, `ic` | 残す |
| `as` | 残す |
| `[f`, `]f`, `[F`, `]F` | 残す |
| `[c`, `]c`, `[C`, `]C` | 削除。Git hunk 移動に譲る。 |

削除対象:

- `nvim-treesitter`

追加:

- `tree-sitter-manager.nvim`

default off:

- `nvim-treesitter-context`

### Git 機能仕様決定

Git 関連は `gitsigns.nvim`, `diffview.nvim`, `gitlinker.nvim` を残し、`messenger.nvim` は廃止する。

決定:

| plugin | 決定 | keymap / 起動方針 | メモ |
| --- | --- | --- | --- |
| `gitsigns.nvim` | 残す | 既存 keymap を維持 | hunk sign、stage/reset、preview、blame、diff、deleted 表示を継続。 |
| `messenger.nvim` | 廃止 | `<leader>gm` も削除 | GitHub notifications は不要。 |
| `diffview.nvim` | 残す | shortcut は追加しない。command line から起動 | 必要になったら後で keymap を追加検討。 |
| `gitlinker.nvim` | 残す | 既存 keymap を維持 | VSCode Neovim でも有効にする。 |

`gitsigns.nvim` keymap:

| key | 機能 |
| --- | --- |
| `]c` / `[c` | 次/前の hunk へ移動 |
| `<leader>hs` / `<leader>hr` | hunk stage/reset |
| `<leader>hS` / `<leader>hR` | buffer 全体 stage/reset |
| `<leader>hu` | hunk stage undo |
| `<leader>hp` | hunk preview |
| `<leader>hb` | 現在行 blame |
| `<leader>tb` | current line blame toggle |
| `<leader>hd` / `<leader>hD` | diff |
| `<leader>td` | deleted 行表示 toggle |
| `ih` | hunk textobject |

`gitlinker.nvim` keymap:

| key | 機能 |
| --- | --- |
| `<leader>gb` | 現在行/選択範囲の URL をブラウザで開く |
| `<leader>gY` | repository URL を取得 |
| `<leader>gB` | repository URL をブラウザで開く |

config:

```jsonc
{
  "features": {
    "git": {
      "enabled": true,
      "signs": true,
      "diff_view": true,
      "linker": true,
      "notifications": false
    }
  },
  "plugins": {
    "messenger.nvim": {
      "enabled": false
    }
  }
}
```

registry/env:

- `gitsigns.nvim`: `feature = "git.signs"`, `vscode = false`
- `diffview.nvim`: `feature = "git.diff_view"`, `vscode = false`
- `gitlinker.nvim`: `feature = "git.linker"`, `vscode = "any"`
- `messenger.nvim`: 削除対象

### Terminal 仕様決定

Terminal は `toggleterm.nvim` を残す。
Zellij 連携は廃止し、`<leader>z` で default shell を float terminal として開く。

決定:

| 項目 | 決定 | メモ |
| --- | --- | --- |
| backend | `toggleterm.nvim` | 残す。 |
| Zellij | 廃止 | `zellij attach -c ...` は使わない。 |
| default shell | `<leader>z` で起動 | 従来の keymap を維持し、起動対象だけ shell に変える。 |
| Codex | terminal から `codex` を起動できるようにする | toggleterm の別 Terminal として扱う。 |
| Codex keymap | `<leader>cx` | `<leader>cd` diagnostic と直接衝突しない keymap として採用。 |

想定 config:

```jsonc
{
  "features": {
    "terminal": {
      "enabled": true,
      "backend": "toggleterm",
      "default_shell": true,
      "codex": {
        "enabled": true,
        "cmd": "codex",
        "key": "<leader>cx"
      }
    }
  }
}
```

想定実装:

```lua
require("toggleterm").setup()

local Terminal = require("toggleterm.terminal").Terminal

local shell_term = Terminal:new({
  direction = "float",
  hidden = true,
})

vim.keymap.set("n", "<leader>z", function()
  shell_term:toggle()
end, { noremap = true, silent = true })

local codex_term = Terminal:new({
  cmd = "codex",
  direction = "float",
  hidden = true,
})

vim.keymap.set("n", "<leader>cx", function()
  codex_term:toggle()
end, { noremap = true, silent = true })
```

### Format 仕様決定

Format は `conform.nvim` を残す。
Neovim builtin の `vim.lsp.buf.format()` は LSP formatting を呼ぶには十分だが、外部 formatter の選択、formatter chain、format on save の制御、LSP fallback まで含めると `conform.nvim` の方が適している。

決定:

| 項目 | 決定 | メモ |
| --- | --- | --- |
| provider | `conform.nvim` | 残す。 |
| format on save | 維持 | default true。 |
| manual format key | `<space>f` | 既存 keymap を維持。 |
| LSP fallback | `lsp_format = "fallback"` | external formatter がない場合のみ LSP formatting に fallback。 |
| Python formatter chain | 維持 | `ruff_fix` + `ruff_format`、なければ `isort` + `black`。 |
| builtin formatting | fallback/補助扱い | conform を通さず直接主経路にはしない。 |
| Python resolver 連携 | 将来対応 | 初期は既存 formatter 実行方針を維持し、後で `run_prefix` 利用を検討。 |

想定 config:

```jsonc
{
  "features": {
    "format": {
      "enabled": true,
      "provider": "conform",
      "format_on_save": true,
      "manual_key": "<space>f",
      "lsp_format": "fallback"
    }
  }
}
```

初期 formatter:

| filetype | formatter |
| --- | --- |
| `python` | `ruff_fix` + `ruff_format`、なければ `isort` + `black` |
| `json` | `jq` |
| `cpp` | `clang-format` |
| `cuda` | `clang-format` |
| `lua` | `stylua` |
| `yaml` | `yamlfmt` |

実装メモ:

```lua
require("conform").setup({
  formatters_by_ft = {
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_fix", "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
    json = { "jq" },
    cpp = { "clang-format" },
    cuda = { "clang-format" },
    lua = { "stylua" },
    yaml = { "yamlfmt" },
  },
  format_on_save = {
    timeout_ms = 20000,
    lsp_format = "fallback",
  },
})
```

### UI 表示系仕様決定

UI 表示系は軽量表示に限定する。
`incline.nvim` と `nvim-web-devicons` は残し、colorscheme は builtin `vim` を維持する。
Greeter、animation、minimap、scrollbar、bufferline、window manager 系 plugin は廃止方向にする。

決定:

| 項目 | 決定 | メモ |
| --- | --- | --- |
| status/winbar 表示 | `incline.nvim` を残す | ファイル名、modified、Git 差分、diagnostic、icon 表示を維持。 |
| icon | `nvim-web-devicons` を残す | `incline.nvim` のために維持。 |
| colorscheme | builtin `vim` | colorscheme plugin は削除候補。 |
| `NormalFloat` / `SignColumn` | 背景調整を維持 | 現行の透明/背景調整を維持。 |
| popup border | 有効化したい | completion popup など Neovim 0.12 builtin UI の border をなるべく使う。 |
| `treesitter-context` | default off | `features.treesitter.context = false`。UI group ではなく Treesitter 側で管理。 |
| greeter/dashboard | 廃止 | `alpha-nvim` は削除候補。default greeter で十分。 |
| animation/smooth scroll | 廃止 | `neoscroll.nvim`, `specs.nvim`, `animation.nvim` は削除候補。 |
| minimap/scrollbar | 廃止 | `codewindow.nvim`, `nvim-scrollview` は削除候補。 |
| statusline/bufferline | `incline.nvim` のみ | `lualine.nvim`, `barbar.nvim` は削除候補。 |
| window UI | 廃止 | `windows.nvim`, `middleclass`, `animation.nvim` は削除候補。 |

`incline.nvim` の改善要件:

- 現状の不満は、1行目が長いと `incline.nvim` の表示が重なって編集しづらいこと。
- 特に bash/zsh の `Ctrl-x Ctrl-e` で Neovim を開いてコマンド編集するとき、1行目の長い command と incline が干渉する。
- 新構成では、1行目の編集体験を改善する。

改善案:

| 案 | 内容 | メモ |
| --- | --- | --- |
| hide 条件 | cursor が 1 行目にあり、かつ buffer が短い/terminal edit 用途っぽい場合は incline を隠す | 一番実用的。 |
| placement 調整 | top-right ではなく bottom/right などへ逃がす | 既存体験が変わる。 |
| render 簡略化 | 1行目ではファイル名だけ、または空表示にする | 状態表示を保ちつつ邪魔さを減らせる。 |
| filetype 条件 | `gitcommit`, `sh`, 一時ファイルなど特定 filetype で無効化 | `Ctrl-x Ctrl-e` の filetype 判定次第。 |

推奨は hide 条件。
具体的には、`props.win` の cursor position と buffer line count / filetype / buftype を見て、1行目の編集時は `return {}` に近い表示にする。

想定 config:

```jsonc
{
  "features": {
    "ui": {
      "enabled": true,
      "status": true,
      "icons": true,
      "theme": "vim",
      "animations": false,
      "greeter": false,
      "minimap": false,
      "scrollbar": false,
      "window_manager": false,
      "popup_border": true
    },
    "treesitter": {
      "context": false
    }
  }
}
```

残す:

- `incline.nvim`
- `nvim-web-devicons`
- builtin `vim` colorscheme
- `SignColumn` / `NormalFloat` 背景調整
- popup border 設定

削除候補:

- `tokyonight.nvim`
- `solarized-osaka.nvim`
- `neovim-ayu`
- `alpha-nvim`
- `neoscroll.nvim`
- `specs.nvim`
- `codewindow.nvim`
- `nvim-scrollview`
- `lualine.nvim`
- `barbar.nvim`
- `windows.nvim`
- `middleclass`
- `animation.nvim`

### LSP 管理仕様決定

LSP runtime は Neovim builtin の `vim.lsp` を使う。
`mason.nvim`, `mason-lspconfig.nvim`, `nvim-lspconfig` は残すが、役割は server install 管理と server 定義に寄せる。

決定:

| 項目 | 決定 | メモ |
| --- | --- | --- |
| LSP runtime | builtin `vim.lsp` | `vim.lsp.config()` / `vim.lsp.enable()` を主経路にする。 |
| server install 管理 | `mason.nvim` | 残す。 |
| Mason/LSP 対応 | `mason-lspconfig.nvim` | 残す。`automatic_enable = false` を維持。 |
| server 定義 | `nvim-lspconfig` | 残す。server 定義を自前管理しない。 |
| ensure list | 現状維持 | `clangd`, `pyright`, `ruff`, `jsonls`, `bashls`, `lua_ls`, `texlab`。 |
| enable 対象 | default は ensure list と同じ | 将来分けられるよう `enable = null` を許す。 |
| keymap | 現状維持 | 既存 LSP keymap を維持。 |
| diagnostics | 現状維持 | virtual text format、sign icon、jump 時 float を維持。 |
| document highlight | 維持 | server capability がある場合のみ。 |
| codelens | 維持 | server capability がある場合のみ。 |
| Python resolver | `pyright` に反映 | 初期は `settings.python.pythonPath` 中心。 |
| `vim-illuminate` | 削除候補 | builtin document highlight で代替。 |
| `lsp_signature` | 削除候補 | signature help は builtin `<C-k>` で扱う。 |

想定 config:

```jsonc
{
  "features": {
    "lsp": {
      "enabled": true,
      "runtime": true,
      "server_manager": "mason",
      "automatic_enable": false,
      "ensure_installed": [
        "clangd",
        "pyright",
        "ruff",
        "jsonls",
        "bashls",
        "lua_ls",
        "texlab"
      ],
      "enable": null,
      "diagnostics": {
        "virtual_text": true,
        "signs": true,
        "float_on_jump": true
      },
      "document_highlight": true,
      "codelens": true
    }
  }
}
```

役割分担:

| 役割 | 担当 |
| --- | --- |
| LSP client runtime | builtin `vim.lsp` |
| server config API | `vim.lsp.config()` |
| server enable | `vim.lsp.enable()` |
| server 定義 | `nvim-lspconfig` |
| server install 管理 | `mason.nvim` |
| Mason と LSP server 名の対応 | `mason-lspconfig.nvim` |

### 次回の推奨テーマ

次は実装に入る。
主要仕様は決定済みのため、`config layer`、`plugin_registry`、`vim.pack` 移行、plugin specs 整理の順に進める。

既に決めた config schema の決定:

| 論点 | 決定 | メモ |
| --- | --- | --- |
| schema version の場所 | top-level `version` | `schema_version` ではなく短い `version` にする。 |
| 機能設定の場所 | `features` | `modules` / `groups` ではなく、ユーザー意図としての機能を表す。 |
| 言語別設定の場所 | `languages.<name>` | `features.python` は on/off と概要、詳細は `languages.python` に置く。 |
| plugin 個別設定の key | short id | repo full name は registry に持つ。 |
| feature と plugin の優先順位 | plugin override 優先 | dependency 破壊時は warning/error。 |
| unknown key の扱い | default warning、strict mode error | typo 検出と運用しやすさの両立。 |
