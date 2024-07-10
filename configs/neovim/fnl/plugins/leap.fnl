{1 :ggandor/leap.nvim
 :event :BufEnter
 :config (lambda []
           ((. (require :leap) :add_default_mappings)))}

