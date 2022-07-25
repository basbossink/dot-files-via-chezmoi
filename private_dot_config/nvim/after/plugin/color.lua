vim.opt.background = "dark"
vim.cmd [[colorscheme gruvbox-flat]]

--Set statusbar
vim.g.lightline = {
  colorscheme = 'gruvbox-flat',
  active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
  component_function = { gitbranch = 'fugitive#head' },
}
