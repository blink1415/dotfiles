; no gc/gcc mappings — gc/gb are helix goto-mode (plugins/helix.fnl);
; commenting is <leader>c/<leader>b and C-c
{1 :numToStr/Comment.nvim
 :lazy true
 :event :VeryLazy
 :opts {:mappings {:basic false :extra false}
        :toggler {:line :<leader>c :block :<leader>b}
        :opleader {:line :<leader>c :block :<leader>b}}}
