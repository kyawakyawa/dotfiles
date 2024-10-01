local rest = {}

-- rest.setup = function(plugins)
--   return plugins
-- end

rest.setup = function(plugins)

  -- rest.nvim
  table.insert(plugins, {
    "rest-nvim/rest.nvim",
    dependencies = {
      "j-hui/fidget.nvim",
    },
    lazy=true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
  })
 
  return plugins
end

return rest
