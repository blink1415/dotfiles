(fn formatters [...]
  (local config {:stop_after_first true})
  (each [i v (ipairs [...])]
    (tset config i v))
  config)

(local goimports_reviser_config
       (lambda []
         (local handle (io.popen "go env GOPRIVATE"))
         (local goprivate (string.gsub (handle:read :*a) "%s+" ""))
         (handle:close)
         {:prepend_args [:-company-prefixes goprivate]}))

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
                           :sql [:sleek]
                           :go [:goimports-reviser :golines :gofumpt]
                           :xml [:xmlformatter]
                           :json [:jq]
                           :fennel [:fnlfmt]
                           :haskell (formatters :ormolu :fourmolu)
                           :ua [:uiua]}
        :format_on_save {:lsp_format :fallback :timeout_ms 500}
        :formatters {:uiua {:command :uiua :args [:fmt :$FILENAME]}
                     :goimports-reviser goimports_reviser_config
                     :golines {:prepend_args [:-m :140]}
                     :sleek {:command :sleek :args [:-U :false]}}}}
