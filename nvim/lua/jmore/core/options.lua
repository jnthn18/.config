-- Set netrw to tree style
vim.cmd("let g:netrw_liststyle = 3")

vim.o.relativenumber = true
vim.o.number = true
vim.o.undofile = true

vim.o.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.o.shiftwidth = 2 -- 2 spaces for indent width
vim.o.expandtab = true -- expand tab to spaces
vim.o.autoindent = true -- copy indent from current line when starting new one
vim.o.wrap = false

vim.o.ignorecase = true -- ignore case when searching
vim.o.smartcase = true -- if you include mixed case in your search, assumes you want case-insensitive

vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.signcolumn="yes"
vim.o.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
vim.o.clipboard = "unnamedplus" -- use system clipboard as default register

vim.o.splitright = true -- split vertical window to the right
vim.o.splitbelow = true -- split horizontal window to the bottom

vim.o.swapfile = false
vim.o.winborder = "rounded"
