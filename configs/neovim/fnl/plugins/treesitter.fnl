(local opt {:ensure_installed [:c
                               :cpp
                               :go
                               :lua
                               :python
                               :rust
                               :javascript
                               :typescript
                               :vim
                               :php
                               :sql
                               :java
                               :fennel
                               :terraform
                               :haskell]
            :highlight {:enable true}})

{1 :nvim-treesitter/nvim-treesitter
 :dependencies [:nvim-treesitter/nvim-treesitter-textobjects]
 :lazy true
 :event :BufEnter
 :config (lambda []
           ((. (require :nvim-treesitter.install) :update) {:with_sync true})
           ((. (require :nvim-treesitter.configs) :setup) opt))}

