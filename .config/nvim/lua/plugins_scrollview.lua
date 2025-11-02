local scrollview = {}
local util = require("util")

scrollview.setup = function(plugins)
  -- codewindow
  util.add_plugin(plugins, {
    "gorbit99/codewindow.nvim",
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({
        auto_enable = false,
        window_border = "rounded",
        minimap_width = 12,
      })
      codewindow.apply_default_keybinds()
    end,
    lazy = true,
    keys = {
      "<leader>m",
    },
  }, {
    vscode = false,
  })

  util.add_plugin(plugins, {
    "dstein64/nvim-scrollview",
    config = function()
      require("scrollview").setup({
        excluded_filetypes = { "neotree" },
        current_only = true,
        winblend = 0,
      })
    end,
    lazy = true,
    event = "BufReadPost",
  }, {
    vscode = false,
  })

  return plugins
end

return scrollview
