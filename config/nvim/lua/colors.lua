-- better colors
vim.cmd([[syntax on]])
vim.cmd([[colorscheme zerodark]])
vim.g.python_highlight_all = 1
if vim.fn.has([[termguicolors]]) == 1 then
  vim.opt.termguicolors = true
end
