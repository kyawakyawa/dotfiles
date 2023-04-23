local scrollview = {}

scrollview.setup = function(plugins)
    -- codewindow
    table.insert(plugins, {
      'gorbit99/codewindow.nvim',
      config = function()
        local codewindow = require('codewindow')
        codewindow.setup({
          auto_enable = false,
          window_border = 'rounded',
          minimap_width = 12,
        })
        codewindow.apply_default_keybinds()
      end,
      lazy = true,
      keys = {
        "<leader>m"
      },
    })

    table.insert(plugins, {
      "dstein64/nvim-scrollview",
      config = function()
        require('scrollview').setup({
          excluded_filetypes = {'neotree'},
          current_only = true,
          winblend = 0,
        })
      end,
      lazy = true,
	    event = "BufReadPost",
    })

    return plugins
end

return scrollview
