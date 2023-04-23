local fuzzy_finder = {}

fuzzy_finder.setup = function(plugins)

  table.insert(plugins, {
    'nvim-telescope/telescope.nvim',branch = '0.1.x',
    config = function()
      local bufopts = { noremap=true }
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, bufopts)
      vim.keymap.set('n', '<leader>fgr', require('telescope.builtin').live_grep, bufopts)
      vim.keymap.set('n', '<leader>fgs', require('telescope.builtin').git_status, bufopts)
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, bufopts)
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, bufopts)
      vim.keymap.set('n', '<leader>fq', require('telescope.builtin').quickfix, bufopts)
      vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, bufopts)
      vim.keymap.set('n', '<leader>fnot', require('telescope').extensions.notify.notify, bufopts)
      vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {
        noremap=true, silent=true
      })

      --nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
      --nnoremap <leader>fgr <cmd>lua require('telescope.builtin').live_grep()<cr>
      --nnoremap <leader>fgs <cmd>lua require('telescope.builtin').git_status()<cr>
      --nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
      --nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
      --nnoremap <leader>fq <cmd>lua require('telescope.builtin').quickfix()<cr>
      --nnoremap <leader>fd <cmd>lua require('telescope.builtin').diagnostics()<cr>
      --nnoremap gr <cmd>lua require('telescope.builtin').lsp_references()<cr>
    end,
    lazy = true,
    keys = { "<leader>" },
    dependencies = { 'nvim-lua/plenary.nvim' },
  })

  return plugins

end

return fuzzy_finder
