{1 :folke/noice.nvim
 :dependencies [:MunifTanjim/nui.nvim]
 :lazy false
 :keys [{1 :<leader>ns 2 "<cmd>Noice telescope<cr>" :desc "Search message log"}
        {1 :<leader>nv 2 :<cmd>Noice<cr> :desc "View message log"}]
 :opts {:lsp {:override {:vim.lsp.util.convert_input_to_markdown_lines true
                         :vim.lsp.util.stylize_markdown true
                         :cmp.entry.get_documentation true}}
        :presets {:bottom_search false
                  :command_palette true
                  :long_message_to_split true
                  :inc_rename true
                  :lsp_doc_border false}
        :signature {:enabled false}}}
