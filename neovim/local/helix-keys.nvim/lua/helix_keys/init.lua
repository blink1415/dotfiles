-- helix_keys: Helix-style (selection -> action) keymaps for Neovim.
--
-- Helix's "normal mode with a selection" is modelled with Visual mode:
--   * w/b/e/x/mi/... select text, then d/c/y/r/... act on the selection
--   * `v` toggles select (extend) mode, where motions grow the selection
--   * <Esc> leaves select mode first, then collapses the selection
--   * d/c/y/... also work in Normal mode on the character under the
--     cursor, which is Helix's 1-wide selection
--
-- Multi-cursor commands (s, S, C, K, `,`, ...) have no Neovim equivalent
-- and are left unmapped.
local M = {}

local api, fn = vim.api, vim.fn

local defaults = {
  -- groups of mappings; set any to false to skip it
  goto_mode = true, -- g prefix
  match_mode = true, -- m prefix (brackets, surround, textobjects)
  view_mode = true, -- z prefix
  space_mode = true, -- <Space> pickers/LSP; never replaces an existing mapping
  unimpaired = true, -- ]/[ prefix
  insert = true, -- insert-mode editing keys
  -- after a / or ? search, select the match like Helix does
  select_search = true,
}

M.skipped = {}

local extending = false

local function set_extending(value)
  extending = value
  vim.schedule(function() vim.cmd.redrawstatus() end)
end

local function in_visual()
  local m = fn.mode()
  return m == "v" or m == "V" or m == "\22"
end

--- Statusline helper: "NOR", "SEL" or "INS" like Helix.
function M.mode()
  local m = fn.mode()
  if m:find("^[iR]") then return "INS" end
  if extending then return "SEL" end
  return "NOR"
end

local function esc() vim.cmd("normal! \27") end

local function notify(msg) vim.notify(msg, vim.log.levels.WARN, { title = "helix-keys" }) end

-- positions are {row (1-based), col (0-based byte)} like nvim_win_get_cursor

local function get_line(row) return api.nvim_buf_get_lines(0, row - 1, row, true)[1] end

local function char_at(row, col)
  local line = get_line(row)
  if col >= #line then return "\n" end
  return fn.strpart(line, col, 1, true)
end

-- byte column where the character before `col` starts
local function prev_col(line, col) return col - 1 + vim.str_utf_start(line, col) end

local function last_col(line)
  if #line == 0 then return 0 end
  return prev_col(line, #line)
end

-- 0 newline, 1 whitespace, 2 punctuation (or any WORD char), 3 word char
local function class(ch, big)
  if ch == "\n" then return 0 end
  if ch:match("^%s") then return 1 end
  if big or fn.match(ch, [[\k]]) < 0 then return 2 end
  return 3
end

local function before(a, b) return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2]) end

local function motion_target(pos, keys)
  api.nvim_win_set_cursor(0, pos)
  vim.cmd("normal! " .. keys)
  return api.nvim_win_get_cursor(0)
end

local function select_range(anchor, head)
  if in_visual() then esc() end
  api.nvim_win_set_cursor(0, anchor)
  vim.cmd("normal! v")
  api.nvim_win_set_cursor(0, head)
end

