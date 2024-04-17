-- :fennel:1713377620
local function _1_()
  return vim.cmd.colorscheme("kanagawa-lotus")
end
return {"rebelot/kanagawa.nvim", priority = 1000, init = _1_, lazy = false}