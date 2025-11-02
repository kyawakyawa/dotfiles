local ayu = {}
local util = require("util")

ayu.setup = function(plugins)
  -- ayu
  util.add_plugin(plugins, {
    "Shatur/neovim-ayu",
    config = function()
      require("ayu").setup({
        mirage = true,
        terminal = true,
        overrides = {
          Normal = { bg = "None" },
          NormalFloat = { bg = "none" },
          ColorColumn = { bg = "None" },
          SignColumn = { bg = "None" },
          Folded = { bg = "None" },
          FoldColumn = { bg = "None" },
          CursorLine = { bg = "None" },
          CursorColumn = { bg = "None" },
          VertSplit = { bg = "None" },
        },
      })
      vim.cmd([[colorscheme ayu-light]])
    end,
    lazy = true,
    event = "VeryLazy",
  }, {
    vscode = false,
  })

  return plugins
end

return ayu
