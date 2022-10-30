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

  -- indent-blankline.nvim
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append "eol:↴"
      require("indent_blankline").setup {
        -- -- 現在のスコープの色を変えるなら以下をコメントアウト
        -- show_current_context = true,
        -- show_current_context_start = true,
 
        show_end_of_line = true,
      }
    end,
  }

end

return brackets
