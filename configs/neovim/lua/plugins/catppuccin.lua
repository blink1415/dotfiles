return {
    "catppuccin/nvim",
    lazy = false,
    priority = 10000,
    config = function()
        require("catppuccin").setup()
    end
}

