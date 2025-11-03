local file_explorer = {}
local util = require("util")

local config = require("util").load_config()
local file_explorer_cfg = config['plugins']['file_explorer']

if file_explorer_cfg['name'] == "yazi" then
  file_explorer.setup = function(plugins)
    util.add_plugin(plugins, {
      "mikavilpas/yazi.nvim",
      version = "*", -- use the latest stable version
      event = "VeryLazy",
      dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
      },
      keys = {
        -- 👇 in this section, choose your own keymappings!
        {
          "<leader>-",
          mode = { "n", "v" },
          "<cmd>Yazi<cr>",
          desc = "Open yazi at the current file",
        },
        {
          -- Open in the current working directory
          "<leader>cw",
          "<cmd>Yazi cwd<cr>",
          desc = "Open the file manager in nvim's working directory",
        },
        {
          "<c-up>",
          "<cmd>Yazi toggle<cr>",
          desc = "Resume the last yazi session",
        },
      },
      ---@type YaziConfig | {}
      opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = false,
        keymaps = {
          show_help = "<f1>",
        },
      },
      -- 👇 if you use `open_for_directories=true`, this is recommended
      init = function()
        -- mark netrw as loaded so it's not loaded at all.
        --
        -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
        vim.g.loaded_netrwPlugin = 1
      end,
    }, {
      vscode = false,
    })
  
    return plugins
  end

else

  file_explorer.setup = function(plugins)
    util.add_plugin(plugins, {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      -- TODO config
      lazy = true,
      keys = {
        {
          "<space>e",
          "<cmd>Neotree toggle source=filesystem reveal=true position=left<cr>",
          desc = "NeoTree",
        },
        -- { "<space>b", "<cmd>Neotree toggle source=buffer reveal=true position=float<cr>", desc = "NeoTree buf" },
        {
          "<space>g",
          "<cmd>Neotree toggle source=git_status reveal=true position=left <cr>",
          desc = "NeoTree git",
        },
      },
      config = function()
        require("neo-tree").setup({
          default_component_configs = {
            window = {
              -- position = "float",
            },
          },
        })
      end,
    }, {
      vscode = false,
    })
  
    return plugins
  end
  
end

return file_explorer
