return {
    "kylechui/nvim-surround",
    lazy = true,
    event = "InsertEnter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require("nvim-surround").setup()
    end
}
