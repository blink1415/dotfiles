return {
    "ErichDonGubler/lsp_lines.nvim",
    config = function()
        require("lsp_lines").setup()

        -- Disable virtual_text since it's redundant due to lsp_lines.
        vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = true,
        })
        local toggle = function()
            local new_lines = not vim.diagnostic.config().virtual_lines
            vim.diagnostic.config({ virtual_lines = new_lines })
            local new_text = not vim.diagnostic.config().virtual_text
            vim.diagnostic.config({ virtual_text = new_text })
        end
        map("n", "<leader>lL", toggle, { desc = "Toggle lsp lines" })
    end
}
