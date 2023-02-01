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
    requires = { {"nvim-tree/nvim-web-devicons"} }
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

  -- lsp_signature.nvim
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      local signature_config = {
        log_path = vim.fn.expand("$HOME") .. "/sig.log",
        debug = false,
        hint_enable = false,
        handler_opts = { border = "single" },
        max_width = 80,
      }

      require("lsp_signature").setup(signature_config)
    end
  }

  -- lsp_line.nvim
  use ({
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      require("lsp_lines").setup()

      -- for lualine.nvim
      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = { only_current_line = true }
      })
    end,
  })

  -- fidget.nvim
  use ({
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup()
    end,
  })


end

return nvim_lsp  
