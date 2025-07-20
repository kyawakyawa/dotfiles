local tokyonight = {}

tokyonight.setup = function(plugins)
  -- tokyonight
  table.insert(plugins, {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
    lazy = true,
    event = "VeryLazy",
  })

  return plugins
end

return tokyonight
