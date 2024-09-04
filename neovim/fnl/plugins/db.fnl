[{1 :kndndrj/nvim-dbee
  :dependencies [:MunifTanjim/nui.nvim]
  :build (fn []
           (pcall _G.vim.cmd :DBeeInstall))
  :config (lambda []
            ((. (require :dbee) :setup)))
  :keys [{1 :<leader>do
          2 "<cmd>lua require('dbee').toggle()<cr>"
          :desc "Toggle DBee"}]
  :opts {:editor {:mappings [{:key :<leader>dr :mode :n :action :run_file}
                             {:key :<leader>dr :mode :v :action :run_selection}]}}}]

