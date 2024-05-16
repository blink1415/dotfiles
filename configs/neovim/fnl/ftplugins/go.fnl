{1 :ray-x/go.nvim
 :dependencies [:ray-x/guihua.lua
                :neovim/nvim-lspconfig
                :nvim-treesitter/nvim-treesitter]
 :lazy true
 :config (lambda []
           ((. (require :go) :setup) {:test_runner :gotestsum
                                      :run_in_floaterm true})
           ((. (. (require :lspconfig) :gopls) :setup) {:settings {:gopls {:gofumpt true}
                                                                   :hints {:rangeVariableTypes true
                                                                           :parameterNames true
                                                                           :constantValues true
                                                                           :assignVariableTypes true
                                                                           :compositeLiteralFields true
                                                                           :compositeLiteralTypes true
                                                                           :functionTypeParameters true}}}))
 :ft [:go :gomod]
 :build ["':lua require(\"go.install\").update_all_sync()'" ":TSInstall go"]}

