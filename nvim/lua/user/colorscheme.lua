vim.cmd [[
try
    set termguicolors
    set background=dark
    colorscheme kanagawa
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