-- Helix word motions: `w` selects up to the next word start, `e` up to the
-- word end, `b` back to the word start. Each press skips the boundary the
-- cursor sits on, so repeating walks word by word.
local function word_step(key, cur)
  local big = key:match("%u") ~= nil
  local motion = key:lower()
  local here = char_at(cur[1], cur[2])

  if motion == "b" then
    local anchor = cur
    if cur[2] > 0 then
      local pc = prev_col(get_line(cur[1]), cur[2])
      if class(char_at(cur[1], pc), big) ~= class(here, big) then anchor = { cur[1], pc } end
    end
    local head = motion_target(cur, key)
    if not before(head, anchor) then head = anchor end
    return anchor, head
  end

  local anchor = cur
  local nxt = char_at(cur[1], cur[2] + #here)
  if nxt == "\n" then
    if cur[1] < api.nvim_buf_line_count(0) then anchor = { cur[1] + 1, 0 } end
  elseif class(here, big) ~= class(nxt, big) then
    anchor = { cur[1], cur[2] + #here }
  end

  local head
  if motion == "e" then
    head = motion_target(cur, key)
  else
    local target = motion_target(anchor, key)
    local tl = get_line(target[1])
    local at_word_start = target[2] == 0
      or class(char_at(target[1], prev_col(tl, target[2])), big) ~= class(char_at(target[1], target[2]), big)
    if not at_word_start then
      -- no next word: `w` stopped on the last character of the buffer
      head = target
    elseif target[1] == anchor[1] and target[2] > anchor[2] then
      head = { target[1], prev_col(get_line(target[1]), target[2]) }
    else
      -- the next word is on a later line (or there is none)
      head = { anchor[1], last_col(get_line(anchor[1])) }
    end
  end
  if before(head, anchor) then head = anchor end
  return anchor, head
end

local function word(key)
  return function()
    local count = vim.v.count1
    local cur = api.nvim_win_get_cursor(0)
    local anchor, head
    for _ = 1, count do
      anchor, head = word_step(key, cur)
      cur = head
    end
    if extending then
      -- only the head moves; Visual mode keeps the anchor
      api.nvim_win_set_cursor(0, head)
    else
      select_range(anchor, head)
    end
  end
end

-- motion that collapses the selection first unless extending
local function move(keys)
  return function()
    if in_visual() and not extending then
      local count = vim.v.count > 0 and tostring(vim.v.count) or ""
      return "<Esc>" .. count .. keys
    end
    return keys
  end
end

-- sorted region of the selection (or the cursor character in Normal mode):
-- start row, start col, end row, exclusive end col, all 0-based
local function region()
  local a, b = fn.getpos("v"), fn.getpos(".")
  local visual = in_visual()
  if not visual then a = b end
  if a[2] > b[2] or (a[2] == b[2] and a[3] > b[3]) then a, b = b, a end
  local linewise = visual and fn.mode() == "V"
  local line = get_line(b[2])
  local sc = linewise and 0 or a[3] - 1
  local ec = linewise and #line or math.min(#line, b[3] - 1 + #char_at(b[2], b[3] - 1))
  return a[2] - 1, sc, b[2] - 1, ec, linewise
end

local bracket_pairs = {
  ["("] = { "(", ")" }, [")"] = { "(", ")" },
  ["["] = { "[", "]" }, ["]"] = { "[", "]" },
  ["{"] = { "{", "}" }, ["}"] = { "{", "}" },
  ["<"] = { "<", ">" }, [">"] = { "<", ">" },
}

local function pair_for(c) return bracket_pairs[c] or { c, c } end

local function read_char()
  local ok, c = pcall(fn.getcharstr)
  if not ok or c == "\27" then return nil end
  return c
end

-- positions {row0, col0} of the pair `c` surrounding the cursor
local function find_pair(c)
  local open, close = unpack(pair_for(c))
  local cur = api.nvim_win_get_cursor(0)

  if open == close then
    local line = api.nvim_get_current_line()
    local col = cur[2] + 1
    local left
    for i = col, 1, -1 do
      if line:sub(i, i) == open then left = i break end
    end
    if not left then return end
    local right = line:find(open, left + 1, true)
    if not right then
      -- cursor is on the closing quote
      right = left
      left = nil
      for i = right - 1, 1, -1 do
        if line:sub(i, i) == open then left = i break end
      end
      if not left then return end
    end
    return { cur[1] - 1, left - 1 }, { cur[1] - 1, right - 1 }
  end

  local po = open:gsub("[%[%]]", "\\%0")
  local pc = close:gsub("[%[%]]", "\\%0")
  local flags = char_at(cur[1], cur[2]) == close and "bnW" or "bcnW"
  local o = fn.searchpairpos(po, "", pc, flags)
  if o[1] == 0 then return end
  api.nvim_win_set_cursor(0, { o[1], o[2] - 1 })
  local cl = fn.searchpairpos(po, "", pc, "nW")
  api.nvim_win_set_cursor(0, cur)
  if cl[1] == 0 then return end
  return { o[1] - 1, o[2] - 1 }, { cl[1] - 1, cl[2] - 1 }
end

local function surround_add()
  local c = read_char()
  if not c then return end
  local open, close = unpack(pair_for(c))
  local sr, sc, er, ec, linewise = region()
  if in_visual() then esc() end
  if linewise then
    api.nvim_buf_set_lines(0, er + 1, er + 1, true, { close })
    api.nvim_buf_set_lines(0, sr, sr, true, { open })
  else
    api.nvim_buf_set_text(0, er, ec, er, ec, { close })
    api.nvim_buf_set_text(0, sr, sc, sr, sc, { open })
  end
end

local function surround_change(replace)
  return function()
    local from = read_char()
    if not from then return end
    local to = replace and read_char()
    if replace and not to then return end
    if in_visual() then esc() end
    local o, cl = find_pair(from)
    if not o then return notify("no surrounding " .. from .. " found") end
    local new_open, new_close = "", ""
    if to then new_open, new_close = unpack(pair_for(to)) end
    -- edit the closing side first so the opening position stays valid
    api.nvim_buf_set_text(0, cl[1], cl[2], cl[1], cl[2] + 1, { new_close })
    api.nvim_buf_set_text(0, o[1], o[2], o[1], o[2] + 1, { new_open })
  end
end

local function call_first(modules, name, ...)
  for _, mod in ipairs(modules) do
    local ok, m = pcall(require, mod)
    if ok and m[name] then
      m[name](...)
      return true
    end
  end
  return false
end

local function ts_select(query)
  -- `main` branch API first, then the older `master` one
  if call_first({ "nvim-treesitter-textobjects.select" }, "select_textobject", query, "textobjects") then
    return true
  end
  return call_first({ "nvim-treesitter.textobjects.select" }, "select_textobject", query, "textobjects", "x")
end

local function ts_move(name, query)
  local ok = call_first(
    { "nvim-treesitter-textobjects.move", "nvim-treesitter.textobjects.move" },
    name,
    query,
    "textobjects"
  )
  if not ok then notify("nvim-treesitter-textobjects is not available") end
end

local ts_objects = { f = "function", t = "class", a = "parameter", c = "comment", T = "test" }

local function textobject(kind)
  return function()
    local c = read_char()
    if not c then return end
    if in_visual() then esc() end
    if ts_objects[c] then
      local query = ("@%s.%s"):format(ts_objects[c], kind == "i" and "inner" or "outer")
      if not ts_select(query) then notify("nvim-treesitter-textobjects is not available") end
    elseif c == "g" then
      if not call_first({ "gitsigns" }, "select_hunk") then notify("gitsigns is not available") end
    else
      vim.cmd("normal! v" .. kind .. c)
    end
  end
end

local function shell(how)
  return function()
    if fn.mode() == "\22" then return notify("blockwise selections are not supported") end
    local visual = in_visual()
    local sr, sc, er, ec, linewise = region()
    local input = visual and table.concat(api.nvim_buf_get_text(0, sr, sc, er, ec, {}), "\n") or ""
    if visual then esc() end
    local prompts = { replace = "pipe: ", before = "insert-output: ", after = "append-output: " }
    vim.ui.input({ prompt = prompts[how] }, function(cmd)
      if not cmd or cmd == "" then return end
      local out = fn.system(cmd, input)
      if vim.v.shell_error ~= 0 then return notify(("`%s` failed:\n%s"):format(cmd, out)) end
      local lines = vim.split(out:gsub("\n$", ""), "\n", { plain = true })
      if linewise then
        if how == "replace" then
          api.nvim_buf_set_lines(0, sr, er + 1, true, lines)
        else
          local at = how == "before" and sr or er + 1
          api.nvim_buf_set_lines(0, at, at, true, lines)
        end
      elseif how == "replace" then
        api.nvim_buf_set_text(0, sr, sc, er, ec, lines)
      elseif how == "before" then
        api.nvim_buf_set_text(0, sr, sc, sr, sc, lines)
      else
        api.nvim_buf_set_text(0, er, ec, er, ec, lines)
      end
    end)
  end
end

local function comment(linewise)
  local ok, c = pcall(require, "vim._comment")
  if not ok then return "" end
  return c.operator() .. (linewise and "_" or "")
end

local function picker(name, opts, fallback)
  return function()
    local snacks = rawget(_G, "Snacks")
    if not snacks then
      local ok, mod = pcall(require, "snacks")
      snacks = ok and mod or nil
    end
    if snacks and snacks.picker and snacks.picker[name] then return snacks.picker[name](opts) end
    if fallback then return fallback() end
    notify("snacks.nvim is required for " .. name)
  end
end

local function taken(mode, lhs)
  local key = api.nvim_replace_termcodes(lhs, true, true, true)
  for _, m in ipairs(api.nvim_get_keymap(mode)) do
    local existing = api.nvim_replace_termcodes(m.lhs, true, true, true)
    -- a shorter existing map (like the usual <Space> -> <Nop>) is not a conflict
    if existing == key or vim.startswith(existing, key) then
      return true
    end
  end
  return false
end

-- nowait: d/c/y/m/... must fire at once even when a plugin maps a longer
-- key starting with them (ds, dm, ...), instead of waiting for timeoutlen
local function map(modes, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc, silent = true, nowait = true }, opts or {})
  vim.keymap.set(modes, lhs, rhs, opts)
end

local function expr(modes, lhs, rhs, desc, opts)
  map(modes, lhs, rhs, desc, vim.tbl_extend("force", { expr = true }, opts or {}))
end

local function del(modes, lhs)
  for _, m in ipairs(modes) do
    pcall(vim.keymap.del, m, lhs)
  end
end

local function setup_core()
  local nx = { "n", "x" }

  -- selection model
  for _, k in ipairs({ "w", "b", "e", "W", "B", "E" }) do
    map(nx, k, word(k), "Select word motion " .. k)
  end
  map("n", "v", function()
    vim.cmd("normal! v")
    set_extending(true)
  end, "Select mode")
  map("x", "v", function() set_extending(not extending) end, "Toggle select mode")
  map("x", "<Esc>", function()
    if extending then return set_extending(false) end
    esc()
  end, "Collapse selection")
  expr("x", ";", function() return "<Esc>" end, "Collapse selection")
  map("x", "<A-;>", "o", "Flip selection")
  map("x", "<A-:>", function()
    local a, b = fn.getpos("v"), fn.getpos(".")
    if b[2] < a[2] or (b[2] == a[2] and b[3] < a[3]) then vim.cmd("normal! o") end
  end, "Ensure selection is forward")
  map("n", "%", "ggVG", "Select all")
  map("x", "%", "<Esc>ggVG", "Select all")
  map("n", "x", "V", "Select line")
  expr("x", "x", function() return fn.mode() == "V" and "j" or "V" end, "Extend line selection")
  map("n", "X", "V", "Extend to line bounds")
  expr("x", "X", function() return fn.mode() == "V" and "" or "V" end, "Extend to line bounds")

  -- movement collapses the selection unless in select mode
  expr("x", "h", move("h"), "Left")
  expr("x", "l", move("l"), "Right")
  expr("x", "j", function() return move(vim.v.count == 0 and "gj" or "j")() end, "Down")
  expr("x", "k", function() return move(vim.v.count == 0 and "gk" or "k")() end, "Up")
  expr("x", "G", move("G"), "Goto line")
  map("n", "<C-s>", "m'", "Save to jumplist")
  map("n", "<A-.>", ";", "Repeat last f/t motion")

  -- search selects the match
  local function search_next(key)
    return function()
      if extending then return key end
      return (in_visual() and "<Esc>" or "") .. key .. "gn"
    end
  end
  expr(nx, "n", search_next("n"), "Select next search match")
  expr(nx, "N", search_next("N"), "Select previous search match")

  -- changes
  expr("n", "d", function() return "dl" end, "Delete selection")
  expr("n", "c", function() return "cl" end, "Change selection")
  expr("n", "y", function() return "yl" end, "Yank selection")
  map("n", "<A-d>", '"_dl', "Delete selection without yanking")
  map("n", "<A-c>", '"_cl', "Change selection without yanking")
  map("x", "<A-d>", '"_d', "Delete selection without yanking")
  map("x", "<A-c>", '"_c', "Change selection without yanking")
  map("x", "y", "ygv", "Yank selection")
  expr("x", "p", function() return '<Esc>`>"' .. vim.v.register .. "p" end, "Paste after selection")
  expr("x", "P", function() return '<Esc>`<"' .. vim.v.register .. "P" end, "Paste before selection")
  expr("x", "R", function() return '"' .. vim.v.register .. "P" end, "Replace selection with register")
  expr("n", "R", function() return 'v"' .. vim.v.register .. "P" end, "Replace selection with register")
  map("x", "i", "<Esc>`<i", "Insert before selection")
  map("x", "a", "<Esc>`>a", "Append after selection")
  map("x", "I", "<Esc>I", "Insert at line start")
  map("x", "A", "<Esc>A", "Insert at line end")
  map("x", "o", "<Esc>o", "Open line below")
  map("x", "O", "<Esc>O", "Open line above")
  map("n", "U", "<C-r>", "Redo")
  map("x", "u", "<Esc>u", "Undo")
  map("x", "U", "<Esc><C-r>", "Redo")
  map("n", "<A-u>", "g-", "Earlier in history")
  map("n", "<A-U>", "g+", "Later in history")
  map("n", "`", "gul", "Lowercase selection")
  map("x", "`", "u", "Lowercase selection")
  map("n", "<A-`>", "gUl", "Uppercase selection")
  map("x", "<A-`>", "U", "Uppercase selection")
  map("n", ">", ">>", "Indent")
  map("n", "<", "<<", "Unindent")
  map("x", ">", ">gv", "Indent")
  map("x", "<", "<gv", "Unindent")
  expr("n", "Q", function() return fn.reg_recording() == "" and "qq" or "q" end, "Record macro")
  map("n", "q", "@q", "Replay macro")
  expr("n", "<C-c>", function() return comment(true) end, "Toggle comment")
  expr("x", "<C-c>", function() return comment(false) end, "Toggle comment")
  map(nx, "|", shell("replace"), "Pipe selection through shell command")
  map(nx, "!", shell("before"), "Insert shell command output before selection")
  map(nx, "<A-!>", shell("after"), "Append shell command output after selection")

  -- treesitter node selection (Neovim's built-in an/in/]N/[N)
  expr("n", "<A-o>", function() return "<Cmd>normal! v<CR>an" end, "Expand selection", { remap = true })
  expr("x", "<A-o>", function() return "an" end, "Expand selection", { remap = true })
  expr("x", "<A-i>", function() return "in" end, "Shrink selection", { remap = true })
  expr("n", "<A-n>", function() return "<Cmd>normal! v<CR>]N" end, "Select next sibling", { remap = true })
  expr("x", "<A-n>", function() return "]N" end, "Select next sibling", { remap = true })
  expr("n", "<A-p>", function() return "<Cmd>normal! v<CR>[N" end, "Select previous sibling", { remap = true })
  expr("x", "<A-p>", function() return "[N" end, "Select previous sibling", { remap = true })
end

local function setup_goto()
  local nx = { "n", "x" }
  -- Neovim's defaults would make g/gr/gc wait for more keys
  del({ "n" }, "gcc")
  del({ "n", "x" }, "gc")
  for _, k in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
    del({ "n", "x" }, k)
  end

  expr(nx, "gh", move("0"), "Goto line start")
  expr(nx, "gl", move("$"), "Goto line end")
  expr(nx, "gs", move("^"), "Goto first non-blank")
  expr(nx, "ge", move("G"), "Goto last line")
  expr(nx, "gt", move("H"), "Goto window top")
  expr(nx, "gc", move("M"), "Goto window center")
  expr(nx, "gb", move("L"), "Goto window bottom")
  expr(nx, "g.", move("`."), "Goto last modification")
  map("n", "ga", "<C-^>", "Goto last accessed file")
  map("n", "gn", "<Cmd>bnext<CR>", "Goto next buffer")
  map("n", "gp", "<Cmd>bprevious<CR>", "Goto previous buffer")
  map("n", "gd", vim.lsp.buf.definition, "Goto definition")
  map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  map("n", "gy", vim.lsp.buf.type_definition, "Goto type definition")
  map("n", "gr", vim.lsp.buf.references, "Goto references")
  map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
end

local function setup_match()
  local nx = { "n", "x" }
  expr(nx, "mm", function()
    -- plain % is remapped to select-all, so go through matchit or :normal!
    local extend = in_visual() and extending
    local plug = extend and "<Plug>(MatchitVisualForward)" or "<Plug>(MatchitNormalForward)"
    if fn.maparg(plug, extend and "x" or "n") == "" then plug = "<Cmd>normal! %<CR>" end
    return (in_visual() and not extending and "<Esc>" or "") .. plug
  end, "Goto matching bracket", { remap = true })
  map(nx, "ms", surround_add, "Surround add")
  map(nx, "mr", surround_change(true), "Surround replace")
  map(nx, "md", surround_change(false), "Surround delete")
  map(nx, "mi", textobject("i"), "Select inside textobject")
  map(nx, "ma", textobject("a"), "Select around textobject")
end

local function setup_view()
  local nx = { "n", "x" }
  map(nx, "zj", "<C-e>", "Scroll down")
  map(nx, "zk", "<C-y>", "Scroll up")
  map(nx, "zc", "zz", "Center cursor")
end

local function setup_unimpaired()
  local nx = { "n", "x" }
  expr(nx, "]p", move("}"), "Next paragraph")
  expr(nx, "[p", move("{"), "Previous paragraph")
  map("n", "]g", function() call_first({ "gitsigns" }, "nav_hunk", "next") end, "Next change")
  map("n", "[g", function() call_first({ "gitsigns" }, "nav_hunk", "prev") end, "Previous change")
  for key, object in pairs({ f = "function", t = "class", a = "parameter", c = "comment", T = "test" }) do
    local query = "@" .. object .. ".outer"
    map(nx, "]" .. key, function() ts_move("goto_next_start", query) end, "Next " .. object)
    map(nx, "[" .. key, function() ts_move("goto_previous_start", query) end, "Previous " .. object)
  end
end

local function setup_insert()
  map("i", "<C-k>", "<C-o>D", "Delete to line end")
  map("i", "<C-d>", "<Del>", "Delete next char")
  map("i", "<A-d>", "<C-o>dw", "Delete next word")
  map("i", "<A-BS>", "<C-w>", "Delete previous word")
end

local function setup_space()
  local lsp = vim.lsp.buf
  local entries = {
    { "f", picker("files"), "File picker" },
    { "F", picker("files", { cwd = fn.getcwd() }), "File picker (cwd)" },
    { "b", picker("buffers"), "Buffer picker" },
    { "j", picker("jumps"), "Jumplist picker" },
    { "s", picker("lsp_symbols", nil, lsp.document_symbol), "Symbol picker" },
    { "S", picker("lsp_workspace_symbols", nil, lsp.workspace_symbol), "Workspace symbol picker" },
    { "d", picker("diagnostics_buffer", nil, vim.diagnostic.setloclist), "Diagnostic picker" },
    { "D", picker("diagnostics", nil, vim.diagnostic.setqflist), "Workspace diagnostic picker" },
    { "g", picker("git_status"), "Changed file picker" },
    { "'", picker("resume"), "Last picker" },
    { "/", picker("grep"), "Global search" },
    { "?", picker("commands"), "Command palette" },
    { "e", picker("explorer"), "File explorer" },
    { "a", lsp.code_action, "Code action", { "n", "x" } },
    { "r", lsp.rename, "Rename symbol" },
    { "k", lsp.hover, "Hover" },
    { "h", picker("lsp_references", nil, lsp.references), "Symbol references" },
    { "w", "<C-w>", "Window mode" },
    { "y", '"+y', "Yank to clipboard", { "x" } },
    { "p", '"+p', "Paste clipboard after", { "n" } },
    { "P", '"+P', "Paste clipboard before", { "n" } },
    { "R", '"+P', "Replace selection with clipboard", { "x" } },
  }
  for _, e in ipairs(entries) do
    local lhs = "<Space>" .. e[1]
    for _, mode in ipairs(e[4] or { "n" }) do
      if taken(mode, lhs) then
        table.insert(M.skipped, mode .. " " .. lhs .. " (" .. e[3] .. ")")
      else
        map(mode, lhs, e[2], e[3])
      end
    end
  end
end

local function setup_autocmds()
  local group = api.nvim_create_augroup("helix_keys", { clear = true })
  api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = function()
      if extending and not vim.v.event.new_mode:find("^[vV\22]") then set_extending(false) end
    end,
  })

  if not M.config.select_search then return end
  local pending = false
  local function search(key)
    return function()
      if in_visual() and not extending then
        pending = true
        return "<Esc>" .. key
      end
      pending = not in_visual()
      return key
    end
  end
  expr({ "n", "x" }, "/", search("/"), "Search forward")
  expr({ "n", "x" }, "?", search("?"), "Search backward")
  api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    pattern = { "/", "?" },
    callback = function()
      if not pending then return end
      pending = false
      if vim.v.event.abort then return end
      -- runs right after the search itself, before any later typed keys
      api.nvim_feedkeys("gn", "ni", false)
    end,
  })
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", defaults, opts or {})
  M.skipped = {}
  setup_core()
  if M.config.goto_mode then setup_goto() end
  if M.config.match_mode then setup_match() end
  if M.config.view_mode then setup_view() end
  if M.config.unimpaired then setup_unimpaired() end
  if M.config.insert then setup_insert() end
  if M.config.space_mode then setup_space() end
  setup_autocmds()
end

return M
