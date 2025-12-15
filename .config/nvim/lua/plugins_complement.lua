local complement = {}
local util = require("util")
local config = util.load_config()

complement.setup = function(plugins)
  if config["plugins"]["complement"]["engine"] == "nvim-cmp" then
    util.add_plugin(plugins, {
      "hrsh7th/nvim-cmp",
      config = function()
        require("nvim_cmp_cfg")
      end,
      lazy = true,
      event = "InsertEnter",
      dependencies = {
        -- apearance
        {
          "onsails/lspkind.nvim",
          dependencies = {
            "nvim-tree/nvim-web-devicons",
          },
        },
        -- source
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        -- { "ray-x/cmp-treesitter" },
        -- snippet
        { "L3MON4D3/LuaSnip" },
        { "saadparwaiz1/cmp_luasnip" },
      },
    }, {
      vscode = false,
    })
  elseif config["plugins"]["complement"]["engine"] == "blink-cmp" then
    util.add_plugin(plugins, {
      "saghen/blink.cmp",
      -- optional: provides snippets for the snippet source
      dependencies = { "rafamadriz/friendly-snippets" },

      -- use a release tag to download pre-built binaries
      version = "1.*",
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = "default" },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono",
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },
      },
      opts_extend = { "sources.default" },
    })
  end
  return plugins
end

return complement
