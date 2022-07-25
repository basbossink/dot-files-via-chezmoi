--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Y yank until the end of line  (note: this is now a default on master)
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })
-- quickfix mappings
vim.api.nvim_set_keymap('n', '<leader>en', [[<cmd>cnext<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ep', [[<cmd>cprevious<CR>]], { noremap = true, silent = true })
