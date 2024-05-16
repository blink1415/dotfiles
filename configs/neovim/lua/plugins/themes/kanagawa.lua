-- :fennel:1714687446
local function _1_()
  return _G.vim.cmd.colorscheme("kanagawa-lotus")
end
return {"rebelot/kanagawa.nvim", priority = 1000, init = _1_, lazy = false}