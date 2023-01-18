return {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "v3.*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function ()
        require("bufferline").setup({

        })
    end
}
