# Neovim config memo

この README は `init.lua` を起点に、実際に読み込まれる設定を忘れないためのメモです。
コメントアウトされていて `require` されない plugin 設定は対象外です。

## 起動時の基本設定

- `vim.loader` が使える場合は有効化して Lua の読み込みを高速化する。
- 行番号、スペースインデント、`tabstop=2` / `shiftwidth=2`、検索ハイライト、カーソル行、`termguicolors`、グローバルステータスラインを有効化する。
- Python / Node / Perl / Ruby provider は使わない前提で無効化している。
- leader は `,`。
- ノーマルモードの `\` は `,` にマップされている。
- `:ConfigInfo` で、この設定が見つけたプロジェクトローカル設定ファイルを表示する。
- OpenCL の `*.cl` は filetype を `cl` にする。
- VSCode ではない通常の Neovim では、ターミナルモードの `<ESC>` でノーマルモードへ戻る。
- Goneovim では `<D-v>` をノーマル / インサート / コマンドラインでクリップボード貼り付けに使う。
- WSL では `win32yank` を `+` / `*` レジスタに使う。
- インサートモードを抜けたとき、環境に応じて IME を英数に戻す。
  WSL / Windows は `zenhan 0`、macOS は `im-select com.apple.keylayout.ABC`、Linux は `fcitx5-remote -c`。

## 設定ファイル

既定値は `default_config.json` から読む。
プロジェクト配下に `.nvim/config.json` がある場合は、上位ディレクトリを探索して見つけたものを既定値にマージする。

既定では次の状態になっている。

- 補完: 有効、engine は `blink-cmp`
- ファイラ: `yazi.nvim`
- format on save: 有効
- colorscheme: `vim`

## 読み込まれるプラグイン

### LSP

`mason.nvim`、`mason-lspconfig.nvim`、`nvim-lspconfig` を使う。
`BufReadPost` / `BufAdd` / `BufNewFile` で読み込まれる。

自動インストール対象の LSP は次の通り。

- `clangd`
- `pyright`
- `ruff`
- `jsonls`
- `bashls`
- `lua_ls`

`clangd` は `--background-index`、`--header-insertion=never`、`--pch-storage=memory`、`--clang-tidy` 付きで起動する。
Python は上位に `.venv` が見つかれば、その環境を `pyright` の `venvPath` / `pythonPath` に使う。
診断は virtual text に `message (source: code)` 形式で表示する。

### 補完

既定では `blink.cmp` を使う。
source は `lsp`、`path`、`snippets`、`buffer`。
`friendly-snippets` も入る。

`default_config.json` または `.nvim/config.json` で `plugins.complement.engine` を `nvim-cmp` にすると、`nvim-cmp` 系に切り替わる。
その場合は `lspkind.nvim`、`LuaSnip`、`cmp-nvim-lsp`、`cmp-buffer`、`cmp-path`、`cmp-cmdline` などを使う。

### ファジーファインダ

`telescope.nvim` を使う。
`find_files` の探索コマンドは設定ファイルの `plugins.fuzzy_finder.telescope.find_command` を使う。
既定では `rg --files --hidden`。

### ファイル操作

既定では `yazi.nvim` を使う。
`plugins.file_explorer.name` が `yazi` 以外の場合は `neo-tree.nvim` を使う分岐がある。

### 表示

`incline.nvim` を使う。
右上付近のバッファ表示に、ファイル名、変更状態、Git 差分数、診断数、filetype icon を表示する。
Git 差分は `gitsigns.nvim`、アイコンは `nvim-web-devicons` に依存する。

### Git

次の Git 関連プラグインを使う。

- `gitsigns.nvim`: hunk の移動、stage / reset、blame、diff、deleted 行表示
- `messenger.nvim`: GitHub の通知表示
- `diffview.nvim`: diff / history UI
- `gitlinker.nvim`: 現在行や選択範囲、リポジトリの URL を取得 / ブラウザで開く

### 括弧

`autoclose.nvim` を使う。
インサートモードに入ったタイミングで読み込まれ、括弧やクォートを自動で閉じる。

### Treesitter

`nvim-treesitter`、`nvim-treesitter-context`、`nvim-treesitter-textobjects` を使う。

parser は C / C++ / CMake / Make / CUDA / GLSL / Rust / Python / Lua / HTML / CSS / JavaScript / TypeScript / JSON / JSONC / JSON5 / TSX / TOML / YAML / Vim / Bash / Regex / Markdown を対象にする。
highlight は有効で、parser の auto install も有効。

`treesitter-context` は現在位置の関数やクラスなどの文脈を最大 5 行まで上部に表示する。

### ターミナル

`toggleterm.nvim` を使う。
現在の cwd の basename から `<basename>-neovim` という zellij session 名を作り、float terminal で `zellij attach -c` する。

### フォーマット

`conform.nvim` を使う。
既定では保存時フォーマットが有効。
手動フォーマット用のキーもある。

filetype ごとの formatter は次の通り。

- Python: `ruff_format` があれば `ruff_fix` + `ruff_format`、なければ `isort` + `black`
- JSON: `jq`
- C++ / CUDA: `clang-format`
- Lua: `stylua`
- YAML: `yamlfmt`

## キーマップ

### 共通

| mode | key | 動作 |
| --- | --- | --- |
| normal | `\` | `,` として扱う |
| terminal | `<ESC>` | terminal mode から normal mode へ戻る |
| normal / insert / command | `<D-v>` | Goneovim でクリップボード貼り付け |

### LSP

LSP が attach したバッファで有効になる。

| mode | key | 動作 |
| --- | --- | --- |
| normal | `gD` | 宣言へ移動 |
| normal | `gd` | 定義へ移動 |
| normal | `K` | hover 表示 |
| normal | `gh` | references |
| normal | `gi` | implementation |
| normal | `<C-k>` | signature help |
| normal | `<space>wa` | workspace folder 追加 |
| normal | `<space>wr` | workspace folder 削除 |
| normal | `<space>wl` | workspace folder 一覧表示 |
| normal | `<space>D` | type definition |
| normal | `<space>rn` | rename |
| normal | `<space>ca` | code action |
| normal | `<leader>cd` | 現在行の diagnostic float |
| normal | `[d` | 前の diagnostic へ移動し、float 表示 |
| normal | `]d` | 次の diagnostic へ移動し、float 表示 |

### Telescope

`<leader>` は `,`。

| mode | key | 動作 |
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

### ファイラ

既定の `yazi.nvim` のキー。

| mode | key | 動作 |
| --- | --- | --- |
| normal / visual | `<leader>-` | 現在ファイル位置で Yazi を開く |
| normal | `<leader>cw` | Neovim の cwd で Yazi を開く |
| normal | `<C-Up>` | 最後の Yazi session を再開 / toggle |

`neo-tree.nvim` に切り替えた場合のキー。

| mode | key | 動作 |
| --- | --- | --- |
| normal | `<space>e` | filesystem tree を左に toggle |
| normal | `<space>g` | git status tree を左に toggle |

### Git

`gitsigns.nvim` のキー。

| mode | key | 動作 |
| --- | --- | --- |
| normal | `]c` | 次の hunk |
| normal | `[c` | 前の hunk |
| normal / visual | `<leader>hs` | hunk を stage |
| normal / visual | `<leader>hr` | hunk を reset |
| normal | `<leader>hS` | buffer 全体を stage |
| normal | `<leader>hu` | hunk の stage を undo |
| normal | `<leader>hR` | buffer 全体を reset |
| normal | `<leader>hp` | hunk preview |
| normal | `<leader>hb` | 現在行の blame |
| normal | `<leader>tb` | current line blame の toggle |
| normal | `<leader>hd` | 現在ファイルの diff |
| normal | `<leader>hD` | `~` との差分 |
| normal | `<leader>td` | deleted 行表示の toggle |
| operator / visual | `ih` | hunk text object |

その他の Git キー。

| mode | key | 動作 |
| --- | --- | --- |
| normal | `<leader>gm` | messenger.nvim の通知表示 |
| normal | `<leader>gb` | 現在行の URL をブラウザで開く |
| visual | `<leader>gb` | 選択範囲の URL をブラウザで開く |
| normal | `<leader>gY` | repository URL を取得 |
| normal | `<leader>gB` | repository URL をブラウザで開く |

### Treesitter textobjects

| mode | key | 動作 |
| --- | --- | --- |
| visual / operator | `af` | function outer |
| visual / operator | `if` | function inner |
| visual / operator | `ac` | class outer |
| visual / operator | `ic` | class inner |
| visual / operator | `as` | scope |
| normal | `]f` | 次の function 開始へ |
| normal | `]F` | 次の function 終了へ |
| normal | `[f` | 前の function 開始へ |
| normal | `[F` | 前の function 終了へ |
| normal | `]c` | 次の class 開始へ |
| normal | `]C` | 次の class 終了へ |
| normal | `[c` | 前の class 開始へ |
| normal | `[C` | 前の class 終了へ |

`[c` / `]c` は `gitsigns.nvim` でも使っているため、実際の挙動は読み込み状況とバッファの状態に依存する。

### ターミナル

| mode | key | 動作 |
| --- | --- | --- |
| normal | `<leader>z` | zellij session を float terminal で toggle |

### フォーマット

| mode | key | 動作 |
| --- | --- | --- |
| normal | `<space>f` | `conform.format()` |

### 補完

`blink.cmp` は `keymap.preset = "default"`。
主に次のキーを使う。

| mode | key | 動作 |
| --- | --- | --- |
| insert | `<C-Space>` | menu を開く。menu 表示中は docs を開く |
| insert | `<C-n>` / `<C-p>` | 次 / 前の候補 |
| insert | `<Up>` / `<Down>` | 次 / 前の候補 |
| insert | `<C-y>` | 確定 |
| insert | `<C-e>` | menu を閉じる |
| insert | `<C-k>` | signature help toggle |

`nvim-cmp` に切り替えた場合は次のキーを使う。

| mode | key | 動作 |
| --- | --- | --- |
| insert | `<C-b>` | docs を上へスクロール |
| insert | `<C-f>` | docs を下へスクロール |
| insert | `<C-Space>` | 補完開始 |
| insert | `<C-e>` | 補完中止 |
| insert | `<CR>` | 選択中の候補を確定 |
| insert / select | `<Tab>` | 候補確定、snippet jump、または補完開始 |
| insert / select | `<S-Tab>` | 前候補、または snippet の前位置へ |

## コマンド

| command | 動作 |
| --- | --- |
| `:ConfigInfo` | 読み込まれる `.nvim/config.json` のパスを表示 |
| `:MyTSInstall` | Treesitter parser をまとめて update / install |
