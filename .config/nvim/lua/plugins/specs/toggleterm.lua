local config = require("config")

local M = {}

function M.setup()
  require("toggleterm").setup()

  local Terminal = require("toggleterm.terminal").Terminal

  local shell_term = Terminal:new({
    direction = "float",
    hidden = true,
  })

  vim.keymap.set("n", "<leader>z", function()
    shell_term:toggle()
  end, { noremap = true, silent = true })

  local codex_cfg = config.get("features.terminal.codex", {})
  if codex_cfg.enabled ~= false then
    local codex_term = Terminal:new({
      cmd = codex_cfg.cmd or "codex",
      direction = "float",
      hidden = true,
    })

    vim.keymap.set("n", codex_cfg.key or "<leader>cx", function()
      codex_term:toggle()
    end, { noremap = true, silent = true })
  end
end

return M
