local format = {}

local config = require("util").load_config()

local format_on_save = nil
if config["format"]["format_on_save"] then
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 20000,
    lsp_format = "fallback",
  }
end

format.setup = function(plugins)
  table.insert(plugins, {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
              return { "ruff_fix", "ruff_format" }
            else
              return { "isort", "black" }
            end
          end,
          json = { "jq" },
          cpp = { "clang-format" },
          lua = { "stylua" },
        },
        format_on_save = format_on_save,
      })
      -- vim.keymap.set('n', '<space>f', require("conform").format)
    end,
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.bo.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    keys = {
      { "<space>f", "<cmd>lua require('conform').format()<cr>", desc = "format" },
    },
  })

  return plugins
end

return format
