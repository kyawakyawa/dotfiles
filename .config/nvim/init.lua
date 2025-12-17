-- cacheの設定 (https://zenn.dev/kawarimidoll/articles/19bfc63e1c218c)
if vim.loader then
  vim.loader.enable()
end

vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cindent = true
vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.smartindent = true
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.laststatus = 3 -- https://wed.dev/blog/posts/neovim-statuline

-- Disable some language provider
-- Python provider 完全オフ
vim.g.loaded_python3_provider = 0
-- もしPython providerを使う場合は以下を書く(Pyenv環境だとshimが遅くて起動が遅れるので使うPythonを明示的に指定する)
-- vim.g.python3_host_prog = '/usr/bin/python3'
-- その他使わないproviderもオフにする
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- leaderの設定
vim.g.mapleader = ","
-- vim.g.mapleader = " " -- スペースに設定
vim.api.nvim_set_keymap("n", "\\", ",", { noremap = true })


-- user config
local init_dir = vim.fn.fnamemodify(vim.fn.expand("<sfile>:p"), ":h")
require("util").set_default_config_path(init_dir .. "/default_config.json")
vim.api.nvim_create_user_command("ConfigInfo", require("util").print_config_path, {})

if not vim.g.vscode then
  -- For OpenCL
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.cl" },
    callback = function()
      vim.bo.filetype = "cl"
    end,
  })

  vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
end

-- Plugins
require("plugins") -- プラグインの読み込み

-- WSLの時の+/*レジスタの設定
if require("util").isWSL() then
  vim.g.clipboard = {
    -- Windows側にwin32yank.exeを置き、WSL側にシンボリックリンク /usr/local/bin/win32yank を作成
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank -i --crlf",
      ["*"] = "win32yank -i --crlf",
    },
    paste = {
      ["+"] = "win32yank -o --lf",
      ["*"] = "win32yank -o --lf",
    },
    cache_enable = 0,
  }
end

if require("util").isWSL() or vim.fn.has("win32") ~= 0 then
  --WSL or Windows の時

  -- Windows側にzenhan.exeを置き、WSL側にシンボリックリンク /usr/local/bin/zenhan を作成
  -- For IME
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*" },
    callback = function()
      vim.fn.system("zenhan 0")
    end,
  })
elseif require("util").OSX() then
  -- Macの時
  -- For IME
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*" },
    callback = function()
      -- vim.fn.system("im-select com.apple.inputmethod.Kotoeri.RomajiTyping.Roman")
      vim.fn.system("/opt/homebrew/bin/im-select com.apple.keylayout.ABC")
    end,
  })
else
  -- Linuxのとき
  -- For IME
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*" },
    callback = function()
      vim.fn.system("fcitx5-remote -c")
    end,
  })
end
