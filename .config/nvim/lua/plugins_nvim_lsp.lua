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
    },
  }, {
    vscode = false,
  })

  return plugins
end

return nvim_lsp
