local complement = {}

complement.setup = function(plugins)

  -- nvim-cmp
  table.insert(plugins, {
    'hrsh7th/cmp-nvim-lsp'
  })
  table.insert(plugins, {
    'hrsh7th/cmp-nvim-lsp-signature-help'
  })
  table.insert(plugins, {
    'hrsh7th/cmp-buffer'
  })
  table.insert(plugins, {
    'hrsh7th/cmp-path'
  })
  table.insert(plugins, {
    'hrsh7th/cmp-cmdline'
  })
  table.insert(plugins, {
    'hrsh7th/cmp-nvim-lsp-document-symbol'
  })
  table.insert(plugins, {
    'hrsh7th/nvim-cmp',
    config = function()
      require('nvim_cmp_cfg')
    end,
  })

  -- Snippet
  table.insert(plugins, {
    'L3MON4D3/LuaSnip'
  })
  table.insert(plugins, {
    'saadparwaiz1/cmp_luasnip'
  })

  -- lspkind.nvim
  table.insert(plugins, {
    'onsails/lspkind.nvim'
  })

  return plugins

end

return complement
