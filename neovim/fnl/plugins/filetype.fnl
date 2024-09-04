(local vim _G.vim)
(local haskell (lambda []
                 (print "Setting up haskell")
                 (set vim.o.expandtab true)
                 (set vim.o.shiftwidth 4)))

{1 :nathom/filetype.nvim
 :enabled false
 :opts {:overrides {:function_extensions {[:hs :lhs] haskell}}}}

