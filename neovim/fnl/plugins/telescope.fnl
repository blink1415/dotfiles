(local map _G.vim.keymap.set)

{1 :nvim-telescope/telescope.nvim
 :tag :0.1.6
 :dependencies [:nvim-lua/plenary.nvim]
 :lazy true
 :event :VeryLazy
 :opts {}
 :init (lambda []
         (local actions (require :telescope.actions))
         ((. (require :telescope) :setup) {:defaults {:mappings {:i {:<C-j> actions.move_selection_next
                                                                     :<C-k> actions.move_selection_previous
                                                                     :<esc> actions.close}}}}))}
