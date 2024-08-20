-- Set file types for GLSL files
vim.cmd([[
  autocmd BufNewFile,BufRead *.frag setfiletype glsl
  autocmd BufNewFile,BufRead *.vert setfiletype glsl
  autocmd BufNewFile,BufRead *.comp setfiletype glsl
]])

