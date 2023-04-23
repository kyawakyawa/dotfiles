local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {}

-- plugins = require("hoge").setup(plugins)

 -- nvim lsp
plugins = require('plugins_nvim_lsp').setup(plugins)

-- complement
plugins = require('plugins_complement').setup(plugins)

-- fuzzy finder
plugins = require('plugins_fuzzy_finder').setup(plugins)

-- file explorer
plugins = require('plugins_file_explorer').setup(plugins)

 -- line
plugins = require('plugins_line').setup(plugins)

-- notify
plugins = require('plugins_notify').setup(plugins)


require("lazy").setup(plugins, opts)

--- local packer = require("packer")
--- -- コンパイルしたファイル./lua以下に置く
--- -- (VSCode Neovimで読まないようにするため)
--- -- (参考: https://github.com/wbthomason/packer.nvim/issues/933)
--- packer.init({ compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua"  })
--- 
--- -- packer.nvim
--- -- ~/.local/share/nvim/site/pack/packer/start
--- -- か
--- -- ~/.local/share/nvim/site/pack/packer/opt
--- -- にインストール
--- -- (startは起動時に読み込み, optは遅延して読み込む(packaddしたとき)
--- 
--- 
--- -- packer.nvim を
--- -- ~/.local/share/nvim/site/pack/packer/opt
--- -- にインストールした場合に以下が必要
--- 
--- -- vim.cmd [[packadd packer.nvim]]
--- 
--- return packer.startup(function(use)
---   -- Packer can manage itself
---   use 'wbthomason/packer.nvim'
-- 
---   -- line
---   require('packer_line').setup(use)
--- 
---   -- git
---   require('packer_git').setup(use)
--- 
---   -- brackets
---   require('packer_brackets').setup(use)
--- 
---   -- syntax highlight
---   require('packer_syntax_highlight').setup(use)
--- 
---   -- tokyonight colorscheme
---   require('packer_tokyonight').setup(use)
--- 
---   -- -- nightfox colorscheme
---   -- require('packer_nightfox').setup(use)
--- 
---   -- dap
---   require('packer_dap').setup(use)
--- 
---   -- term
---   require('packer_term').setup(use)
--- 
---   -- codewindow
---   require('packer_codewindow').setup(use)
--- 
---   -- notify
---   require('packer_notify').setup(use)
--- 
---   -- noice
---   require('packer_noice').setup(use)
--- 
--- end)
