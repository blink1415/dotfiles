{1 :echasnovski/mini.statusline
 :version "*"
 :config (lambda []
           (set _G.vim.o.laststatus 3)
           (local statusline (require :mini.statusline))
           (statusline.setup {:set_vim_settings false}))
 :Lazy false}

