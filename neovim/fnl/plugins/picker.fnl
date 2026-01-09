{1 :dmtrKovalenko/fff.nvim
 :build "cargo build --release"
 :opts {}
 :enabled false
 :keys [{1 :ff
         2 (lambda []
             (local fff (require :fff))
             (fff.find_in_git_root))
         :desc "Open file picker"}]}
