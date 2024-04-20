-- :fennel:1713652954
local opt
local function _1_()
  return (_G.vim.o.columns * 0.5)
end
local function _2_(term)
  _G.assert((nil ~= term), "Missing argument term on plugins/toggleterm.fnl:4")
  return term.name
end
opt = {direction = "float", size = _1_, autochdir = true, winbar = {enabled = true, name_formatter = _2_}, open_mapping = "<c-o>", terminal_mappings = true}
local function _3_()
  return require("toggleterm").setup(opt)
end
return {"akinsho/toggleterm.nvim", lazy = true, keys = {{"<c-o>", "<cmd>ToggleTerm<cr>", desc = "Toggle term"}}, config = _3_}