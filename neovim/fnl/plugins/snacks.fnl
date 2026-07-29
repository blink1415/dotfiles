{1 :folke/snacks.nvim
 :event :VeryLazy
 :opts {:bigfile {}
        :indent {}
        :words {:debounce 0}
        :image {}
        :picker {:win {:input {:keys {:<Esc> {1 :close :mode [:n :i]}}}}}
        :input {}
        :explorer {}
        :gitbrowse {}}
 :keys [{1 :<leader>lw
         2 (lambda []
             (if (_G.Snacks.words:is_enabled)
                 (_G.Snacks.words:disable)
                 (_G.Snacks.words:enable)))
         :desc "Toggle word highlights"}
        {1 :<leader>f
         2 (lambda []
             (local root (_G.vim.fs.root 0 :.git))
             (_G.Snacks.picker.files (if root {:cwd root} {})))
         :desc "Find files (repo)"}
        {1 :<leader>F
         2 (lambda [] (_G.Snacks.picker.files))
         :desc "Find files (cwd)"}
        {1 :<leader>/
         2 (lambda []
             (local root (_G.vim.fs.root 0 :.git))
             (_G.Snacks.picker.grep (if root {:cwd root} {})))
         :desc "Live grep"}
        {1 "<leader>*"
         2 (lambda [] (_G.Snacks.picker.grep_word))
         :desc "Grep word under cursor"}
        {1 :<leader>p
         2 (lambda []
             (_G.Snacks.picker.projects {:win {:minimal false}}))
         :desc "Find projects"}
        {1 :<leader><space>
         2 (lambda [] (_G.Snacks.picker.buffers))
         :desc "Find in buffers"}
        {1 :<leader>G
         2 (lambda [] (_G.Snacks.gitbrowse.open))
         :desc "Open in remote (gitbrowse)"}
        {1 :<leader>oi
         2 (lambda [] (_G.Snacks.picker.icons))
         :desc "Search icons"}]}
