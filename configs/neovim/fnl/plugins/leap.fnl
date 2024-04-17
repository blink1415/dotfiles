{1 :ggandor/leap.nvim
 :event :BufEnter
 :config (fn []
           ((. (require :leap) :add_default_mappings)))}

