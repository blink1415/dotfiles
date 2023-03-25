return {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    enabled = false,
    event = "InsertEnter",
    dependencies = {
        "jay-babu/mason-null-ls.nvim",
        "nvim-lua/plenary.nvim",
        "williamboman/mason.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-null-ls").setup({
            ensure_installed = { "stylua", "jq", "rustfmt", "gofumpt", "prettierd" },
            automatic_installation = true,
            automatic_setup = true,
        })
        require("null-ls").setup()

        require 'mason-null-ls'.setup_handlers()
    end
}
