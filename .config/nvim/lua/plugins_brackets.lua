local brackets = {}

brackets.setup = function(plugins)
  table.insert(plugins, {
    "m4xshen/autoclose.nvim",
    config = function()
      require("autoclose").setup()
    end,
    lazy = true,
  	event = "InsertEnter",
  })

  -- indent-blankline.nvim
  table.insert(plugins, {
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
	  lazy = true,
	  event = "BufReadPost", 
  })

  -- mini.indentscope.nvim
  table.insert(plugins, { 
    'echasnovski/mini.indentscope', 
    version = '*',
    config = function()
      require('mini.indentscope').setup()
    end,
    lazy = true,
	  event = "BufReadPost", 
  })

  -- -- nvim-autopairs
  -- use {
	 --  "windwp/nvim-autopairs",
  --   config = function()
  --     require("nvim-autopairs").setup {}

  --     -- こうしないとC-hをBSの代わりに使うときにうまく動かない
  --     vim.api.nvim_set_keymap('i', '<C-h>', '<BS>', { noremap = false })
  --   end
  -- }

  return plugins

end

return brackets
