local codewindow = {}

codewindow.setup = function(use)
    use {
      'gorbit99/codewindow.nvim',
      config = function()
        local codewindow = require('codewindow')
        codewindow.setup()
        codewindow.apply_default_keybinds()
      end,
    }
end

return codewindow
