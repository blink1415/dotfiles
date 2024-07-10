(local opts
       {:close_if_last_window true
        :window {:position :right
                 :width 40
                 :mapping_options {:noremap true :nowait true}
                 :mappings {:l :open_tab_drop :<space> false}}
        :filesystem {:follow_current_file {:enabled true}
                     :filtered_items {:hide_dotfiles false
                                      :hide_by_name [:node_modules
                                                     :target
                                                     :.git]
                                      :never_show {:.DS_Store :thumbs.db}}}})

{1 :nvim-neo-tree/neo-tree.nvim
 :branch :v3.x
 :event :BufEnter
 :keys [{1 :<leader>e 2 "<cmd>Neotree toggle<cr>" :desc "Toggle Neotree"}]
 :dependencies [:nvim-lua/plenary.nvim
                :nvim-tree/nvim-web-devicons
                :MunifTanjim/nui.nvim]
 :config (lambda []
           (_G.vim.fn.sign_define :DiagnosticSignError
                                  {:text " " :texthl :DiagnosticSignError})
           (_G.vim.fn.sign_define :DiagnosticSignWarn
                                  {:text " " :texthl :DiagnosticSignWarn})
           (_G.vim.fn.sign_define :DiagnosticSignInfo
                                  {:text " " :texthl :DiagnosticSignInfo})
           (_G.vim.fn.sign_define :DiagnosticSignHint
                                  {:text "" :texthl :DiagnosticSignHint})
           ((. (require :neo-tree) :setup) opts))}

