local M = {}

function M.setup()
  vim.g.loaded_netrwPlugin = 1

  require("yazi").setup({
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  })

  vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Yazi<cr>", { desc = "Open yazi at current file" })
  vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Open yazi in cwd" })
  vim.keymap.set("n", "<C-Up>", "<cmd>Yazi toggle<cr>", { desc = "Resume yazi" })
end

return M
