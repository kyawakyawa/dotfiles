local git = {}

util = require('util')

git.setup = function(plugins)

  -- gitsigns.nvim
  table.insert(plugins, {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('next')
            end
          end)

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              gitsigns.nav_hunk('prev')
            end
          end)

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk)
          map('n', '<leader>hr', gitsigns.reset_hunk)
          map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<leader>hS', gitsigns.stage_buffer)
          map('n', '<leader>hu', gitsigns.undo_stage_hunk)
          map('n', '<leader>hR', gitsigns.reset_buffer)
          map('n', '<leader>hp', gitsigns.preview_hunk)
          map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
          map('n', '<leader>hd', gitsigns.diffthis)
          map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
          map('n', '<leader>td', gitsigns.toggle_deleted)

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      }
    end,
  	lazy = true,
	  event = { "CursorHold", "CursorHoldI" },
    keys = {
      '<leader>hs',
      '<leader>hr',
      '<leader>hs',
      '<leader>hr',
      '<leader>hS',
      '<leader>hu',
      '<leader>hR',
      '<leader>hp',
      '<leader>hb',
      '<leader>tb',
      '<leader>hd',
      '<leader>hD',
      '<leader>td',
    },
  })

  -- messenger.nvim
  table.insert(plugins, {
    'lsig/messenger.nvim',
    config = function()
      require('messenger').setup({
        border = "rounded",
        heading_hl = "#000000"
        -- heading_hl = "#89b4fa"
      })
      local bufopts = { noremap=true }
      vim.keymap.set('n', '<leader>gm', require('messenger').show, bufopts)
    end,
    lazy = true,
    event = "VeryLazy",
  })

  -- sindrets/diffview.nvim
  table.insert(plugins, {
    'sindrets/diffview.nvim',
    config = function()

      win_config = function()
        local c = { type = "float" }
        local editor_width = vim.o.columns
        local editor_height = vim.o.lines
        c.width = math.min(100, editor_width)
        c.height = math.min(24, editor_height)
        c.col = math.floor(editor_width * 0.5 - c.width * 0.5)
        c.row = math.floor(editor_height * 0.5 - c.height * 0.5)
        return c
        -- local c = { type = "float" }
        -- local editor_width = vim.o.columns
        -- local editor_height = vim.o.lines
        -- c.width = editor_width
        -- c.height = math.min(24, editor_height)
        -- c.col = math.floor(editor_width * 0.5 - c.width * 0.5)
        -- -- c.row = math.floor(editor_height * 0.5 - c.height * 0.5)
        -- c.row = math.floor(editor_height - c.height)
        -- return c
      end

      require("diffview").setup({
        file_panel = {
          win_config = win_config,
        },
        file_history_panel = {
          win_config = win_config,
        },
        commit_log_panel = {
          win_config = win_config,
        },
        hook = {
          view_opened = function(view)
            print(
              ("A new %s was opened on tab page %d!")
              :format(view.class:name(), view.tabpage)
            )
          end,
        }
      })
    end,
    lazy = true,
    event = "VeryLazy",
  })

  util.add_plugin(plugins, {
   "ruifm/gitlinker.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },
   lazy = true,
   event = "VeryLazy",
   config = function()
     require"gitlinker".setup()

     vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {silent = true})
     vim.api.nvim_set_keymap('v', '<leader>gb', '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {})

     vim.api.nvim_set_keymap('n', '<leader>gY', '<cmd>lua require"gitlinker".get_repo_url()<cr>', {silent = true})
     vim.api.nvim_set_keymap('n', '<leader>gB', '<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>', {silent = true})


   end,
  },
  {
    vscode = true,
  })

  return plugins
end

return git
