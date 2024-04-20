(local notify_config {:render :compact :fps 30 :top_down false})

(local noice_config {:lsp {:override {:vim.lsp.util.convert_input_to_markdown_lines true
                                      :vim.lsp.util.stylize_markdown true
                                      :cmp.entry.get_documentation true}}
                     :presets {:bottom_search false
                               :command_palette true
                               :long_message_to_split true
                               :inc_rename true
                               :lsp_doc_border false}
                     :signature {:enabled false}})

{1 :folke/noice.nvim
 :dependencies [:MunifTanjim/nui.nvim
                :rcarriga/nvim-notify
                :nvim-telescope/telescope.nvim]
 :lazy false
 :keys [{1 :<leader>ns 2 "<cmd>Noice telescope<cr>" :desc "Search message log"}
        {1 :<leader>nv 2 :<cmd>Noice<cr> :desc "View message log"}]
 :opt noice_config
 :config (lambda []
           ((. (require :noice) :setup) noice_config)
           ((. (require :notify) :setup) notify_config)
           ((. (require :telescope) :load_extension) :noice))}

