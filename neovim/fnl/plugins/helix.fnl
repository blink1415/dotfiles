; Helix keymap parity layer — https://docs.helix-editor.com/keymap.html
; Standalone: every helix-emulation keymap lives here. Related pieces
; elsewhere: AniMotion (motions.fnl) gives select-first w/e/b; treesitter.fnl
; provides mi-f/ma-f textobjects, ]f [f ]t [t ]a [a ]c [c motions and
; Alt-o/Alt-i expand/shrink selection; smart-splits gives C-h/C-l view moves.
; mini.surround (this spec) provides match-mode surround: ms / mr / md.
;
; Deliberately NOT ported (no single-selection equivalent / conflicts):
;   s S A-s & _ , C ( )  -> multi-cursor machinery (s stays leap)
;   Q q                  -> vim macro keys kept native (q also stops recording)
;   space-? command palette -> <leader>? is which-key buffer keymaps
;   gm goto_last_modified_file, ]T [T tests, K keep_selections

(local map _G.vim.keymap.set)

(fn helix_keymaps []
  ;; nvim's builtin grr/grn/gra/gri/gcc defaults are 3-key, which forces a
  ;; timeoutlen wait on every gr/gc press; their functions are on helix keys
  ;; (gr space-r space-a gi <leader>c) so drop them
  (each [_ lhs (ipairs [:grr :grn :gra :gri :grt :gcc])]
    (pcall _G.vim.keymap.del :n lhs))
  (pcall _G.vim.keymap.del :x :gra)
  ;; --- selections ---
  (map :n :x :V {:desc "Select line"})
  (map :v :x "mode() ==# 'V' ? 'j' : 'V'"
       {:expr true :silent true :desc "Extend line selection"})
  (map [:n :v] :X :V {:desc "Extend to line bounds"})
  (map :n "%" :ggVG {:desc "Select all"})
  (map :v ";" :<esc> {:desc "Collapse selection"})
  (map :v "<M-;>" :o {:desc "Flip selection direction"})
  ;; --- changes ---
  (map :n :U :<C-r> {:desc "Redo"})
  (map :n :<M-u> :g- {:desc "Undo earlier"})
  (map :n :<M-U> "g+" {:desc "Redo later"})
  (map :v :R :P {:desc "Replace selection with yanked"})
  (map :v "`" :u {:desc "Lowercase selection"})
  (map :v "<M-`>" :U {:desc "Uppercase selection"})
  (map :v :<M-d> "\"_d" {:desc "Delete without yank"})
  (map :v :<M-c> "\"_c" {:desc "Change without yank"})
  (map :v ">" :>gv {:desc "Indent (keep selection)"})
  (map :v "<" :<gv {:desc "Unindent (keep selection)"})
  (map :v "=" (lambda [] ((. (require :conform) :format) {:lsp_format :fallback}))
       {:desc "Format selection"})
  (map :v "|" ":!" {:desc "Pipe selection through shell"})
  (map :v "*" "y/\\V<C-r>\"<cr>" {:desc "Search for selection"})
  ;; --- movement ---
  (map :n :<C-s> "m'" {:desc "Save position to jumplist"})
  (map :n "<M-.>" ";" {:desc "Repeat last f/t"})
  (map :n :<S-h> :<C-o> {:noremap true :silent true :desc "Jump backward"})
  (map :n :<S-l> :<C-i> {:noremap true :silent true :desc "Jump forward"})
  ;; --- goto mode ---
  (map [:n :v :o] :gh "0" {:desc "Goto line start"})
  (map [:n :v :o] :gl "$" {:desc "Goto line end"})
  (map [:n :v :o] :gs "^" {:desc "Goto first non-blank"})
  (map [:n :v :o] :ge "G" {:desc "Goto last line"})
  (map [:n :v] :gt :H {:desc "Goto window top"})
  (map [:n :v] :gc :M {:desc "Goto window center"})
  (map [:n :v] :gb :L {:desc "Goto window bottom"})
  (map :n :ga "<C-^>" {:desc "Goto last accessed buffer"})
  (map :n :gn :<cmd>bnext<cr> {:desc "Next buffer"})
  (map :n :gp :<cmd>bprevious<cr> {:desc "Prev buffer"})
  (map :n "g." "`." {:desc "Goto last modification"})
  (map :n :gw "<Plug>(leap)" {:remap true :desc "Goto word (leap)"})
  (map :n :gy (lambda [] (_G.Snacks.picker.lsp_type_definitions))
       {:desc "Goto type definition"})
  ;; gd/gr/gi live in lsp.fnl (snacks pickers); gf/gg are native
  ;; --- match mode (ms/mr/md via mini.surround opts below) ---
  (map [:n :v] :mm "%" {:remap true :desc "Goto matching bracket"})
  (map :n :mi "vi" {:desc "Select inside textobject"})
  (map :n :ma "va" {:desc "Select around textobject"})
  (map :v :mi "i" {:desc "Select inside textobject"})
  (map :v :ma "a" {:desc "Select around textobject"})
  ;; --- comments ---
  (map :n :<C-c> "<Plug>(comment_toggle_linewise_current)"
       {:remap true :desc "Toggle comment"})
  (map :v :<C-c> "<Plug>(comment_toggle_linewise_visual)"
       {:remap true :desc "Toggle comment"})
  ;; --- space mode ---
  (map :n :<leader>k _G.vim.lsp.buf.hover {:desc "Hover"})
  ; <leader>f / <leader>F / <leader>/ are snacks pickers (snacks.fnl)
  (map :n :<leader>j (lambda [] (_G.Snacks.picker.jumps)) {:desc "Jumplist"})
  (map :n :<leader>g (lambda [] (_G.Snacks.picker.git_status))
       {:desc "Changed files"})
  (map :n :<leader>s (lambda [] (_G.Snacks.picker.lsp_symbols))
       {:desc "Symbols"})
  (map :n :<leader>S (lambda [] (_G.Snacks.picker.lsp_workspace_symbols))
       {:desc "Workspace symbols"})
  (map :n :<leader>d (lambda [] (_G.Snacks.picker.diagnostics_buffer))
       {:desc "Diagnostics (buffer)"})
  (map :n :<leader>D (lambda [] (_G.Snacks.picker.diagnostics))
       {:desc "Diagnostics (workspace)"})
  (map :n :<leader>r _G.vim.lsp.buf.rename {:desc "Rename symbol"})
  (map :n :<leader>a "<cmd>lua require('tiny-code-action').code_action()<cr>"
       {:desc "Code action"})
  (map :n "<leader>'" (lambda [] (_G.Snacks.picker.resume))
       {:desc "Last picker"})
  ;; --- unimpaired ---
  (map :n "]D" (lambda [] (_G.vim.diagnostic.jump {:count 999999 :wrap false}))
       {:desc "Last diagnostic"})
  (map :n "[D" (lambda [] (_G.vim.diagnostic.jump {:count -999999 :wrap false}))
       {:desc "First diagnostic"})
  (map [:n :v] "]g" (lambda [] ((. (require :gitsigns) :nav_hunk) :next))
       {:desc "Next git change"})
  (map [:n :v] "[g" (lambda [] ((. (require :gitsigns) :nav_hunk) :prev))
       {:desc "Prev git change"})
  (map :n "]<space>" "<cmd>call append(line('.'), '')<cr>"
       {:desc "Add newline below"})
  (map :n "[<space>" "<cmd>call append(line('.')-1, '')<cr>"
       {:desc "Add newline above"}))

[; select-first w/e/b word motions (the core helix editing model); carries
 ; the keymaps above in :init (runs at startup, plugin loads at VeryLazy)
 {1 :luiscassih/AniMotion.nvim
  :event :VeryLazy
  :opts {:color {:bg "#c9cbd0"} :mode :helix :edit_keys [:c :d :s :r :y :p]}
  :init helix_keymaps}
 ; helix match-mode surround: ms / mr / md; lazy-loads on first use
 {1 :echasnovski/mini.surround
  :version "*"
  :keys [{1 :ms :mode [:n :x]} {1 :mr} {1 :md}]
  :opts {:mappings {:add :ms
                    :delete :md
                    :replace :mr
                    :find ""
                    :find_left ""
                    :highlight ""
                    :update_n_lines ""
                    :suffix_last ""
                    :suffix_next ""}}}]
