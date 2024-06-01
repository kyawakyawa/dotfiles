local copilot = {}

copilot.setup = function(plugins)

  -- copilotsigns.nvim
  table.insert(plugins, {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  })

  return plugins
end

return copilot
