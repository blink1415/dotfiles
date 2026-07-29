(local opt {:ensure_installed [:c
                               :cpp
                               :go
                               :lua
                               :python
                               :rust
                               :gleam
                               :elm
                               :javascript
                               :typescript
                               :php
                               :sql
                               :java
                               :fennel
                               :terraform
                               :haskell
                               :markdown
                               :markdown_inline
                               :plantuml]
            :highlight {:enable true}
            :indent {:enable true}
            ; helix Alt-o/Alt-i expand/shrink selection
            :incremental_selection {:enable true
                                    :keymaps {:init_selection :<M-o>
                                              :node_incremental :<M-o>
                                              :node_decremental :<M-i>
                                              :scope_incremental false}}
            ; helix match-mode parity: mi f / ma f -> inside/around function
            ; (mi maps to "vi" in init.fnl, so the f/t/a objects below compose);
            ; ]f [f etc mirror helix unimpaired-style goto
            ; NOTE: at/it shadow the builtin HTML-tag textobject (helix t=type)
            :textobjects {:select {:enable true
                                   :lookahead true
                                   :keymaps {:af "@function.outer"
                                             :if "@function.inner"
                                             :at "@class.outer"
                                             :it "@class.inner"
                                             :aa "@parameter.outer"
                                             :ia "@parameter.inner"}}
                          :move {:enable true
                                 :set_jumps true
                                 :goto_next_start {"]f" "@function.outer"
                                                   "]t" "@class.outer"
                                                   "]a" "@parameter.inner"
                                                   "]c" "@comment.outer"}
                                 :goto_previous_start {"[f" "@function.outer"
                                                       "[t" "@class.outer"
                                                       "[a" "@parameter.inner"
                                                       "[c" "@comment.outer"}}}})

[{1 :nvim-treesitter/nvim-treesitter
  :version "*"
  :lazy true
  :event [:BufReadPost :BufNewFile]
  :config (lambda []
            ((. (require :nvim-treesitter.configs) :setup) opt)
            (local parser_config
                   ((. (require :nvim-treesitter.parsers) :get_parser_configs)))
            (set parser_config.plantuml
                 {:install_info {:url :github.com/lyndsysimon/tree-sitter-plantuml
                                 :files [:src/parser.c]
                                 :branch :main}
                  :filetype :plantuml}))}
 ; VeryLazy keeps the textobjects plugin file off the first-paint path
 {1 :nvim-treesitter/nvim-treesitter-textobjects
  :lazy true
  :event :VeryLazy
  :dependencies [:nvim-treesitter/nvim-treesitter]
  ; late module registration only creates FileType autocmds for future
  ; buffers — explicitly reattach for buffers opened during startup
  :config (lambda []
            (local configs (require :nvim-treesitter.configs))
            (each [_ buf (ipairs (_G.vim.api.nvim_list_bufs))]
              (when (_G.vim.api.nvim_buf_is_loaded buf)
                (pcall configs.reattach_module :textobjects.select buf)
                (pcall configs.reattach_module :textobjects.move buf))))}
 {1 :nvim-treesitter/nvim-treesitter-context
  :lazy true
  :event :VeryLazy
  :dependencies [:nvim-treesitter/nvim-treesitter]}]
