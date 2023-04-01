return {
    "catppuccin/nvim",
    lazy = false,
    enabled = false,
    priority = 10000,
    config = function()
        require("catppuccin").setup()
        vim.cmd([[colorscheme catppuccin-latte]])
    end
}
