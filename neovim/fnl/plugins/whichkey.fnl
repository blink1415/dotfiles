{1 :folke/which-key.nvim
 :event :VeryLazy
 :opts {:preset :helix :delay 0}
 :keys [{1 :<leader>?
         2 (lambda []
             (local wk (require :which-key))
             (wk.show {:global false}))
         :desc "Buffer Local Keymaps (which-key)"}]}
