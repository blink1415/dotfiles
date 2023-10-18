return {
  "folke/noice.nvim",
  lazy = false,
  keys = {
    { "<leader>ns", "<cmd>Noice telescope<cr>", desc = "Search message log" },
    { "<leader>nv", "<cmd>Noice<cr>", desc = "View message log" },
  },
  config = function()
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = false,
      },
      signature = {
        enabled = false
      }
    })
    require("telescope").load_extension("noice")
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    'nvim-telescope/telescope.nvim',
  }
}
