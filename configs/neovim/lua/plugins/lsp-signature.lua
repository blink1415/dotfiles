return {
    "ray-x/lsp_signature.nvim",
    lazy = true,
    event = "InsertEnter",
    config = function()
        require("lsp_signature").setup()
    end
}
