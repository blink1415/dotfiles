(local conform_config
       {:formatters_by_ft {:lua [:stylua]
                           :javascript [{:prettierd :prettier}]
                           :javascriptreact [{:prettierd :prettier}]
                           :typescript [{:prettierd :prettier}]
                           :typescriptreact [{:prettierd :prettier}]
                           :go [{:gofumpt :gofmt}]
                           :json [:jq]
                           :fennel [:fnlfmt]
                           :haskell [{:ormolu :formolu}]}
        :formatters {:uiua {:command [:uiua :fmt]}}})

{1 :stevearc/conform.nvim
 :event :BufEnter
 :keys [{1 :<leader>lf
         2 "<cmd>lua require('conform').format()<cr>"
         :desc "Format buffer"}]
 :config (lambda []
           (local conform (require :conform))
           (conform.setup conform_config) ; (set conform.formatters.uiua {:command [:uiua :fmt]})
           )}

