local brackets = {}

brackets.setup = function(use)

  -- nvim-autopairs
  use {
	  "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}

      -- こうしないとC-hをBSの代わりに使うときにうまく動かない
      vim.api.nvim_set_keymap('i', '<C-h>', '<BS>', { noremap = false })
    end
  }

end

return brackets
