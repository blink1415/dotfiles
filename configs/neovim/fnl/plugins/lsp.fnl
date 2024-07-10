(local lsp_keymaps
       (lambda []
         (local map _G.vim.keymap.set)
         (map :n :gr "<cmd>Telescope lsp_references<cr>")
         (map :n :gd "<cmd>Telescope lsp_definitions<cr>")
         (map :n :gD "<cmd>lua vim.lsp.buf.implementation()<cr>")
         (map :n :<leader>lD "<cmd>lua vim.diagnostic.open_float()<cr>")
         (map :n :<leader>lf "<cmd>lua require('conform').format()<cr>")
         (map :n :<leader>q "<cmd>Telescope diagnostics<cr>")
         (map :n :<leader>la "<cmd>lua vim.lsp.buf.code_action()<cr>")
         (map :n :<leader>lr "<cmd>lua vim.lsp.buf.rename()<cr>")
         (map :n :<leader>lk "<cmd>lua vim.diagnostic.goto_prev()<cr>")
         (map :n :<leader>lj "<cmd>lua vim.diagnostic.goto_next()<cr>")))

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
        :format_on_save {:timeout_ms 500 :lsp_fallback true}})

(local fennel_config
       (lambda [lspconfig]
         {:default_config {:cmd [:/Users/nikolai/.local/share/nvim/mason/bin/fennel-language-server]
                           :filetypes [:fennel]
                           :single_file_support true
                           :root_dir (lspconfig.util.root_pattern :fnl)
                           :settings {:fennel {:workspace {:library (_G.vim.api.nvim_list_runtime_paths)}
                                               :diagnostics {:globals [:vim]}}}}}))

(local cmp_config (lambda [cmp]
                    {:mapping {:<CR> (cmp.mapping.confirm {:select true})
                               :<C-Space> (cmp.mapping.complete)
                               :<C-j> (cmp.mapping.select_next_item)
                               :<C-k> (cmp.mapping.select_prev_item)}
                     :window {:completion {:winhighlight "Normal:Pmenu,FloatBorder:Pmenu,Search:None"
                                           :col_offset -3
                                           :side_padding 0}}
                     :formatting {:fields [:kind :abbr :menu]
                                  :format (fn [entry vim_item]
                                            (local kind_opts
                                                   {:mode :symbol_textlsp
                                                    :maxwidth 50})
                                            (local lspkind (require :lspkind))
                                            (local kind
                                                   ((lspkind.cmp_format kind_opts) entry
                                                                                   vim_item))
                                            (local strings
                                                   (_G.vim.split kind.kind "%s"
                                                                 {:trimempty true}))
                                            (set kind.kind
                                                 (.. (.. " "
                                                         (or (. strings 1) ""))
                                                     " "))
                                            (set kind.menu
                                                 (.. (.. "    ("
                                                         (or (. strings 2) ""))
                                                     ")"))
                                            kind)}}))

{1 :VonHeikemen/lsp-zero.nvim
 :branch :v3.x
 :event :BufEnter
 :dependencies [:neovim/nvim-lspconfig
                {1 :williamboman/mason.nvim
                 :build (fn []
                          (pcall _G.vim.cmd :MasonUpdate))}
                :williamboman/mason-lspconfig.nvim
                :nvim-telescope/telescope.nvim
                ; Completion
                :hrsh7th/nvim-cmp
                :hrsh7th/cmp-nvim-lsp
                :L3MON4D3/LuaSnip
                :onsails/lspkind.nvim
                ; Formatting
                :stevearc/conform.nvim]
 :config (lambda []
           (local lsp ((. (require :lsp-zero) :preset) {}))
           (lsp.on_attach (lambda [_ bufnr]
                            (lsp.default_keymaps {:buffer bufnr})
                            (lsp_keymaps)))
           ((. (require :mason) :setup) {})
           ((. (require :mason-lspconfig) :setup) {:ensure_installed []
                                                   :handlers [lsp.default_setup]})
           ((. (require :conform) :setup) conform_config)
           (local lspconfig (require :lspconfig))
           (lspconfig.lua_ls.setup (lsp.nvim_lua_ls))
           (lspconfig.fennel_language_server.setup (fennel_config lspconfig))
           (local cmp (require :cmp))
           (cmp.setup (cmp_config cmp))
           (lsp.setup))}

