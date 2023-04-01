return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies =
    {
        'nvim-lua/plenary.nvim',
        "ahmedkhalf/project.nvim",
    },
    event = "BufEnter",
    config = function()
        local actions = require("telescope.actions")
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                        ['<esc>'] = actions.close
                    },
                },
            },
        }
        require("project_nvim").setup({
            detection_methods = { "lsp", "pattern" },
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
            ignore_lsp = {},
            exclude_dirs = {},
            show_hidden = true,
            silent_chdir = true,
            scope_chdir = "global",
            datapath = vim.fn.stdpath("data"),
        })
        require("telescope").load_extension('projects')

        vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
            { desc = 'Find recently opened files' })
        -- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
        --     { desc = 'Find existing buffers' })
        vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer]' })

        vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'Search files' })
        vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = 'Search help' })
        vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = 'Search current word' })
        vim.keymap.set('n', '<leader>g', require('telescope.builtin').live_grep, { desc = 'Search by grep' })
        vim.keymap.set('n', '<leader>ld', require('telescope.builtin').diagnostics, { desc = 'Search diagnostics' })
        vim.keymap.set('n', '<leader>p', "<cmd>Telescope projects<cr>", { desc = 'Search projects' })
    end
}
