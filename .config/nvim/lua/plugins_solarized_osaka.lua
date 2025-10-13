local solarized_osaka = {}
local util = require("util")

solarized_osaka.setup = function(plugins)
  -- solarized_osaka
  util.add_plugin(plugins, {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized-osaka").setup({
        transparent = true,
      })
      vim.cmd([[colorscheme solarized-osaka]])
    end,
  }, {
    vscode = false,
  })

  return plugins
end

return solarized_osaka
