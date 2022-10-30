local file_explorer = {}

file_explorer.setup = function(use)

  -- nvim-tree.lua
  use ({
    'kyazdani42/nvim-tree.lua',
    config = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded = 1
      vim.g.loaded_netrwPlugin = 1

      -- empty setup using defaults
      require("nvim-tree").setup{
        actions = {
          open_file = {
            window_picker = {
              enable = false, -- FIXME
              -- chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              -- exclude = {
              --   filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              --   buftype = { "nofile", "terminal", "help" },
              -- },
            },
          }
        }
      }

      local nt_api = require("nvim-tree.api")
      vim.keymap.set('n', '<space>e', nt_api.tree.toggle, { noremap=true, silent=true })
    end,
  })

end

return file_explorer
