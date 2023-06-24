return {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    enabled = true,
    event = "InsertEnter",
    dependencies = {
        "jay-babu/mason-null-ls.nvim",
        "nvim-lua/plenary.nvim",
        "williamboman/mason.nvim",
        "lukas-reineke/lsp-format.nvim",
    },
    config = function()
        require("null-ls").setup()
        require("mason").setup()
        require("mason-null-ls").setup({
            ensure_installed = {},
            automatic_installation = true,
            automatic_setup = true,
        })

        -- require('mason-null-ls').setup_handlers()
        --
        -- require("lsp-format").setup {}
        -- require("lspconfig").gofumpt.setup { on_attach = require("lsp-format").on_attach }
        -- require("lspconfig").rustfmt.setup { on_attach = require("lsp-format").on_attach }
        -- require("lspconfig").prettierd.setup { on_attach = require("lsp-format").on_attach }
        -- require("lspconfig").stylua.setup { on_attach = require("lsp-format").on_attach }
    end
}
