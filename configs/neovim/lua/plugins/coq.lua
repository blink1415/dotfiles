return {
    "ms-jpq/coq_nvim",
    event = "InsertEnter",
    enabled = false,
    dependencies = {
        {
            "ms-jpq/coq.artifacts",
            branch = "artifacts",
        },
        {
            "ms-jpq/coq.thirdparty",
            branch = "3p",
        },
        "neovim/nvim-lspconfig"
    },
    config = function()
        local lsp = require "lspconfig"
        local coq = require "coq" -- add this

        -- lsp.<server>.setup(<stuff...>)                              -- before
        -- lsp.<server>.setup(coq.lsp_ensure_capabilities(<stuff...>)) -- after
    end
}
