local which_key = {}

which_key.setup = function(plugins)

  -- which_key.nvim
  table.insert(plugins, {
    "folke/which-key.nvim",
    lazy = true,
    event = "BufReadPost",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  })

  return plugins
end

return which_key
