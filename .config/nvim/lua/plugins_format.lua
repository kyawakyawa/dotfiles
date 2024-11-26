local format = {}

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
          cpp = { "clang-format" }
        },
        format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 20000,
          lsp_format = "fallback",
        },
      })
    end,
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.bo.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    lazy=true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
  })
  
  return plugins
end

return format
