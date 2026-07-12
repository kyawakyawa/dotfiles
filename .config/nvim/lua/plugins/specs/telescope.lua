local config = require("config")

local M = {}

function M.setup()
  require("telescope").setup({
    pickers = {
      find_files = {
        find_command = config.get("features.search.find_command"),
      },
    },
  })

  local builtin = require("telescope.builtin")
  local opts = { noremap = true }
  vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
  vim.keymap.set("n", "<leader>fgr", builtin.live_grep, opts)
  vim.keymap.set("n", "<leader>fgs", builtin.git_status, opts)
  vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)
  vim.keymap.set("n", "<leader>fq", builtin.quickfix, opts)
  vim.keymap.set("n", "<leader>fd", builtin.diagnostics, opts)
  vim.keymap.set("n", "gr", builtin.lsp_references, { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>fre", builtin.registers, opts)
end

return M
