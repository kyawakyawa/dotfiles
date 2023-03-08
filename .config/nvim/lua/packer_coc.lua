local nvim_lsp = {}

nvim_lsp.setup = function(use)

  -- nvim-lspconfig & mason.nvim
  use {
    'neoclide/coc.nvim',
    branch = "release",
    config = function()
      require('coc_nvim_cfg/')
    end,
  }
end

return nvim_lsp  
