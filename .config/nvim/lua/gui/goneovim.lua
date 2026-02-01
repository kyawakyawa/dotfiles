-- set CMD+V to paste in all modes
-- Normal mode
vim.keymap.set('n', '<D-v>', 'a<C-r>+<Esc>', { noremap = true })
-- Insert mode
vim.keymap.set('i', '<D-v>', '<C-r>+', { noremap = true })
-- Command-line mode
vim.keymap.set('c', '<D-v>', '<C-r>+', { noremap = true })
