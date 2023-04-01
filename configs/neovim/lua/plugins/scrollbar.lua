return {
    "petertriho/nvim-scrollbar",
    config = function()
        require("scrollbar").setup({
            handle = {
                hide_if_all_visible = true,
            }
        })
    end
}
