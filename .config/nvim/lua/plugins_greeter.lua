local greeter = {}
local util = require("util")

greeter.setup = function(plugins)
  util.add_plugin(plugins, {
    "goolord/alpha-nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- require'alpha'.setup(require'alpha.themes.startify'.config)
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
    lazy = true,
    event = "BufWinEnter",
  }, {
    vscode = false,
  })

  return plugins
end

return greeter
