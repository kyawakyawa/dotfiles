local brackets = {}
local util = require("util")

brackets.setup = function(plugins)
  util.add_plugin(plugins, {
    "m4xshen/autoclose.nvim",
    config = function()
      require("autoclose").setup()
    end,
    lazy = true,
    event = "InsertEnter",
  }, {
    vscode = false,
  })

  -- indent-blankline.nvim
  util.add_plugin(plugins, {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
    lazy = true,
    event = "BufReadPost",
  }, {
    vscode = false,
  })

  -- mini.indentscope.nvim
  util.add_plugin(plugins, {
    "echasnovski/mini.indentscope",
    version = "*",
    config = function()
      require("mini.indentscope").setup()
    end,
    lazy = true,
    event = "BufReadPost",
  }, {
    vscode = false,
  })

  -- -- nvim-autopairs
  -- use {
  --  "windwp/nvim-autopairs",
  --   config = function()
  --     require("nvim-autopairs").setup {}

  --     -- こうしないとC-hをBSの代わりに使うときにうまく動かない
  --     vim.api.nvim_set_keymap('i', '<C-h>', '<BS>', { noremap = false })
  --   end
  -- }

  return plugins
end

return brackets
