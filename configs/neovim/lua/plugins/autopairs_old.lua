return {
    "windwp/nvim-autopairs",
    lazy = true,
    enabled = false,
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup()
    end
}
