return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim", -- required by telescope
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "rcarriga/nvim-notify",
    },
    opts = {
        -- configuration goes here
        lang = "rust",
        arg = "leetcode",
    },
    config = function(_, opts)
        vim.keymap.set("n", "<leader>mlq", "<cmd>LcQuestionTabs<cr>")
        vim.keymap.set("n", "<leader>mlm", "<cmd>LcMenu<cr>")
        vim.keymap.set("n", "<leader>mlc", "<cmd>LcConsole<cr>")
        vim.keymap.set("n", "<leader>mll", "<cmd>LcLanguage<cr>")
        vim.keymap.set("n", "<leader>mld", "<cmd>LcDescriptionToggle<cr>")

        require("leetcode").setup(opts)
    end,
}
