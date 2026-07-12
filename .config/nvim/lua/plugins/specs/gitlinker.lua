local M = {}

function M.setup()
  require("gitlinker").setup()

  vim.keymap.set("n", "<leader>gb", function()
    require("gitlinker").get_buf_range_url(
      "n",
      { action_callback = require("gitlinker.actions").open_in_browser }
    )
  end, { silent = true })
  vim.keymap.set("v", "<leader>gb", function()
    require("gitlinker").get_buf_range_url(
      "v",
      { action_callback = require("gitlinker.actions").open_in_browser }
    )
  end)
  vim.keymap.set("n", "<leader>gY", function()
    require("gitlinker").get_repo_url()
  end, { silent = true })
  vim.keymap.set("n", "<leader>gB", function()
    require("gitlinker").get_repo_url({
      action_callback = require("gitlinker.actions").open_in_browser,
    })
  end, { silent = true })
end

return M
