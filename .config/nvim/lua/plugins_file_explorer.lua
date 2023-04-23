local file_explorer = {}

file_explorer.setup = function(plugins)
  table.insert(plugins, {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
    -- TODO config
  })

  return plugins
end

return file_explorer
