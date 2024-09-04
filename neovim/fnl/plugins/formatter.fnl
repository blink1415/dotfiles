{1 :stevearc/conform.nvim
 :event :BufEnter
 :keys [{1 :<leader>lf
         2 "<cmd>lua require('conform').format()<cr>"
         :desc "Format buffer"}]
 :opts {:formatters_by_ft {:lua [:stylua]
                           :javascript {1 :prettierd
                                        2 :prettier
                                        :stop_after_first true}
                           :javascriptreact {0 :prettierd
                                             1 :prettier
                                             :stop_after_first true}
                           :typescript {1 :prettierd
                                        2 :prettier
                                        :stop_after_first true}
                           :typescriptreact {0 :prettierd
                                             1 :prettier
                                             :stop_after_first true}
                           :sql {1 :sqlfmt :stop_after_first true}
                           :go {1 :gofumpt 2 :gofmt :stop_after_first true}
                           :xml [:xmlformatter]
                           :json [:jq]
                           :fennel [:fnlfmt]
                           :haskell {1 :ormolu
                                     2 :fourmolu
                                     :stop_after_first true}}
        :format_on_save {:lsp_format :fallback :timeout_ms 500}
        :formatters {:uiua {:command :uiua :args [:fmt :$FILENAME]}}}}

