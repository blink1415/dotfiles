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

{1 :VonHeikemen/lsp-zero.nvim
 :branch :v3.x
 :event :BufEnter
 :dependencies [:neovim/nvim-lspconfig
                {1 :williamboman/mason.nvim
                 :build (lambda []
                          (pcall _G.vim.cmd :MasonUpdate))}
                {1 :rachartier/tiny-code-action.nvim
                 :dependencies [:nvim-lua/plenary.nvim
                                :nvim-telescope/telescope.nvim]
                 :event :LspAttach
                 :opts {}}
                :williamboman/mason-lspconfig.nvim
                :nvim-telescope/telescope.nvim
                ; Completion
                :L3MON4D3/LuaSnip
                :onsails/lspkind.nvim]
 :config (lambda []
           (local lsp ((. (require :lsp-zero) :preset) {}))
           (lsp.on_attach (lambda [_ bufnr]
                            (lsp_keymaps)
                            (lsp.default_keymaps {:buffer bufnr})))
           ((. (require :mason) :setup) {})
           ((. (require :mason-lspconfig) :setup) {:ensure_installed []
                                                   :handlers [lsp.default_setup]})
           (local lspconfig (require :lspconfig))
           (lspconfig.flix.setup {})
           (lspconfig.uiua.setup {})
           (lspconfig.gleam.setup {})
           (lspconfig.kotlin_language_server.setup {})
           (lspconfig.fsautocomplete.setup {})
           (lspconfig.rust_analyzer.setup {:settings {:hints {[:rust-analyzer] {:inlayHints {:bindingModeHints {:enable false}
                                                                                             :chainingHints {:enable true}
                                                                                             :closingBraceHints {:enable true
                                                                                                                 :minLines 25}
                                                                                             :closureReturnTypeHints {:enable :never}
                                                                                             :lifetimeElisionHints {:enable :never
                                                                                                                    :useParameterNames false}
                                                                                             :maxLength 25
                                                                                             :parameterHints {:enable true}
                                                                                             :reborrowHints {:enable :never}
                                                                                             :renderColons true
                                                                                             :typeHints {:enable true
                                                                                                         :hideClosureInitialization false
                                                                                                         :hideNamedConstructor false}}}}}})
           (lspconfig.lua_ls.setup (lsp.nvim_lua_ls))
           (lspconfig.gopls.setup {:settings {:gopls {:gofumpt true
                                                      :local :go.axofinance.io
                                                      :hints {:assignVariableTypes true
                                                              :compositeLiteralFields true
                                                              :compositeLiteralTypes true
                                                              :constantValues true
                                                              :functionTypeParameters true
                                                              :parameterNames true
                                                              :rangeVariableTypes true}}}})
           (lsp.setup))}
