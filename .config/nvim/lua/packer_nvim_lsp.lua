local nvim_lsp = {}

nvim_lsp.setup = function(use)

  -- nvim-lspconfig & mason.nvim
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  -- lspsage.nvim
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require('lspsaga_cfg')
    end,
  })

  -- trouble.nvim
  use {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }


end

return nvim_lsp  
