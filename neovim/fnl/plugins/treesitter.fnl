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
                               :haskell]
            :highlight {:enable true}
            :indent {:enable true}})

{1 :nvim-treesitter/nvim-treesitter
 :dependencies [:nvim-treesitter/nvim-treesitter-textobjects]
 :version "*"
 :lazy true
 :event [:BufReadPost :BufNewFile]
 :config (lambda []
           ((. (require :nvim-treesitter.install) :update) {:with_sync true})
           ((. (require :nvim-treesitter.configs) :setup) opt)
           (local parser_config
                  ((. (require :nvim-treesitter.parsers) :get_parser_configs)))
           (set parser_config.plantuml
                {:install_info {:url :github.com/lyndsysimon/tree-sitter-plantuml
                                :files [:src/parser.c]
                                :branch :main}
                 :filetype :plantuml}))}
