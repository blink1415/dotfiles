(local lsp_keymaps
       (lambda []
         (local map _G.vim.keymap.set)
         (map :n :gr "<cmd>Telescope lsp_references<cr>")
         (map :n :gd "<cmd>Telescope lsp_definitions<cr>")
         (map :n :gi "<cmd>Telescope lsp_implementations<cr>")
         (map :n :<leader>lD "<cmd>lua vim.diagnostic.open_float()<cr>")
         (map :n :<leader>q "<cmd>Telescope diagnostics<cr>")
         (map :n :<leader>la
              "<cmd>lua require('tiny-code-action').code_action()<cr>")
         (map :n :<leader>lr "<cmd>lua vim.lsp.buf.rename()<cr>")
         (map :n :<leader>lk "<cmd>lua vim.diagnostic.goto_prev()<cr>")
         (map :n :<leader>lj "<cmd>lua vim.diagnostic.goto_next()<cr>")))

{1 :neovim/nvim-lspconfig
 :event [:BufReadPre :BufNewFile]
 :dependencies [{1 :mason-org/mason.nvim
                 :build (lambda []
                          (pcall _G.vim.cmd :MasonUpdate))}
                {1 :rachartier/tiny-code-action.nvim
                 :dependencies [:nvim-lua/plenary.nvim
                                :nvim-telescope/telescope.nvim]
                 :event :LspAttach
                 :opts {:backend :difftastic :picker {1 :snacks}}}
                :mason-org/mason-lspconfig.nvim
                :nvim-telescope/telescope.nvim
                ; Completion
                :onsails/lspkind.nvim]
 :config (lambda []
           (lsp_keymaps)
           ((. (require :mason) :setup) {})
           (local mason_lspconfig (require :mason-lspconfig))
           (mason_lspconfig.setup {})
           (_G.vim.filetype.add {:pattern {"openapi.*%.ya?ml" :yaml.openapi
                                           "openapi.*%.json" :json.openapi}})
           (local lspconfig (require :lspconfig))
           (lspconfig.uiua.setup {})
           (lspconfig.gleam.setup {})
           (lspconfig.kotlin_language_server.setup {})
           (lspconfig.fsautocomplete.setup {})
           (lspconfig.vacuum.setup {}) ; (lspconfig.kulala-ls.setup {})
           (lspconfig.gopls.setup {:settings {:gopls {:gofumpt true
                                                      :staticcheck true
                                                      :local :go.axofinance.io
                                                      :hints {:assignVariableTypes true
                                                              :compositeLiteralFields true
                                                              :compositeLiteralTypes true
                                                              :constantValues true
                                                              :functionTypeParameters true
                                                              :parameterNames true
                                                              :rangeVariableTypes true}}}}))}
