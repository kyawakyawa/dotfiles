local complement = {}

complement.setup = function(plugins)

  table.insert(plugins, {
    'hrsh7th/nvim-cmp',
    config = function()
      require('nvim_cmp_cfg')
    end,
    lazy = true,
    event = "InsertEnter",
    dependencies = {
      -- apearance
      { 'onsails/lspkind.nvim',
        dependencies = {
          'nvim-tree/nvim-web-devicons',
        }
      },
      -- source
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
      { "f3fora/cmp-spell" },
      { "ray-x/cmp-treesitter" },
      -- snippet
      { 'L3MON4D3/LuaSnip'},
      { 'saadparwaiz1/cmp_luasnip'},
    }
  })
  return plugins

end

return complement
