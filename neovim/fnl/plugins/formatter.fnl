(fn formatters [...]
  (local config {:stop_after_first true})
  (each [i v (ipairs [...])]
    (tset config i v))
  config)

{1 :stevearc/conform.nvim
 :event [:BufWritePre]
 :lazy true
 :keys [{1 :<leader>lf
         2 "<cmd>lua require('conform').format()<cr>"
         :desc "Format buffer"}]
 :opts {:formatters_by_ft {:lua [:stylua]
                           :javascript (formatters :prettierd :prettier)
                           :javascriptreact (formatters :prettierd :prettier)
                           :typescript (formatters :prettierd :prettier)
                           :typescriptreact (formatters :prettierd :prettier)
                           :sql [:sqlformat]
                           :go (formatters :gofmt :goimports)
                           :xml [:xmlformatter]
                           :json [:jq]
                           :fennel [:fnlfmt]
                           :haskell (formatters :ormolu :fourmolu)}
        :format_on_save {:lsp_format :fallback :timeout_ms 500}
        :formatters {:uiua {:command :uiua :args [:fmt :$FILENAME]}}}}
