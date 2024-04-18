(local opt {:ensure_installed [:c
                               :cpp
                               :go
                               :lua
                               :python
                               :rust
                               :typescript
                               :vim
                               :php
                               :sql
                               :java
                               :fennel
                               :terraform]
            :highlight {:enable true}
            :indent {:enable true :disable [:python]}
            :incremental_selection {:enable true
                                    :keymaps {:init_selection :<c-space>
                                              :node_incremental :<c-space>
                                              :scope_incremental :<c-s>
                                              :node_decremental :<c-backspace>}}
            :textobjects {:select {:enable true :lookahead true}}})

{1 :nvim-treesitter/nvim-treesitter
 :dependencies [:nvim-treesitter/nvim-treesitter-textobjects
                :nvim-treesitter/nvim-treesitter-context]
 :lazy true
 :event :BufEnter
 :init (fn []
         ((. (require :nvim-treesitter.install) :update) {:with_sync true}))
 : opt}

