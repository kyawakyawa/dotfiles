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

end

return nvim_lsp  
