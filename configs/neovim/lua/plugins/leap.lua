-- :fennel:1713653077
local function _1_()
  return require("leap").add_default_mappings()
end
return {"ggandor/leap.nvim", event = "BufEnter", config = _1_}