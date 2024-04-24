-- :fennel:1713653077
local notify_config = {render = "compact", fps = 30, top_down = false}
local noice_config = {lsp = {override = {["vim.lsp.util.convert_input_to_markdown_lines"] = true, ["vim.lsp.util.stylize_markdown"] = true, ["cmp.entry.get_documentation"] = true}}, presets = {command_palette = true, long_message_to_split = true, inc_rename = true, bottom_search = false, lsp_doc_border = false}, signature = {enabled = false}}
local function _1_()
  require("noice").setup(noice_config)
  require("notify").setup(notify_config)
  return require("telescope").load_extension("noice")
end
return {"folke/noice.nvim", dependencies = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify", "nvim-telescope/telescope.nvim"}, keys = {{"<leader>ns", "<cmd>Noice telescope<cr>", desc = "Search message log"}, {"<leader>nv", "<cmd>Noice<cr>", desc = "View message log"}}, opt = noice_config, config = _1_, lazy = false}