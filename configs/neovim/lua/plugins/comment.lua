return {
    "numToStr/Comment.nvim",
    lazy = true,
    event = "BufEnter",
    config = function()
        require("Comment").setup({
            mappings = {
                basic = true,
                extra = false,
            }
        })
    end
}
