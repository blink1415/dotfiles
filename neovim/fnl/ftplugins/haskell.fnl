(local vim _G.vim)
{1 :mrcjkb/haskell-tools.nvim
 :dependencies [:nvim-lua/plenary.nvim]
 :version :^4
 :ft [:haskell :lhaskell :cabal :cabalproject]
 :config (lambda []
           (local ht (require :haskell-tools))
           (local bufnr (vim.api.nvim_get_current_buf))
           (local opts {:noremap true :silent true :buffer bufnr})
           (vim.keymap.set :n :<space>lc vim.lsp.codelens.run opts)
           (vim.keymap.set :n :<space>lh ht.hoogle.hoogle_signature opts)
           (vim.keymap.set :n :<space>le ht.lsp.buf_eval_all opts)
           (vim.keymap.set :n :<leader>lrr ht.repl.toggle opts)
           (vim.keymap.set :n :<leader>lrf
                           (lambda []
                             (ht.repl.toggle (vim.api.nvim_buf_get_name 0)))
                           opts)
           (vim.keymap.set :n :<leader>lrq ht.repl.quit opts))}

