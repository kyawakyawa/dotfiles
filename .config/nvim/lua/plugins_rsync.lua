local rsync = {}

rsync.setup = function(plugins)

    table.insert(plugins, {
      "coffebar/transfer.nvim",
      lazy = false,
      cmd = { "TransferInit", "DiffRemote", "TransferUpload", "TransferDownload", "TransferDirDiff", "TransferRepeat" },
      opts = {},
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

        require("transfer").setup()
      end,
    })

    return plugins
end

return rsync
