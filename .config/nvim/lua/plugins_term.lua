local term = {}

term.setup = function(plugins)

  -- toggleterm.nvim
  table.insert (plugins, {
    'akinsho/toggleterm.nvim',
    config = function(use)
      require("toggleterm").setup()


      local Terminal = require("toggleterm.terminal").Terminal

      local term = Terminal:new({
      	-- cmd = "lazygit",
      	direction = "float",
      	hidden = true
      })

      local term_toggle = function()
        term:toggle()
      end

      local bufopts = { noremap=true }
      vim.keymap.set('n', '<C-j>', term_toggle, bufopts)
    end,
    lazy = true,
    keys = {
      "<C-j>"
    }
  })

  return plugins
end

return term
