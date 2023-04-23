local noice = {}

noice.setup = function(plugins)

  -- noice.nvim
  table.insert(plugins, {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        background_colour = "#000000",
        -- lsp signatureを無効化（他のプラグインを利用)
        lsp = {
          signature = {
            enabled = false,
          }
        },
        -- lsp signatureを有効にする場合以下をコメントアウト
        -- lsp = { -- https://www.reddit.com/r/neovim/comments/yfqtoi/weekly_noice_updates/
        --   override = {
        --     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        --     ["vim.lsp.util.stylize_markdown"] = true,
        --     ["cmp.entry.get_documentation"] = true,
        --   },
        -- },
      })
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      { "MunifTanjim/nui.nvim" },
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      { "rcarriga/nvim-notify" },
    },
    lazy = true,
    event = "VeryLazy",
  })

  return plugins
end

return noice
