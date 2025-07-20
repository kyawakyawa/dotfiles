local syntax_highlight = {}

syntax_highlight.setup = function(plugins)
  -- -- nvim-ts-rainbow
  -- use ({
  --   "p00f/nvim-ts-rainbow"
  -- })

  -- todo-comments.nvim
  table.insert(plugins, {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
    lazy = true,
    event = "BufReadPost",
  })

  -- vim-illuminate
  table.insert(plugins, {
    "RRethy/vim-illuminate",
    lazy = true,
    event = "BufReadPost",
  })

  return plugins
end

return syntax_highlight
