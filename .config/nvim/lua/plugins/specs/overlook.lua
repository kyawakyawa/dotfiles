local M = {}

function M.setup()
  require("overlook").setup({
    ui = {
      border = "rounded",
      keys = {
        close = "q",
      },
    },
  })

  local api = require("overlook.api")
  local opts = { noremap = true, silent = true }

  vim.keymap.set(
    "n",
    "<leader>pd",
    api.peek_definition,
    vim.tbl_extend("force", opts, { desc = "Overlook peek definition" })
  )
  vim.keymap.set(
    "n",
    "<leader>pp",
    api.peek_cursor,
    vim.tbl_extend("force", opts, { desc = "Overlook peek cursor" })
  )
  vim.keymap.set(
    "n",
    "<leader>pu",
    api.restore_popup,
    vim.tbl_extend("force", opts, { desc = "Overlook restore popup" })
  )
  vim.keymap.set(
    "n",
    "<leader>pU",
    api.restore_all_popups,
    vim.tbl_extend("force", opts, { desc = "Overlook restore all popups" })
  )
  vim.keymap.set(
    "n",
    "<leader>pc",
    api.close_all,
    vim.tbl_extend("force", opts, { desc = "Overlook close all popups" })
  )
  vim.keymap.set(
    "n",
    "<leader>pf",
    api.switch_focus,
    vim.tbl_extend("force", opts, { desc = "Overlook switch focus" })
  )
  vim.keymap.set(
    "n",
    "<leader>ps",
    api.open_in_split,
    vim.tbl_extend("force", opts, { desc = "Overlook open in split" })
  )
  vim.keymap.set(
    "n",
    "<leader>pv",
    api.open_in_vsplit,
    vim.tbl_extend("force", opts, { desc = "Overlook open in vsplit" })
  )
  vim.keymap.set(
    "n",
    "<leader>pt",
    api.open_in_tab,
    vim.tbl_extend("force", opts, { desc = "Overlook open in tab" })
  )
  vim.keymap.set(
    "n",
    "<leader>po",
    api.open_in_original_window,
    vim.tbl_extend("force", opts, { desc = "Overlook open in original window" })
  )
end

return M
