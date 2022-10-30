local codewindow = {}

codewindow.setup = function(use)
    use {
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
    }
end

return codewindow
