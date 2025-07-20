local brackets = {}

brackets.setup = function(plugins)
  table.insert(plugins, {
    "m4xshen/autoclose.nvim",
    config = function()
      require("autoclose").setup()
    end,
    lazy = true,
    event = "InsertEnter",
  })

  -- indent-blankline.nvim
  table.insert(plugins, {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
    lazy = true,
    event = "BufReadPost",
  })

  -- mini.indentscope.nvim
  table.insert(plugins, {
    "echasnovski/mini.indentscope",
    version = "*",
    config = function()
      require("mini.indentscope").setup()
    end,
    lazy = true,
    event = "BufReadPost",
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
