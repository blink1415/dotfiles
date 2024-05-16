-- :fennel:1714687446
local function _1_()
  local neoclip = require("neoclip")
  return neoclip.setup()
end
return {"AckslD/nvim-neoclip.lua", dependencies = {"nvim-telescope/telescope.nvim"}, config = _1_}