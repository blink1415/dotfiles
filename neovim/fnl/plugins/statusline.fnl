{1 :echasnovski/mini.statusline
 :version "*"
 :config (lambda []
           (local statusline (require :mini.statusline))
           (statusline.setup {:set_vim_settings true})
           (set _G.vim.o.laststatus 3))
 :Lazy false}
