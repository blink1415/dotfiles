(local lsp_keymaps
       (lambda []
         (local map _G.vim.keymap.set)
         (map :n :gr (lambda [] (_G.Snacks.picker.lsp_references))
              {:desc "LSP references"})
         (map :n :gd (lambda [] (_G.Snacks.picker.lsp_definitions))
              {:desc "LSP definitions"})
         (map :n :gi (lambda [] (_G.Snacks.picker.lsp_implementations))
              {:desc "LSP implementations"})
         (map :n :<leader>lD "<cmd>lua vim.diagnostic.open_float()<cr>")
         (map :n :<leader>q (lambda [] (_G.Snacks.picker.diagnostics))
              {:desc "Diagnostics"})
         (map :n :<leader>la
              "<cmd>lua require('tiny-code-action').code_action()<cr>")
         (map :n :<leader>lr "<cmd>lua vim.lsp.buf.rename()<cr>")
         (map :n :<leader>lk "<cmd>lua vim.diagnostic.goto_prev()<cr>")
         (map :n :<leader>lj "<cmd>lua vim.diagnostic.goto_next()<cr>")))

; Servers enabled via native vim.lsp.enable (configs ship with nvim-lspconfig).
; Not listed on purpose:
;   hls           -> managed by haskell-tools.nvim (would double-attach)
;   rust_analyzer -> managed by rustaceanvim
(local servers [:gopls
                :lua_ls
                :ts_ls
                :jsonls
                :yamlls
                :terraformls
                :sqlls
                :elmls
                :intelephense
                :omnisharp
                :purescriptls
                :superhtml
                :fennel_language_server
                :vacuum
                :uiua
                :gleam
                :kotlin_language_server
                :fsautocomplete])

[{1 :neovim/nvim-lspconfig
  :event [:BufReadPre :BufNewFile]
  :config (lambda []
            (lsp_keymaps)
            (_G.vim.filetype.add {:pattern {"openapi.*%.ya?ml" :yaml.openapi
                                            "openapi.*%.json" :json.openapi}})
            (_G.vim.lsp.config :gopls
                               {:settings {:gopls {:gofumpt true
                                                   :staticcheck true
                                                   :hints {:assignVariableTypes true
                                                           :compositeLiteralFields true
                                                           :compositeLiteralTypes true
                                                           :constantValues true
                                                           :functionTypeParameters true
                                                           :parameterNames true
                                                           :rangeVariableTypes true}}}})
            (_G.vim.lsp.enable servers))}
 ; mason only needs to load when managing installs; its bin dir is put on
 ; PATH in init.fnl so servers/formatters resolve without loading it
 {1 :mason-org/mason.nvim
  :cmd [:Mason :MasonInstall :MasonUpdate :MasonUninstall]
  :build (lambda []
           (pcall _G.vim.cmd :MasonUpdate))
  :opts {}}
 {1 :mason-org/mason-lspconfig.nvim
  :cmd [:LspInstall :LspUninstall]
  :dependencies [:mason-org/mason.nvim]
  :opts {:automatic_enable false}}
 ; LspAttach-lazy so plenary stays off the BufReadPre critical path
 {1 :rachartier/tiny-code-action.nvim
  :dependencies [:nvim-lua/plenary.nvim]
  :event :LspAttach
  :opts {:backend :difftastic :picker {1 :snacks}}}]
