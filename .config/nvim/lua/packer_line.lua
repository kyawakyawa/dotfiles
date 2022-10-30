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

  -- sidebar.nvim
  use ({
    'sidebar-nvim/sidebar.nvim',
    config = function()
      local sidebar = require("sidebar-nvim")
      sidebar.setup({
        sections = {
          "datetime",
          "git",
          "diagnostics",
          require("dap-sidebar-nvim.breakpoints")
        },
        dap = {
            breakpoints = {
                icon = "🔍"
            }
        }
      })

      local bufopts = { noremap=true }
      vim.keymap.set('n', '<space>s', require("sidebar-nvim").toggle, bufopts)
    end,
  })

  -- sections-dap
  use ({
    'sidebar-nvim/sections-dap',
  })

end

return line
