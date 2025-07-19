(local opt {:direction :float
            :size (lambda [] (* _G.vim.o.columns 0.5))
            :autochdir true
            :winbar {:enabled true :name_formatter (lambda [term] term.name)}
            :open_mapping :<c-o>
            :terminal_mappings true})

[{1 :akinsho/toggleterm.nvim
  :lazy true
  :enabled true
  :keys [{1 :<c-o> 2 :<cmd>ToggleTerm<cr> :desc "Toggle term"}]
  :config (lambda []
            ((. (require :toggleterm) :setup) opt))}
 {1 :nvzone/floaterm
  :dependencies :nvzone/volt
  :enabled false
  :opts {}
  :keys [{1 :<c-t> 2 :<cmd>FloatermToggle<cr> :desc "Toggle term"}]
  :cmd :FloatermToggle}]
