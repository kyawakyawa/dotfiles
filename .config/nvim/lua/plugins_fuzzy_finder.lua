local fuzzy_finder = {}
local util = require("util")

local config = require("util").load_config()

fuzzy_finder.setup = function(plugins)
  util.add_plugin(plugins, {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    config = function()
      require("telescope").setup({
        -- the rest of your telescope config goes here
        extensions = {
          undo = {
            -- telescope-undo.nvim config, see below
          },
          -- other extensions:
          -- file_browser = { ... }
        },
        pickers = {
          find_files = {
            find_command = config["plugins"]["fuzzy_finder"]["telescope"]["find_command"],
          },
        },
      })
      require("telescope").load_extension("undo")

      local bufopts = { noremap = true }
      vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, bufopts)
      vim.keymap.set("n", "<leader>fgr", require("telescope.builtin").live_grep, bufopts)
      vim.keymap.set("n", "<leader>fgs", require("telescope.builtin").git_status, bufopts)
      vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, bufopts)
      vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, bufopts)
      vim.keymap.set("n", "<leader>fq", require("telescope.builtin").quickfix, bufopts)
      vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, bufopts)
      vim.keymap.set("n", "<leader>fnt", require("telescope").extensions.notify.notify, bufopts)
      vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {
        noremap = true,
        silent = true,
      })
      vim.keymap.set("n", "<leader>gr", require("telescope.builtin").lsp_references, {
        noremap = true,
        silent = true,
      })
      vim.keymap.set("n", "<leader>u", require("telescope").extensions.undo.undo, bufopts)

      vim.keymap.set("n", "<leader>fre", require("telescope.builtin").registers, bufopts)
    end,
    lazy = true,
    event = "VeryLazy",
    keys = { "<leader>" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "rcarriga/nvim-notify",
    },
  }, {
    vscode = false,
  })

  return plugins
end

return fuzzy_finder
