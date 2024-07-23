{1 :mrjones2014/smart-splits.nvim
 :lazy true
 :event :BufEnter
 :keys [{1 :<C-h>
         2 :<cmd>SmartCursorMoveLeft<cr>
         :mode :n
         :desc "Move cursor to a pane to the left"}
        {1 :<C-j>
         2 :<cmd>SmartCursorMoveDown<cr>
         :mode :n
         :desc "Move cursor to a pane below"}
        {1 :<C-k>
         2 :<cmd>SmartCursorMoveUp<cr>
         :mode :n
         :desc "Move cursor to a pane above"}
        {1 :<C-l>
         2 :<cmd>SmartCursorMoveRight<cr>
         :mode :n
         :desc "Move cursor to a pane to the right"}]
 :opts {:multiplexer_integration :tmux}}

