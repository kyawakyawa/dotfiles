local nvim_lsp = {}
local util = require("util")

nvim_lsp.setup = function(plugins)
  util.add_plugin(plugins, {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    config = function()
      require("nvim_lsp_cfg")
    end,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "neovim/nvim-lspconfig" },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup()
        end,
      },
    },
  }, {
    vscode = false,
  })

  -- lspsage.nvim
  util.add_plugin(plugins, {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga_cfg")
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
  }, {
    vscode = false,
  })

  return plugins
end

return nvim_lsp
