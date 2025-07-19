[{1 :echasnovski/mini.statusline
  :version "*"
  :enabled false
  :config (lambda []
            (local statusline (require :mini.statusline))
            (statusline.setup {:set_vim_settings true})
            (set _G.vim.o.laststatus 3))
  :Lazy false}
 {1 :rebelot/heirline.nvim
  :lazy false
  :enabled false
  :dependencies [:Zeioth/heirline-components.nvim]
  :config (lambda []
            (local heirline (require :heirline))
            (local heirline_components (require :heirline-components.all))
            (heirline_components.init.subscribe_to_events)
            (heirline.load_colors (heirline_components.hl.get_colors))
            (local opts
                   {:statusline {:hl {:fg :fg :bg :bg}
                                 1 (heirline_components.component.mode)
                                 2 (heirline_components.component.git_branch)
                                 3 (heirline_components.component.file_info)
                                 4 (heirline_components.component.git_diff)
                                 5 (heirline_components.component.diagnostics)
                                 6 (heirline_components.component.fill)
                                 7 (heirline_components.component.cmd_info)
                                 8 (heirline_components.component.fill)
                                 9 (heirline_components.component.lsp)
                                 10 (heirline_components.component.compiler_state)
                                 11 (heirline_components.component.virtual_env)
                                 12 (heirline_components.component.nav)
                                 heirline_components.component.mode {:surround {:separator :right}}}
                    :winbar {1 (heirline_components.component.breadcrumbs)}})
            (heirline.setup opts))}
 {1 :sschleemilch/slimline.nvim
  :opts {:style :fg
         :components {:left [:mode :path :git]
                      :center []
                      :right [:diagnostics :filetype_lsp :progress]}}
  :lazy false
  :dependencies [:echasnovski/mini.icons :lewis6991/gitsigns.nvim]}]
