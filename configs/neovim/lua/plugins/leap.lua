-- :fennel:1713652954
local function _1_()
  return require("leap").add_default_mappings()
end
return {"ggandor/leap.nvim", event = "BufEnter", config = _1_}