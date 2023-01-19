return {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "v3.*",
    enabled = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function ()
        require("bufferline").setup({

        })
    end
}
