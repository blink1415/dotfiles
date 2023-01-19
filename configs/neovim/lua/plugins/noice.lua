return {
  "folke/noice.nvim",
  lazy = false,
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
        long_message_to_split = false,
        inc_rename = true,
        lsp_doc_border = true,
      },
    })
    require("telescope").load_extension("noice")
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    'nvim-telescope/telescope.nvim',
  }
}
