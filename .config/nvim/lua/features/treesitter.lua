local config = require("config")

local M = {}

function M.setup()
  if not config.is_feature_enabled("treesitter.runtime_highlight") then
    return
  end

  vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

  vim.treesitter.language.register("json", "jsonc")
  vim.treesitter.language.register("tsx", "typescriptreact")

  local filetypes = config.get("languages.treesitter.start_filetypes", {})
  if vim.tbl_isempty(filetypes) then
    return
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("builtin_treesitter_start", { clear = true }),
    pattern = filetypes,
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return M
