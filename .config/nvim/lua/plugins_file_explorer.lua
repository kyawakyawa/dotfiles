local file_explorer = {}
local util = require("util")

file_explorer.setup = function(plugins)
  util.add_plugin(plugins, {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    -- TODO config
    lazy = true,
    keys = {
      {
        "<space>e",
        "<cmd>Neotree toggle source=filesystem reveal=true position=left<cr>",
        desc = "NeoTree",
      },
      -- { "<space>b", "<cmd>Neotree toggle source=buffer reveal=true position=float<cr>", desc = "NeoTree buf" },
      {
        "<space>g",
        "<cmd>Neotree toggle source=git_status reveal=true position=left <cr>",
        desc = "NeoTree git",
      },
    },
    config = function()
      require("neo-tree").setup({
        default_component_configs = {
          window = {
            -- position = "float",
          },
        },
      })
    end,
  }, {
    vscode = false,
  })

  return plugins
end

return file_explorer
