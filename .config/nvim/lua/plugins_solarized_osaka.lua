local solarized_osaka = {}

solarized_osaka.setup = function(plugins)

  -- solarized_osaka
  table.insert(plugins, {
      "craftzdog/solarized-osaka.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("solarized-osaka").setup({
          transparent = true,
        })
        vim.cmd[[colorscheme solarized-osaka]]
      end,
  })

  return plugins
end

return solarized_osaka
