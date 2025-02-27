{1 :folke/snacks.nvim
 :event :VeryLazy
 :opts {:bigfile {}
        :indent {}
        :words {:debounce 0}
        :image {}
        :picker {}
        :input {}
        :notifier {}
        :explorer {}
        :scroll {}
        :gitbrowse {}}
 :keys [{1 :<leader>lw
         2 (lambda []
             (if (_G.Snacks.words:is_enabled)
                 (_G.Snacks.words:disable)
                 (_G.Snacks.words:enable)))
         :desc "Toggle word highlights"}
        {1 :<leader>f
         2 (lambda [] (_G.Snacks.picker.files))
         :desc "Find files"}
        {1 :<leader>g 2 (lambda [] (_G.Snacks.picker.grep)) :desc :Grep}
        {1 :<leader>p
         2 (lambda []
             (_G.Snacks.picker.projects {:win {:minimal false}}))
         :desc "Find projects"}
        {1 :<leader>ss
         2 (lambda [] (_G.Snacks.picker.git_status))
         :desc "Find in git status"}
        {1 :<leader><space>
         2 (lambda [] (_G.Snacks.picker.buffers))
         :desc "Find in buffers"}
        {1 :<leader>G
         2 (lambda [] (_G.Snacks.gitbrowse.open))
         :desc "Search icons"}
        {1 :<leader>si
         2 (lambda [] (_G.Snacks.picker.icons))
         :desc "Search icons"}
        {1 :<leader>ss
         2 (lambda [] (_G.Snacks.picker.git_status))
         :desc "Find in git status"}
        {1 :<leader>sh
         2 (lambda [] (_G.Snacks.notifier.show_history))
         :desc "Find in git status"}]}
