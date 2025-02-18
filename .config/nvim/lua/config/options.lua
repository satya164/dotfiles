
-- UI
vim.opt.termguicolors = true -- enable 24-bit RGB color in the TUI
vim.opt.number = true -- show line numbers
vim.opt.signcolumn = "yes" -- reserve space in gutter to avoid layout shift

-- Editor
vim.opt.backspace = "indent,eol,start" -- allow backspacing over everything in insert mode
vim.opt.clipboard = "unnamedplus" -- use the system clipboard

-- Search
vim.opt.smartcase = true -- ignore case when pattern has no uppercase characters
vim.opt.ignorecase = true -- ignore case when searching

-- Indentation
vim.opt.tabstop = 2 -- number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2 -- number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.preserveindent = true -- keep the same indent as the previous line
vim.opt.smartindent = true -- insert indents automatically

-- Whitespace
vim.opt.list = true -- show whitespace characters
vim.opt.listchars = { tab = "▸ ", trail = "·", extends = ">", precedes = "<", nbsp = "␣" } -- set whitespace characters
