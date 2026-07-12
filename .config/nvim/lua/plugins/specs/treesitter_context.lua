local M = {}

function M.setup()
  require("treesitter-context").setup({
    enable = true,
    max_lines = 5,
    min_window_height = 3,
  })
end

return M
