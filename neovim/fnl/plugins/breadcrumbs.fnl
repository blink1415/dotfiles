{1 :LunarVim/breadcrumbs.nvim
 :dependencies [:SmiteshP/nvim-navic]
 :enabled false
 :config (lambda []
           ((. (require :nvim-navic) :setup) {:lsp {:auto_attach true}})
           ((. (require :breadcrumbs) :setup)))
 :event :BufEnter}
