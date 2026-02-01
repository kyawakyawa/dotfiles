local term = {}
local util = require("util")

term.setup = function(plugins)
  -- toggleterm.nvim
  util.add_plugin(plugins, {
    "akinsho/toggleterm.nvim",
    config = function(_)
      require("toggleterm").setup()

      local Terminal = require("toggleterm.terminal").Terminal

      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)

      local session_name = basename .. "-neovim"
      -- session_name = session_name:gsub("\\[^%w%._] ", "o")
      session_name = session_name:gsub("[^%w%._-]", "_")
      print(session_name)
      local zellij_term = Terminal:new({
        cmd = "zellij attach -c " .. session_name,
        direction = "float",
        hidden = true,
      })

      local function _zellij_toggle()
        zellij_term:toggle()
      end
      vim.keymap.set("n", "<leader>z", _zellij_toggle, { noremap = true, silent = true })
    end,
    lazy = true,
    keys = {
      "<leader>z",
    },
  }, {
    vscode = false,
  })

  return plugins
end

return term
