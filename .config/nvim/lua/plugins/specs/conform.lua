local config = require("config")

local M = {}

function M.setup()
  local format_cfg = config.get("features.format", {})
  local format_on_save = nil

  if format_cfg.format_on_save then
    format_on_save = {
      timeout_ms = 20000,
      lsp_format = format_cfg.lsp_format or "fallback",
    }
  end

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
      cuda = { "clang-format" },
      lua = { "stylua" },
      yaml = { "yamlfmt" },
    },
    format_on_save = format_on_save,
  })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.keymap.set("n", format_cfg.manual_key or "<space>f", function()
    require("conform").format()
  end, { desc = "format" })
end

return M
