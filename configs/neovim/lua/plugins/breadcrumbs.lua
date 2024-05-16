-- :fennel:1715594128
local function _1_()
  require("nvim-navic").setup({lsp = {auto_attach = true}})
  return require("breadcrumbs").setup()
end
return {"LunarVim/breadcrumbs.nvim", dependencies = {"SmiteshP/nvim-navic"}, config = _1_, event = "BufEnter"}