return {
    "github/copilot.vim",
    lazy = true,
    event = "InsertEnter",
    keys = {
        { "<leader>lc", "<cmd>Copilot enable<cr>", desc = "Enable copilot" },
        { "<leader>lC", "<cmd>Copilot disable<cr>", desc = "Disable copilot" },
    },
    config = function()
    end
}
