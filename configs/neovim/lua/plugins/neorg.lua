return {
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        config = function()
            require("neorg").setup({
                load = {
                        ["core.defaults"] = {},   -- Loads default behaviour
                        ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
                        ["core.norg.dirman"] = {  -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                        },
                    },
                },
            })
        end,
        keys = {
            { "<leader>o", "<cmd>Neorg<cr>", desc = "Open neorg" },
        },
        dependencies = { { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" } },
    }
}
