[{1 :tpope/vim-fugitive}
 {1 :lewis6991/gitsigns.nvim
  :lazy true
  :event :BufEnter
  :opts {:signs {:add {:text "+"}
                 :change {:text "~"}
                 :delete {:text "_"}
                 :topdelete {:text "‾"}
                 :changedelete {:text "~"}}
         :numhl true
         :current_line_blame true
         :current_line_blame_opts {:virt_text true
                                   :virt_text_pos :eol
                                   :delay 0
                                   :ignore_whitespace false}}}]

