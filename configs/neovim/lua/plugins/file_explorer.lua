-- :fennel:1716450276
local opts = {close_if_last_window = true, window = {position = "right", width = 40, mapping_options = {noremap = true, nowait = true}, mappings = {l = "open_tab_drop", ["<space>"] = false}}, filesystem = {follow_current_file = {enabled = true}, filtered_items = {hide_by_name = {"node_modules", "target", ".git"}, never_show = {[".DS_Store"] = "thumbs.db"}, hide_dotfiles = false}}}
local function _1_()
  _G.vim.fn.sign_define("DiagnosticSignError", {text = "\239\129\151 ", texthl = "DiagnosticSignError"})
  _G.vim.fn.sign_define("DiagnosticSignWarn", {text = "\239\129\177 ", texthl = "DiagnosticSignWarn"})
  _G.vim.fn.sign_define("DiagnosticSignInfo", {text = "\239\129\154 ", texthl = "DiagnosticSignInfo"})
  _G.vim.fn.sign_define("DiagnosticSignHint", {text = "\239\160\180", texthl = "DiagnosticSignHint"})
  return require("neo-tree").setup(opts)
end
return {"nvim-neo-tree/neo-tree.nvim", branch = "v3.x", event = "BufEnter", keys = {{"<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree"}}, dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"}, config = _1_}