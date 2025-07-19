(local opts (lambda []
              (local view (require :iron.view))
              (local iron (require :iron))
              (iron.setup {:config {:repl_definition {:go {:command [:gore
                                                                     :-autoimport]}}}
                           :repl_open_cmd {:split_DEFAULT (view.split "40%")}
                           :keymaps {:toggle_repl :<leader>or}})))

{1 :Vigemus/iron.nvim :config opts :enabled false}
