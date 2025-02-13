(local vim _G.vim)
(let [lazypath (.. (vim.fn.stdpath :data) :/lazy/lazy.nvim)]
  (when (not (vim.loop.fs_stat lazypath))
    (vim.fn.system [:git
                    :clone
                    "--filter=blob:none"
                    :--single-branch
                    "https://github.com/folke/lazy.nvim.git"
                    lazypath]))
  (vim.opt.runtimepath:prepend lazypath))

(local map vim.keymap.set)

(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")
(set vim.o.hlsearch false)
(set vim.wo.number true)
(set vim.o.mouse :a)
(set vim.o.breakindent true)
(set vim.o.autoindent true)
(set vim.o.undofile true)
(set vim.o.ignorecase true)
(set vim.o.smartcase true)
(set vim.o.updatetime 250)
(set vim.wo.signcolumn :yes)
(set vim.o.termguicolors true)
(set vim.o.completeopt "menuone,noselect")
(set vim.o.cursorline true)
(set vim.o.tabstop 4)
(set vim.o.shiftwidth 4)
(set vim.o.conceallevel 0)

; Enable LSP inlay hints
(vim.lsp.inlay_hint.enable)

(map :n :<Space> :<Nop> {:silent true})
(map :n :k "v:count == 0 ? 'gk' : 'k'" {:expr true :silent true})
(map :n :j "v:count == 0 ? 'gj' : 'j'" {:expr true :silent true})
(map :v :x "'d'" {:expr true :silent true})
(map :n :<leader>1 vim.diagnostic.goto_prev {:desc "Go to previous diagnostic"})
(map :n :<leader>2 vim.diagnostic.goto_next {:desc "Go to next diagnostic"})
(map :n :<leader>k vim.diagnostic.open_float {:desc "Float diagnostic"})
(map :n :<leader>q vim.diagnostic.setloclist {:desc "Open diagnostic list"})
(map :n :<S-h> :<C-o> {:noremap true :silent true})
(map :n :<S-l> :<C-i> {:noremap true :silent true})
(map :n :<leader>w :viw {:noremap true :silent true})

(vim.cmd "set clipboard+=unnamedplus")

(set _G.Rename_tmux_pane
     (fn []
       (local cd (vim.fn.fnamemodify (vim.fn.expand "%:p:h") ":t"))
       (vim.api.nvim_command (.. "silent !tmux rename-window '" cd "'"))))

(vim.api.nvim_command "autocmd DirChanged * lua Rename_tmux_pane()")

(vim.api.nvim_create_autocmd :FileType
                             {:pattern :gleam
                              :callback (fn []
                                          (set vim.opt_local.expandtab true)
                                          (set vim.opt_local.shiftwidth 2)
                                          (set vim.opt_local.tabstop 2)
                                          (set vim.opt_local.softtabstop 2))})

(local lazy (require :lazy))
(lazy.setup [{:import :plugins}
             {:import :plugins.themes}
             {:import :ftplugins}
             [:tpope/vim-sensible
              :udayvir-singh/hibiscus.nvim
              :udayvir-singh/tangerine.nvim]])
