local nvim_lsp = {}

nvim_lsp.setup = function(use)

  -- nvim-lspconfig
  use 'neovim/nvim-lspconfig'

  -- lspsage.nvim
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
        local saga = require("lspsaga")

        saga.init_lsp_saga({
            -- your configuration
        })
    end,
  })

  -- mason.nvim
  use "williamboman/mason.nvim"

end

return nvim_lsp  
