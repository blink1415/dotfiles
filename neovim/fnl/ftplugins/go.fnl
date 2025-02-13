{1 :ray-x/go.nvim
 :dependencies [:ray-x/guihua.lua
                :neovim/nvim-lspconfig
                :nvim-treesitter/nvim-treesitter]
 :lazy true
 :enabled false
 :config (lambda []
           ((. (require :go) :setup) {:test_runner :gotestsum
                                      :run_in_floaterm true}))
 :ft [:go :gomod]
 :build ":lua require('go.install').update_all_sync()"}
