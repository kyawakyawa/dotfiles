local lazypath = vim.fn.stdpath("data") .. "/lazy_dev/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

local config = require("util").load_config()

local plugins = {}

-- plugins = require("hoge").setup(plugins)

-- nvim lsp
plugins = require("plugins_nvim_lsp").setup(plugins)

-- complement
if config["plugins"]["complement"]["enabled"] then
  -- if config["plugins"]["complement"]["engine"] then
  -- end
  plugins = require("plugins_complement").setup(plugins)
end

-- copilot
if config["plugins"]["aiAssistant"]["githubCopilot"]["enabled"] then
  plugins = require("plugins_copilot").setup(plugins)
end

-- avante.nvim
if config["plugins"]["aiAssistant"]["avante"]["enabled"] then
  plugins = require("plugins_avante").setup(plugins)
end

-- fuzzy finder
plugins = require("plugins_fuzzy_finder").setup(plugins)

-- file explorer
plugins = require("plugins_file_explorer").setup(plugins)

-- line
plugins = require("plugins_line").setup(plugins)

-- git
plugins = require("plugins_git").setup(plugins)

-- brackets
plugins = require("plugins_brackets").setup(plugins)

-- -- syntax highlight
-- plugins = require("plugins_syntax_highlight").setup(plugins)

-- nvim treesitter
plugins = require("plugins_nvim_treesitter").setup(plugins)

-- if config["colorscheme"]["name"] == "tokyonight" then
--   -- tokyonight colorscheme
--   plugins = require("plugins_tokyonight").setup(plugins)
-- elseif config["colorscheme"]["name"] == "solarized" then
--   -- soralized osaka colorscheme
--   plugins = require("plugins_solarized_osaka").setup(plugins)
-- elseif config["colorscheme"]["name"] == "ayu" then
--   -- ayu colorscheme
--   plugins = require("plugins_ayu").setup(plugins)
-- elseif config["colorscheme"]["name"] == "vim" then
--   vim.api.nvim_create_autocmd("ColorScheme", {
--     pattern = "*",
--     callback = function()
--       -- colorschemeの設定が呼ばれるたびにSignColumnの背景色をNONEにする
--       vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", fg = "NONE" })
--
--       -- Foating windowの背景の色の設定
--       vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", fg = "NONE" })
--     end,
--   })
--
--   vim.cmd([[colorscheme vim]])
-- end

-- -- dap
-- plugins = require("plugins_dap").setup(plugins)

-- -- rsync
-- plugins = require("plugins_rsync").setup(plugins)

-- -- term
-- plugins = require("plugins_term").setup(plugins)

-- -- scrollview
-- plugins = require("plugins_scrollview").setup(plugins)

-- notify
plugins = require("plugins_notify").setup(plugins)

-- -- noice
-- plugins = require("plugins_noice").setup(plugins)

-- -- animation
-- if config["plugins"]["animation"]["enabled"] then
--   plugins = require("plugins_animation").setup(plugins)
-- end

-- -- greeter
-- plugins = require("plugins_greeter").setup(plugins)

-- -- which-key.nvim
-- plugins = require("plugins_which_key").setup(plugins)

-- -- -- window
-- -- plugins = require("plugins_window").setup(plugins)

-- -- rest
-- if config["plugins"]["rest"]["enabled"] then
--   plugins = require("plugins_rest").setup(plugins)
-- end

-- format
plugins = require("plugins_format").setup(plugins)

-- -- json5
-- plugins = require("plugins_json5").setup(plugins)
--
-- -- hardtime
-- if config["plugins"]["inputBehavior"]["hardtime"]["enabled"] then
--   plugins = require("plugins_hardtime").setup(plugins)
-- end

-- HACK
local opts = {
  root = vim.fn.stdpath("data") .. "/lazy_dev"
}

require("lazy").setup(plugins, opts)
