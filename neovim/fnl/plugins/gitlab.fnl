{1 :harrisoncramer/gitlab.nvim
 :dependencies [:MunifTanjim/nui.nvim
                :nvim-lua/plenary.nvim
                :sindrets/diffview.nvim
                :stevearc/dressing.nvim
                :nvim-tree/nvim-web-devicons]
 :keys [{1 :<leader>om
         2 "<cmd>lua require('gitlab').choose_merge_request()<cr>"
         :desc "Open Gitlab merge requests"}]
 :build (lambda [] (local gitlab_server (require :gitlab.server))
          (gitlab_server.build true))
 :opts {:config_path "~/.gitlab.nvim"}}
