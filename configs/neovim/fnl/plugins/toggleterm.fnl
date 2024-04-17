(local config {:direction :float
               :size (fn [] (* vim.o.columns 0.5))
               :autochdir true
               :winbar {:enabled true :name_formatter (fn [term] term.name)}
               :open_mapping :<c-o>
               :terminal_mappings true})

{1 :akinsho/toggleterm.nvim
 :lazy true
 :keys {1 {1 :<c-o> 2 :<cmd>ToggleTerm<cr> :desc "Toggle term"}}
 :config (fn []
           ((. (require :toggleterm) :setup) config))}

