return {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    lazy = true,
    keys = {
        { "<leader>lS", "<cmd>GoFillStruct<cr>", desc = "Fill struct" },
        { "<leader>lt", "<cmd>GoTestSum<cr>", desc = "Run tests" },
    },
    config = function()
        require("go").setup({
            -- test_runner = "gotestsum",
            run_in_floaterm = true,
        })
    end,
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}
