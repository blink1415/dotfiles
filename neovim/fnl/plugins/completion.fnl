(local cmp_config (lambda [cmp]
                    {:mapping {:<CR> (cmp.mapping.confirm {:select true})
                               :<C-Space> (cmp.mapping.complete)
                               :<C-j> (cmp.mapping.select_next_item)
                               :<C-k> (cmp.mapping.select_prev_item)}
                     :window {:completion {:winhighlight "Normal:Pmenu,FloatBorder:Pmenu,Search:None"
                                           :col_offset -3
                                           :side_padding 0}}
                     :formatting {:fields [:kind :abbr :menu]
                                  :format (fn [entry vim_item]
                                            (local kind_opts
                                                   {:mode :symbol_textlsp
                                                    :maxwidth 50})
                                            (local lspkind (require :lspkind))
                                            (local kind
                                                   ((lspkind.cmp_format kind_opts) entry
                                                                                   vim_item))
                                            (local strings
                                                   (_G.vim.split kind.kind "%s"
                                                                 {:trimempty true}))
                                            (set kind.kind
                                                 (.. (.. " "
                                                         (or (. strings 1) ""))
                                                     " "))
                                            (set kind.menu
                                                 (.. (.. "    ("
                                                         (or (. strings 2) ""))
                                                     ")"))
                                            kind)}}))

{1 :yioneko/nvim-cmp
 :branch :perf
 :dependencies [:hrsh7th/cmp-nvim-lsp :neovim/nvim-lspconfig]
 :config (lambda []
           (local cmp (require :cmp))
           (cmp.setup (cmp_config cmp)))}

