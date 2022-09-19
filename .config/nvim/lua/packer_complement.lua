local complement = {}

complement.setup = function(use)

  -- nvim-cmp
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use ({
    'hrsh7th/nvim-cmp',
    config = function()
      require('nvim_cmp_cfg')
    end,
  })

  -- Snippet
  use 'L3MON4D3/LuaSnip'
  use'saadparwaiz1/cmp_luasnip'

  -- lspkind.nvim
  use 'onsails/lspkind.nvim'

end

return complement
