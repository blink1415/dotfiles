local config = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")
    local colors = require 'kanagawa.colors'.setup() -- wink
    require('heirline').load_colors(colors)

    local Align = { provider = "%=" }
    local Space = { provider = " " }

    local ViMode = {
        -- get vim current mode, this information will be required by the provider
        -- and the highlight functions, so we compute it only once per component
        -- evaluation and store it as a component attribute
        init = function(self)
            self.mode = vim.fn.mode(1) -- :h mode()

            -- execute this only once, this is required if you want the ViMode
            -- component to be updated on operator pending mode
            if not self.once then
                vim.api.nvim_create_autocmd("ModeChanged", {
                    pattern = "*:*o",
                    command = 'redrawstatus'
                })
                self.once = true
            end
        end,
        -- Now we define some dictionaries to map the output of mode() to the
        -- corresponding string and color. We can put these into `static` to compute
        -- them at initialisation time.
        static = {
            mode_names = { -- change the strings if you like it vvvvverbose!
                n = "N",
                no = "N?",
                nov = "N?",
                noV = "N?",
                ["no\22"] = "N?",
                niI = "Ni",
                niR = "Nr",
                niV = "Nv",
                nt = "Nt",
                v = "V",
                vs = "Vs",
                V = "V_",
                Vs = "Vs",
                ["\22"] = "^V",
                ["\22s"] = "^V",
                s = "S",
                S = "S_",
                ["\19"] = "^S",
                i = "I",
                ic = "Ic",
                ix = "Ix",
                R = "R",
                Rc = "Rc",
                Rx = "Rx",
                Rv = "Rv",
                Rvc = "Rv",
                Rvx = "Rv",
                c = "C",
                cv = "Ex",
                r = "...",
                rm = "M",
                ["r?"] = "?",
                ["!"] = "!",
                t = "T",
            },
            mode_colors = {
                n = "red",
                i = "green",
                v = "cyan",
                V = "cyan",
                ["\22"] = "cyan",
                c = "orange",
                s = "purple",
                S = "purple",
                ["\19"] = "purple",
                R = "orange",
                r = "orange",
                ["!"] = "red",
                t = "red",
            }
        },
        -- We can now access the value of mode() that, by now, would have been
        -- computed by `init()` and use it to index our strings dictionary.
        -- note how `static` fields become just regular attributes once the
        -- component is instantiated.
        -- To be extra meticulous, we can also add some vim statusline syntax to
        -- control the padding and make sure our string is always at least 2
        -- characters long. Plus a nice Icon.
        provider = function(self)
            return " %2(" .. self.mode_names[self.mode] .. "%)"
        end,
        -- Same goes for the highlight. Now the foreground will change according to the current mode.
        hl = function(self)
            local mode = self.mode:sub(1, 1) -- get only the first mode character
            return { fg = self.mode_colors[mode], bold = true, }
        end,
        -- Re-evaluate the component only on ModeChanged event!
        -- This is not required in any way, but it's there, and it's a small
        -- performance improvement.
        update = {
            "ModeChanged",
        },
    }
    ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode })


    local FileNameBlock = {
        -- let's first set up some attributes needed by this component and it's children
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
        end,
    }
    -- We can now define some children separately and add them later

    local FileIcon = {
        init = function(self)
            local filename = self.filename
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
                { default = true })
        end,
        provider = function(self)
            return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end
    }

    local FileName = {
        provider = function(self)
            -- first, trim the pattern relative to the current directory. For other
            -- options, see :h filename-modifers
            local filename = vim.fn.fnamemodify(self.filename, ":.")
            if filename == "" then return "[No Name]" end
            -- now, if the filename would occupy more than 1/4th of the available
            -- space, we trim the file path to its initials
            -- See Flexible Components section below for dynamic truncation
            if not conditions.width_percent_below(#filename, 0.25) then
                filename = vim.fn.pathshorten(filename)
            end
            return filename
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
    }

    local FileFlags = {
        {
            condition = function()
                return vim.bo.modified
            end,
            provider = "[+]",
            hl = { fg = "green" },
        },
        {
            condition = function()
                return not vim.bo.modifiable or vim.bo.readonly
            end,
            provider = "",
            hl = { fg = "orange" },
        },
    }

    -- Now, let's say that we want the filename color to change if the buffer is
    -- modified. Of course, we could do that directly using the FileName.hl field,
    -- but we'll see how easy it is to alter existing components using a "modifier"
    -- component

    local FileNameModifer = {
        hl = function()
            if vim.bo.modified then
                -- use `force` because we need to override the child's hl foreground
                return { fg = "cyan", bold = true, force = true }
            end
        end,
    }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        FileFlags,
        { provider = '%<' }-- this means that the statusline is cut here when there's not enough space
    )
    local Navic = {
        condition = require("nvim-navic").is_available,
        provider = function()
            require("nvim-navic").get_location({ highlight = true })
        end,
        update = 'CursorMoved'
    }

    local Diagnostics = {

        condition = conditions.has_diagnostics,

        static = {
            -- error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
            -- warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
            -- info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
            -- hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
        },

        init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        update = { "DiagnosticChanged", "BufEnter" },

        {
            provider = "![",
        },
        {
            provider = function(self)
                -- 0 is just another output, we can decide to print it or not!
                return self.errors > 0 and (self.error_icon .. self.errors .. " ")
            end,
            hl = { fg = "diag_error" },
        },
        {
            provider = function(self)
                return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
            end,
            hl = { fg = "diag_warn" },
        },
        {
            provider = function(self)
                return self.info > 0 and (self.info_icon .. self.info .. " ")
            end,
            hl = { fg = "diag_info" },
        },
        {
            provider = function(self)
                return self.hints > 0 and (self.hint_icon .. self.hints)
            end,
            hl = { fg = "diag_hint" },
        },
        {
            provider = "]",
        },
    }
    Diagnostics = utils.surround({ "![", "]" }, nil, Diagnostics)

    local Git = {
        condition = conditions.is_git_repo,

        init = function(self)
            self.status_dict = vim.b.gitsigns_status_dict
            self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
                self.status_dict.changed ~= 0
        end,

        hl = { fg = "orange" },


        { -- git branch name
            provider = function(self)
                return " " .. self.status_dict.head
            end,
            hl = { bold = true }
        },
        -- You could handle delimiters, icons and counts similar to Diagnostics
        {
            condition = function(self)
                return self.has_changes
            end,
            provider = "("
        },
        {
            provider = function(self)
                local count = self.status_dict.added or 0
                return count > 0 and ("+" .. count)
            end,
            hl = { fg = "git_add" },
        },
        {
            provider = function(self)
                local count = self.status_dict.removed or 0
                return count > 0 and ("-" .. count)
            end,
            hl = { fg = "git_del" },
        },
        {
            provider = function(self)
                local count = self.status_dict.changed or 0
                return count > 0 and ("~" .. count)
            end,
            hl = { fg = "git_change" },
        },
        {
            condition = function(self)
                return self.has_changes
            end,
            provider = ")",
        },
    }

    -- local DefaultStatusline = {
    -- ViMode, Space, FileName, Space, Git, Space, Diagnostics, Align,
    -- Navic, DAPMessages, Align,
    -- LSPActive, Space, LSPMessages, Space, UltTest, Space, FileType, Space, Ruler, Space, ScrollBar
    -- }
    local statusline = {
        ViMode, Align, Git, Align, Diagnostics, Align, Navic, Align
    }
    vim.api.nvim_create_autocmd("User", {
        pattern = 'HeirlineInitWinbar',
        callback = function(args)
            local buf = args.buf
            local buftype = vim.tbl_contains(
                { "prompt", "nofile", "help", "quickfix" },
                vim.bo[buf].buftype
            )
            local filetype = vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[buf].filetype)
            if buftype or filetype then
                vim.opt_local.winbar = nil
            end
        end,
    })

    local winbar = {
        Navic
    }

    local TabLineOffset = {
        condition = function(self)
            local win = vim.api.nvim_tabpage_list_wins(0)[1]
            local bufnr = vim.api.nvim_win_get_buf(win)
            self.winid = win

            if vim.bo[bufnr].filetype == "NvimTree" then
                self.title = "NvimTree"
                return true
                -- elseif vim.bo[bufnr].filetype == "TagBar" then
                --     ...
            end
        end,

        provider = function(self)
            local title = self.title
            local width = vim.api.nvim_win_get_width(self.winid)
            local pad = math.ceil((width - #title) / 2)
            return string.rep(" ", pad) .. title .. string.rep(" ", pad)
        end,

        hl = function(self)
            if vim.api.nvim_get_current_win() == self.winid then
                return "TablineSel"
            else
                return "Tabline"
            end
        end,
    }
    local TablineBufnr = {
        provider = function(self)
            return tostring(self.bufnr) .. ". "
        end,
        hl = "Comment",
    }

    -- we redefine the filename component, as we probably only want the tail and not the relative path
    local TablineFileName = {
        provider = function(self)
            -- self.filename will be defined later, just keep looking at the example!
            local filename = self.filename
            filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
            return filename
        end,
        hl = function(self)
            return { bold = self.is_active or self.is_visible, italic = true }
        end,
    }

    -- this looks exactly like the FileFlags component that we saw in
    -- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
    -- also, we are adding a nice icon for terminal buffers.
    local TablineFileFlags = {
        {
            condition = function(self)
                return vim.api.nvim_buf_get_option(self.bufnr, "modified")
            end,
            provider = "[+]",
            hl = { fg = "green" },
        },
        {
            condition = function(self)
                return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
                    or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
            end,
            provider = function(self)
                if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
                    return "  "
                else
                    return ""
                end
            end,
            hl = { fg = "orange" },
        },
    }

    -- Here the filename block finally comes together
    local TablineFileNameBlock = {
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        end,
        hl = function(self)
            if self.is_active then
                return "TabLineSel"
                -- why not?
                -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
                --     return { fg = "gray" }
            else
                return "TabLine"
            end
        end,
        on_click = {
            callback = function(_, minwid, _, button)
                if (button == "m") then -- close on mouse middle click
                    vim.api.nvim_buf_delete(minwid, { force = false })
                else
                    vim.api.nvim_win_set_buf(0, minwid)
                end
            end,
            minwid = function(self)
                return self.bufnr
            end,
            name = "heirline_tabline_buffer_callback",
        },
        TablineBufnr,
        FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
        TablineFileName,
        TablineFileFlags,
    }

    -- a nice "x" button to close the buffer
    local TablineCloseButton = {
        condition = function(self)
            return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
        end,
        { provider = " " },
        {
            provider = "",
            hl = { fg = "gray" },
            on_click = {
                callback = function(_, minwid)
                    vim.api.nvim_buf_delete(minwid, { force = false })
                end,
                minwid = function(self)
                    return self.bufnr
                end,
                name = "heirline_tabline_close_buffer_callback",
            },
        },
    }

    -- The final touch!
    local TablineBufferBlock = utils.surround({ "", "" }, function(self)
        if self.is_active then
            return utils.get_highlight("TabLineSel").bg
        else
            return utils.get_highlight("TabLine").bg
        end
    end, { TablineFileNameBlock, TablineCloseButton })

    -- and here we go
    local BufferLine = utils.make_buflist(
        TablineBufferBlock,
        { provider = "", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
        { provider = "", hl = { fg = "gray" } }-- right trunctation, also optional (defaults to ...... yep, ">")
    -- by the way, open a lot of buffers and try clicking them ;)
    )

    local Tabpage = {
        provider = function(self)
            return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
        end,
        hl = function(self)
            if not self.is_active then
                return "TabLine"
            else
                return "TabLineSel"
            end
        end,
    }

    local TabpageClose = {
        provider = "%999X  %X",
        hl = "TabLine",
    }

    local TabPages = {
        -- only show this component if there's 2 or more tabpages
        condition = function()
            return #vim.api.nvim_list_tabpages() >= 2
        end,
        { provider = "%=" },
        utils.make_tablist(Tabpage),
        TabpageClose,
    }

    local tabline = { TabLineOffset, BufferLine, TabPages }
    -- local statuscolumn = {}

    require("heirline").setup({
        statusline = statusline,
        -- winbar = winbar,
        tabline = tabline,
        -- statuscolumn = statuscolumn,
    })



    -- Yep, with heirline we're driving manual!
    vim.o.showtabline = 2
    vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
end


return {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    dependencies = {
        "SmiteshP/nvim-navic",
        "rebelot/kanagawa.nvim",
    },

    config = config
}