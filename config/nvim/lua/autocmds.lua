vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])
vim.cmd([[autocmd FileType markdown set wrap]])
vim.cmd([[autocmd VimEnter * CHADopen]])
