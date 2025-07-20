local hardtime = {}

util = require("util")

hardtime.setup = function(plugins)
  util.add_plugin(plugins, {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  }, {
    vscode = true,
  })
  return plugins
end

return hardtime
