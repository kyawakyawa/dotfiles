local git = {}

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

  -- neogit
  table.insert(plugins, {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
  
      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
    lazy = true,
  	event = "BufReadPost",
  })


  -- -- diffview.nvim
  -- use 'sindrets/diffview.nvim'

  -- -- vgit.nvim
  -- use ({
  --   'tanvirtin/vgit.nvim',
  --   config = function()
  --     require('vgit').setup()
  --   end,
  -- })

  return plugins
end

return git
