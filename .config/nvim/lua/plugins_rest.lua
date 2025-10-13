local rest = {}
local util = require("util")

-- rest.setup = function(plugins)
--   return plugins
-- end

rest.setup = function(plugins)
  -- rest.nvim
  util.add_plugin(plugins, {
    "rest-nvim/rest.nvim",
    dependencies = {
      "j-hui/fidget.nvim",
    },
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
  }, {
    vscode = false,
  })

  return plugins
end

return rest
