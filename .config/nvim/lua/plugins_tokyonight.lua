local tokyonight = {}
local util = require("util")

tokyonight.setup = function(plugins)
  -- tokyonight
  util.add_plugin(plugins, {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
    lazy = true,
    event = "VeryLazy",
  }, {
    vscode = false,
  })

  return plugins
end

return tokyonight
