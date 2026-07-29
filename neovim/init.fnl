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
; helix-style gutter: no line numbers, single sign column for git diff only
(set vim.wo.number false)
(set vim.o.fillchars "eob: ")
(set vim.o.mouse :a)
(set vim.o.breakindent true)
(set vim.o.autoindent true)
(set vim.o.undofile true)
(set vim.o.ignorecase true)
(set vim.o.smartcase true)
(set vim.o.updatetime 250)
(set vim.wo.signcolumn "yes:1")
(vim.diagnostic.config {:signs false})
(set vim.o.termguicolors true)
(set vim.o.completeopt "menuone,noselect")
(set vim.o.cursorline true)
(set vim.o.tabstop 4)
(set vim.o.shiftwidth 4)
(set vim.o.conceallevel 0)
(set vim.o.laststatus 3)
(set vim.o.relativenumber false)
(set vim.o.scrolloff 8)

; mason bin on PATH without loading mason.nvim (it is lazy-loaded on :Mason);
; lets LSP servers and conform formatters resolve their executables
(set vim.env.PATH (.. (vim.fn.stdpath :data) "/mason/bin:" vim.env.PATH))

; Enable LSP inlay hints
(vim.lsp.inlay_hint.enable)

(map :n :<Space> :<Nop> {:silent true})
(map :n :k "v:count == 0 ? 'gk' : 'k'" {:expr true :silent true})
(map :n :j "v:count == 0 ? 'gj' : 'j'" {:expr true :silent true})
(map :n :<leader>1 vim.diagnostic.goto_prev {:desc "Go to previous diagnostic"})
(map :n :<leader>2 vim.diagnostic.goto_next {:desc "Go to next diagnostic"})
(map :n :<leader>w :viw {:noremap true :silent true})

; Helix keybinds (x select-line, goto/match/space modes, unimpaired, ...)
; all live in fnl/plugins/helix.fnl

(vim.cmd "set clipboard+=unnamedplus")

(set _G.Rename_tmux_pane
     (fn []
       (local cd (vim.fn.fnamemodify (vim.fn.expand "%:p:h") ":t"))
       (vim.api.nvim_command (.. "silent !tmux rename-window '" cd "'"))))

(vim.api.nvim_command "autocmd DirChanged * lua Rename_tmux_pane()")

(local language_opts {[:gleam :typescript :typescriptreact :haskell] {:expandtab true
                                                                      :shiftwidth 2
                                                                      :softtabstop 2}
                      [:go :php :rust] {:expandtab false
                                        :shiftwidth 4
                                        :softtabstop 4}})

(each [languages config (pairs language_opts)]
  (each [_ lang (pairs languages)]
    (vim.api.nvim_create_autocmd :FileType
                                 {:pattern lang
                                  :callback (fn []
                                              (each [opt val (pairs config)]
                                                (tset vim.opt_local opt val)))})))

(local lazy (require :lazy))
(lazy.setup [{:import :plugins}
             {:import :plugins.themes}
             {:import :ftplugins}
             [:whmountains/tangerine.nvim]])
