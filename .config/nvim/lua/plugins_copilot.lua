local copilot = {}

copilot.setup = function(plugins)
  -- copilotsigns.nvim
  table.insert(plugins, {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-o>"
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
          },
        },
			  suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            -- MはAltキー(Macの場合はOptionキー)
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
			  filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
			  copilot_node_command = "node", -- Node.js version must be > 18.x
			  server_opts_overrides = {},
		})
    end,
  })

  table.insert(plugins, {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    event = "BufRead",
    config = function()
      require("CopilotChat").setup{}

      local bufopts = { noremap=true }
      -- Open the chat window
      vim.keymap.set('n', '<leader>cc', function() require("CopilotChat").toggle({window = {layout = 'float', title = 'My Title'}}) end, bufopts)
    end,
    keys = {
      "<leader>cc",
    },
  })

  return plugins
end

return copilot
