local deps = {}

deps.setup = function(plugins)

  -- plenary.nvim
  table.insert(plugins, {
    'nvim-lua/plenary.nvim'
  })

  -- nvim-web-devicons
  table.insert(plugins, {
    'nvim-tree/nvim-web-devicons'
  })

  -- nui.nvim
  table.insert(plugins, {
    'MunifTanjim/nui.nvim'
  })

  return plugins 
end

return deps
