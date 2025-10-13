local which_key = {}
local util = require("util")

which_key.setup = function(plugins)
  -- which_key.nvim
  util.add_plugin(plugins, {
    "folke/which-key.nvim",
    lazy = true,
    event = "BufReadPost",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  }, {
    vscode = false,
  })

  return plugins
end

return which_key
