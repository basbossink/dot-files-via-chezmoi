--Incremental live completion (note: this is now a default on master)
vim.o.inccommand = 'nosplit'

-- Set highlight on search enable incremental search
vim.o.hlsearch = true
vim.o.incsearch = true

--Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

--Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.clipboard = 'unnamedplus'
vim.o.expandtab = false
--Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 1500
vim.wo.signcolumn = 'yes'

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.o.guifont='JetbrainsMono NF:h12'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set list chars
vim.opt.listchars = { eol = '⏎', space = '␣', tab = '|~', trail = '•', nbsp = '‗' }

