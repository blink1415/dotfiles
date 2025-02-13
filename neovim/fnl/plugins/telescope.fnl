(local map _G.vim.keymap.set)

{1 :nvim-telescope/telescope.nvim
 :tag :0.1.6
 :dependencies [:nvim-lua/plenary.nvim :blink1415/project.nvim]
 :lazy false
 :priority 10000
 :opts {}
 :init (lambda []
         (local actions (require :telescope.actions))
         ((. (require :telescope) :setup) {:defaults {:mappings {:i {:<C-j> actions.move_selection_next
                                                                     :<C-k> actions.move_selection_previous
                                                                     :<esc> actions.close}}}})
         ((. (require :project_nvim) :setup) {:detection_methods [:pattern]
                                              :patterns [:.git]
                                              :ignore_lsp {}
                                              :exclude_dirs {}
                                              :show_hidden false
                                              :silent_chdir true
                                              :scope_chdir :global
                                              :datapath (_G.vim.fn.stdpath :data)})
         (local fuzzy_opts
                ((. (require :telescope.themes) :get_dropdown) {:winblend 10
                                                                :previewer false}))
         (local buffer_fuzzy_find
                (lambda []
                  ((. (require :telescope.builtin) :current_buffer_fuzzy_find) fuzzy_opts)))
         (map :n :<leader>/ buffer_fuzzy_find)
         (if (= (length (_G.vim.fn.argv)) 0)
             (do
               (_G.vim.defer_fn (fn [] (_G.vim.cmd "Telescope projects")) 0))))}
