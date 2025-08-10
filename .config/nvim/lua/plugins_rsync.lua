local rsync = {}

local util = require("util")
local config = util.load_config()

rsync.setup = function(plugins)
  table.insert(plugins, {
    "coffebar/transfer.nvim",
    lazy = false,
    cmd = {
      "TransferInit",
      "DiffRemote",
      "TransferUpload",
      "TransferDownload",
      "TransferDirDiff",
      "TransferRepeat",
    },
    -- opts = {
    --   upload_rsync_params = config["plugins"]["rsync"]["transfer"]["upload_rsync_params"],
    --   download_rsync_params = config["plugins"]["rsync"]["transfer"]["download_rsync_params"],
    -- },
    config = function()
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*" },
        callback = function()
          -- print("has deployment.yaml?: ", vim.fn.filereadable(vim.fn.getcwd() .. "/.nvim/deployment.lua"))
          if vim.fn.filereadable(vim.fn.getcwd() .. "/.nvim/deployment.lua") == 1 then
            path = vim.fn.expand("%:p")
            require("transfer.transfer").upload_file(path)
          end
        end,
      })

      require("transfer").setup({
        upload_rsync_params = config["plugins"]["rsync"]["transfer"]["upload_rsync_params"],
        download_rsync_params = config["plugins"]["rsync"]["transfer"]["download_rsync_params"],
      })
    end,
  })

  return plugins
end

return rsync
