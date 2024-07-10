{1 :epwalsh/obsidian.nvim
 :version "*"
 :lazy true
 :ft :markdown
 :dependencies [:nvim-lua/plenary.nvim]
 :keys [{1 :<leader>nd
         2 :<cmd>ObsidianDailies<cr>
         :mode :n
         :desc "Open daily notes"}]
 :opts {:workspaces [{:name :personal :path "~/vaults/personal"}
                     {:name :work :path "~/vaults/work"}]}}

