-- :fennel:1713383605
local config
local function _1_()
  return (vim.o.columns * 0.5)
end
local function _2_(term)
  return term.name
end
config = {direction = "float", size = _1_, autochdir = true, winbar = {enabled = true, name_formatter = _2_}, open_mapping = "<c-o>", terminal_mappings = true}
local function _3_()
  return require("toggleterm").setup(config)
end
return {"akinsho/toggleterm.nvim", lazy = true, keys = {{"<c-o>", "<cmd>ToggleTerm<cr>", desc = "Toggle term"}}, config = _3_}