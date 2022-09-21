local config = {

  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 STABLE ONLY
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_reload = false, -- automatically reload and sync packer after a successful update
    auto_quit = false, -- automatically quit the current session after a successful update
  },
  colorscheme = "kanagawa",

  highlights = {
    default_theme = function(highlights) -- or a function that returns a new table of colors to set
      local C = require "default_theme.colors"
      highlights.Normal = { fg = C.fg, bg = C.bg }
      return highlights
    end,
  },

  -- vim options
  options = {
    opt = {
      relativenumber = false, -- sets vim.opt.relativenumber
      foldcolumn = 'auto',
      foldlevel = 99,
      foldlevelstart = 99,
      foldenable = true,
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
    },
  },
  default_theme = {
    diagnostics_style = { italic = true },
    colors = {
      fg = "#abb2bf",
      bg = "#1e222a",
    },
    plugins = {
      aerial = true,
      beacon = false,
      bufferline = true,
      dashboard = true,
      highlighturl = true,
      hop = false,
      indent_blankline = true,
      lightspeed = false,
      ["neo-tree"] = true,
      notify = true,
      ["nvim-tree"] = false,
      ["nvim-web-devicons"] = true,
      rainbow = true,
      symbols_outline = false,
      telescope = true,
      vimwiki = false,
      ["which-key"] = true,
    },
  },

  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    servers = {
      "sumneko_lua"
    },
  },

  -- Mapping data with "desc" stored directly by vim.keymap.set().
  --
  -- Please use this mappings table to set keyboard mapping since this is the
  -- lower level configuration and more robust one. (which-key will
  -- automatically pick-up stored data by this setting.)
  mappings = {
    -- first key is the mode
    n = {
      -- second key is the lefthand side of the map
      -- mappings seen under group name "Buffer"
      ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
      ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
      ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
      ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
      ["<leader>fp"] = { "<cmd>Telescope projects<cr>", desc = "Open project" },
      -- ["<C-+>"] = { "<cmd>ToggleTerm<cr>" },
      -- quick save
      -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  },

  -- Configure plugins
  plugins = {
    init = {
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },

      -- You can also add new plugins here as well:
      -- Add plugins, the packer syntax without the "use"
      -- { "andweeb/presence.nvim" },
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },

      { "rebelot/kanagawa.nvim" ,
        config = function()
          require('kanagawa').setup({
              undercurl = true,           -- enable undercurls
              commentStyle = { italic = true },
              functionStyle = {},
              keywordStyle = { italic = true},
              statementStyle = { bold = true },
              typeStyle = {},
              variablebuiltinStyle = { italic = true},
              specialReturn = true,       -- special highlight for the return keyword
              specialException = true,    -- special highlight for exception handling keywords
              transparent = false,        -- do not set background color
              dimInactive = false,        -- dim inactive window `:h hl-NormalNC`
              globalStatus = true,       -- adjust window separators highlight for laststatus=3
              terminalColors = true,      -- define vim.g.terminal_color_{0,17}
              colors = {},
              overrides = {},
              theme = "default"           -- Load "default" theme or the experimental "light" theme
          })
        end,
      },
      { "ray-x/go.nvim", 
        config = function()
          require('go').setup({

            disable_defaults = false, -- true|false when true set false to all boolean settings and replace all table
            -- settings with {}
            go='go', -- go command, can be go[default] or go1.18beta1
            goimport='gopls', -- goimport command, can be gopls[default] or goimport
            fillstruct = 'gopls', -- can be nil (use fillstruct, slower) and gopls
            gofmt = 'gofumpt', --gofmt cmd,
            max_line_len = 128, -- max line length in golines format, Target maximum line length for golines
            tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
            gotests_template = "", -- sets gotests -template parameter (check gotests for details)
            gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)
            comment_placeholder = '' ,  -- comment_placeholder your cool placeholder e.g. ﳑ       
            icons = {breakpoint = '🧘', currentpos = '🏃'},  -- setup to `false` to disable icons setup
            verbose = false,  -- output loginf in messages
            lsp_cfg = false, -- true: use non-default gopls setup specified in go/lsp.lua
                             -- false: do nothing
                             -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
                             --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
            lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
            lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua,
                                 --      when lsp_cfg is true
                                 -- if lsp_on_attach is a function: use this function as on_attach function for gopls
            lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
            lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
            -- function(bufnr)
            --    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
            -- end
            -- to setup a table of codelens
            lsp_diag_hdlr = true, -- hook lsp diag handler
            -- virtual text setup
            lsp_diag_virtual_text = { space = 0, prefix = "" },
            lsp_diag_signs = true,
            lsp_diag_update_in_insert = false,
            lsp_document_formatting = true,
            -- set to true: use gopls to format
            -- false if you want to use other formatter tool(e.g. efm, nulls)
           lsp_inlay_hints = {
              enable = true,
              -- Only show inlay hints for the current line
              only_current_line = false,
              -- Event which triggers a refersh of the inlay hints.
              -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
              -- not that this may cause higher CPU usage.
              -- This option is only respected when only_current_line and
              -- autoSetHints both are true.
              only_current_line_autocmd = "CursorHold",
              -- whether to show variable name before type hints with the inlay hints or not
              -- default: false
              show_variable_name = true,
              -- prefix for parameter hints
              parameter_hints_prefix = " ",
              show_parameter_hints = true,
              -- prefix for all the other hints (type, chaining)
              other_hints_prefix = "=> ",
              -- whether to align to the lenght of the longest line in the file
              max_len_align = false,
              -- padding from the left if max_len_align is true
              max_len_align_padding = 1,
              -- whether to align to the extreme right or not
              right_align = false,
              -- padding from the right if right_align is true
              right_align_padding = 6,
              -- The color of the hints
              highlight = "Comment",
            },
            gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
            gopls_remote_auto = true, -- add -remote=auto to gopls
            gocoverage_sign = "█",
            sign_priority = 5, -- change to a higher number to override other signs
            dap_debug = true, -- set to false to disable dap
            dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
                                     -- false: do not use keymap in go/dap.lua.  you must define your own.
                                     -- windows: use visual studio keymap
            dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
            dap_debug_vt = true, -- set to true to enable dap virtual text
            build_tags = "tag1,tag2", -- set default build tags
            textobjects = true, -- enable default text jobects through treesittter-text-objects
            test_runner = 'go', -- one of {`go`, `richgo`, `dlv`, `ginkgo`}
            verbose_tests = true, -- set to add verbose flag to tests
            run_in_floaterm = false, -- set to true to run in float window. :GoTermClose closes the floatterm
                                     -- float term recommand if you use richgo/ginkgo with terminal color

            trouble = false, -- true: use trouble to open quickfix
            test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
            luasnip = false, -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
            --  Do not enable this if you already added the path, that will duplicate the entries
          })
        end
      },

      {
        "kevinhwang91/nvim-ufo",
        requires = 'kevinhwang91/promise-async',
        config = function()
          require("ufo").setup({

          })
        end,
      },
      {
        "kylechui/nvim-surround",
        config = function()
          require("nvim-surround").setup({

          })
        end,
      },
      {
        "ahmedkhalf/project.nvim",
        config = function()
          require("project_nvim").setup({
            detection_methods = { "lsp", "pattern" },
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
            ignore_lsp = {},

            -- Don't calculate root dir on specific directories
            -- Ex: { "~/.cargo/*", ... }
            exclude_dirs = {},

            -- Show hidden files in telescope
            show_hidden = true,
            silent_chdir = true,
            scope_chdir = 'global',
            datapath = vim.fn.stdpath("data"),
          })
        end,
      },
      { "ray-x/guihua.lua" },
      { "mfussenegger/nvim-dap" },
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      -- { "leoluz/nvim-dap-go" },
      -- We also support a key value style plugin definition similar to NvChad:
      -- ["ray-x/lsp_signature.nvim"] = {
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },
    },
    -- All other entries override the require("<key>").setup({...}) call for default plugins
    ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
      -- config variable is the default configuration table for the setup functino call
      local null_ls = require "null-ls"
      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      config.sources = {
        -- Set a formatter
        -- null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettier,
      }
      -- set up null-ls's on_attach function
      -- NOTE: You can remove this on attach function to disable format on save
      config.on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end
      return config -- return final config table to use in require("null-ls").setup(config)
    end,
    treesitter = { -- overrides `require("treesitter").setup(...)`
      ensure_installed = { "lua" },
    },
    -- use mason-lspconfig to configure LSP installations
    ["mason-lspconfig"] = { -- overrides `require("mason-lspconfig").setup(...)`
      ensure_installed = { "sumneko_lua" },
    },
    -- use mason-tool-installer to configure DAP/Formatters/Linter installation
    ["mason-tool-installer"] = { -- overrides `require("mason-tool-installer").setup(...)`
      -- ensure_installed = { "prettier", "stylua" },
    },
    packer = { -- overrides `require("packer").setup(...)`
      compile_path = vim.fn.stdpath "data" .. "/packer_compiled.lua",
    },

    -- Configure plugins
    gitsigns = {
      signs = {
        add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "▎", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = {
          hl = "GitSignsDelete",
          text = "契",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "▎",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
      },
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter_opts = {
        relative_time = false,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      yadm = {
        enable = false,
      },
    },
  ["neo-tree"] = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 0,
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        with_expanders = false,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
      },
      git_status = {
        symbols = {
          added = "",
          deleted = "",
          modified = "",
          renamed = "➜",
          untracked = "★",
          ignored = "◌",
          unstaged = "✗",
          staged = "✓",
          conflict = "",
        },
      },
    },
    window = {
      position = "left",
      width = 25,
      mappings = {
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        ["o"] = "open",
        ["l"] = "open",
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["C"] = "close_node",
        ["h"] = "close_node",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["R"] = "refresh",
        ["/"] = "fuzzy_finder",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["a"] = "add",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["Y"] = {
          "copy_to_clipboard",
          config = {
            show_path = "relative"
          }
        },
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy",
        ["m"] = "move",
        ["q"] = "close_window",
        ["<space>"] = false,
      },
    },
    nesting_rules = {},
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          "node_modules",
          "__pycache__",
          ".git",
        },
      },
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
    },
    buffers = {
      show_unloaded = true,
      window = {
        mappings = {
          ["bd"] = "buffer_delete",
        },
      },
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"] = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        },
      },
    },

    event_handlers = {
      {
        event = "vim_buffer_enter",
        handler = function(_)
          if vim.bo.filetype == "neo-tree" then
            vim.wo.signcolumn = "auto"
          end
        end,
      },
    },
  },

  toggleterm = {
    size = 10,
    open_mapping = [[<C-t><C-t>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
  },

  -- LuaSnip Options
  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {},
    -- Extend filetypes
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Modify which-key registration (Use this with mappings table in the above.)
  ["which-key"] = {
    -- Add bindings which show up as group name
    register_mappings = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- third key is the key to bring up next level and its displayed
          -- group name in which-key top level menu
          ["b"] = { name = "Buffer" },
          ["D"] = { name = "Buffer" },
        },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set key binding
    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })

    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}
require('telescope').load_extension('projects')

return config
