[{1 :supermaven-inc/supermaven-nvim
  :lazy true
  :enabled false
  :event [:InsertEnter]
  :opts {:ignore_filetypes {:TelescopePrompt true
                            :TelescopeResults true
                            :csv true
                            :json true
                            :dbee true}}}
                            {1 :folke/sidekick.nvim
                            :opts  {
    :cli  {
      :mux  {
        :backend  "zellij"
        :enabled  true
      }
    }
  }
                            }
 {1 :coder/claudecode.nvim
  :dependencies [:folke/snacks.nvim]
  :opts {}
  :keys [{1 :<leader>ac 2 :<cmd>ClaudeCode<cr> :desc "Toggle Claude"}]}]
