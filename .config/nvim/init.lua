vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cindent = true
vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.smartindent = true
vim.opt.hidden = true

-- For IME
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = { "*" },
  callback = function() vim.fn.system('fcitx5-remote -c') end,
})

-- For OpenCL
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead"}, {
  pattern = { "*.cl" },
  callback = function() vim.opt.filetype=cl end,
})

vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', { noremap = true })
