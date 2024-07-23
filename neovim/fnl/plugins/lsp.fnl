(local lsp_keymaps
       (lambda []
         (local map _G.vim.keymap.set)
         (map :n :gr "<cmd>Telescope lsp_references<cr>")
         (map :n :gd "<cmd>Telescope lsp_definitions<cr>")
         (map :n :gD "<cmd>lua vim.lsp.buf.implementation()<cr>")
         (map :n :<leader>lD "<cmd>lua vim.diagnostic.open_float()<cr>")
         (map :n :<leader>q "<cmd>Telescope diagnostics<cr>")
         (map :n :<leader>la "<cmd>lua vim.lsp.buf.code_action()<cr>")
         (map :n :<leader>lr "<cmd>lua vim.lsp.buf.rename()<cr>")
         (map :n :<leader>lk "<cmd>lua vim.diagnostic.goto_prev()<cr>")
         (map :n :<leader>lj "<cmd>lua vim.diagnostic.goto_next()<cr>")))

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
                :L3MON4D3/LuaSnip
                :onsails/lspkind.nvim]
 :config (lambda []
           (local lsp ((. (require :lsp-zero) :preset) {}))
           (lsp.on_attach (lambda [_ bufnr]
                            (lsp.default_keymaps {:buffer bufnr})
                            (lsp_keymaps)))
           ((. (require :mason) :setup) {})
           ((. (require :mason-lspconfig) :setup) {:ensure_installed []
                                                   :handlers [lsp.default_setup]})
           (local lspconfig (require :lspconfig))
           (lspconfig.uiua.setup {:cmd [:uiua :lsp]})
           (lspconfig.lua_ls.setup (lsp.nvim_lua_ls))
           (lsp.setup))}

