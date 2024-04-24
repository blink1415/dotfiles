{1 :ray-x/go.nvim
 :dependencies [:ray-x/guihua.lua
                :neovim/nvim-lspconfig
                :nvim-treesitter/nvim-treesitter]
 :lazy true
 :keys [{1 :<leader>lt 2 :<cmd>GoTestSum<cr> :desc "Run tests"}]
 :config (lambda []
           ((. (require :go) :setup) {:test_runner :gotestsum
                                      :run_in_floaterm true})
           ((. (. (require :lspconfig) :gopls) :setup) {:settings {:gopls {:gofumpt true}}}))
 :ft [:go :gomod]
 :build ["':lua require(\"go.install\").update_all_sync()'" ":TSInstall go"]}

