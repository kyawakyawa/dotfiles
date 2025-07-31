local avante = {}

local util = require("util")

local avante_cfg = require("avante_cfg")

avante.setup = function(plugins)
  if vim.fn.executable("cargo") == 1 then
    util.add_plugin(plugins, {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
      opts = avante_cfg.opts,
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          "MeanderingProgrammer/render-markdown.nvim",
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
        {
          "ravitemer/mcphub.nvim",
          dependencies = {
            "nvim-lua/plenary.nvim",
          },
          build = "bundled_build.lua",
          opts = {
            extensions = {
              avante = {
                make_slash_commands = true, -- /mcp:server_name:prompt_name で呼び出し可能
                -- スラッシュコマンドのプリフィックス（オプション）
                -- slash_command_prefix = "/mcp:",
              },
            },
            auto_approve = false, -- MCP tool呼び出し時の自動承認（任意）
            use_bundled_binary = true, -- MCPHub.nvimのバイナリを使用する場合はtrue
            -- 新機能: MCPサーバーの自動起動
            autostart_servers = {
              "neovim", -- neovim MCPサーバーを自動起動
              "fetch", -- fetch MCPサーバーを自動起動
            },
            -- MCP HUB UI設定
            ui = {
              -- UIのカスタマイズ設定
              border = "rounded",
              width = 80,
              height = 20,
            },
          },
        },
      },
    }, {
      vscode = false,
    })
  end

  return plugins
end

return avante
