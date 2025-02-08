local avante = {}

local util = require('util')

local config = util.load_config()
avante_config = config['plugins']['aiAssistant']['avante']
avante_config_opts = config['plugins']['aiAssistant']['avante']['opts']

avante.setup = function(plugins)

  if vim.fn.executable('cargo') == 1 then
    util.add_plugin(plugins, {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
        opts = {
          -- provider = "ollama",
          provider = avante_config_opts["provider"],
          vendors = {
            ---@type AvanteProvider
            ollama = {
              __inherited_from = "openai",
              api_key_name = "",
              endpoint = avante_config_opts["venders"]["ollama"]["endpoint"],
              model = avante_config_opts["venders"]["ollama"]["model"],
            },
          },
        },
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
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
              file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
          },
        },
      },
      {
        vscode = false
      }
    )
  end

  return plugins
end

return avante
