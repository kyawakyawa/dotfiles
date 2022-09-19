local line = {}

line.setup = function(use)

  -- lualine.nvim
  use ({
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine_cfg')
    end,
  })

  -- barbar.nvim
  use 'romgrk/barbar.nvim'

end

return line
