local nvim_lsp = {}

nvim_lsp.setup = function(plugins)

  table.insert(plugins, {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    config = function() 
      require("nvim_lsp_cfg")
    end,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = {
		  { "mason-org/mason.nvim", opts = {} } ,
      { "neovim/nvim-lspconfig" },
      { "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup()
        end
      },
	  },
  })
  -- lspsage.nvim
  table.insert(plugins, {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require('lspsaga_cfg')
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    lazy=true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
  })
 
  -- -- lspsage.nvim
  -- use({
  --   "glepnir/lspsaga.nvim",
  --   branch = "main",
  --   config = function()
  --     require('lspsaga_cfg')
  --   end,
  --   requires = { {"nvim-tree/nvim-web-devicons"} }
  -- })

  -- -- trouble.nvim
  -- use {
  --   "folke/trouble.nvim",
  --   config = function()
  --     require("trouble").setup {
  --       -- your configuration comes here
  --       -- or leave it empty to use the default settings
  --       -- refer to the configuration section below
  --     }
  --   end
  -- }

  -- -- lsp_signature.nvim
  -- use {
  --   "ray-x/lsp_signature.nvim",
  --   config = function()
  --     local signature_config = {
  --       log_path = vim.fn.expand("$HOME") .. "/sig.log",
  --       debug = false,
  --       hint_enable = false,
  --       handler_opts = { border = "single" },
  --       max_width = 80,
  --     }

  --     require("lsp_signature").setup(signature_config)
  --   end
  -- }
  return plugins
end

return nvim_lsp  
