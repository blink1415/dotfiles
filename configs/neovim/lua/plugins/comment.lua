return {
    "numToStr/Comment.nvim",
    lazy = true,
    event = "InsertEnter",
    config = function()
        require("Comment").setup({
            mappings = true
        })
    end
}
