local M = {}

local function win_config()
  local c = { type = "float" }
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines
  c.width = math.min(100, editor_width)
  c.height = math.min(24, editor_height)
  c.col = math.floor(editor_width * 0.5 - c.width * 0.5)
  c.row = math.floor(editor_height * 0.5 - c.height * 0.5)
  return c
end

function M.setup()
  require("diffview").setup({
    file_panel = {
      win_config = win_config,
    },
    file_history_panel = {
      win_config = win_config,
    },
    commit_log_panel = {
      win_config = win_config,
    },
  })
end

return M
