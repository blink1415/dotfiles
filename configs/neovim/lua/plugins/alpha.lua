return {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()

        local leader = "SPC"
        local if_nil = vim.F.if_nil
        local function button(sc, txt, keybind, keybind_opts)
            local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

            local opts = {
                position = "center",
                shortcut = sc,
                cursor = 5,
                width = 50,
                align_shortcut = "right",
                hl_shortcut = "Keyword",
            }
            if keybind then
                keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
                opts.keymap = { "n", sc_, keybind, keybind_opts }
            end

            local function on_press()
                local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
                vim.api.nvim_feedkeys(key, "t", false)
            end

            return {
                type = "button",
                val = txt,
                on_press = on_press,
                opts = opts,
            }
        end

        local section = {
            header = {
                type = "text",
                val = {
                    "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
                    "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
                    "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
                    "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
                    "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
                    "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
                    "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
                    " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
                    " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
                    "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
                    "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
                },
                opts = {
                    position = "center",
                    hl = "AlphaHeader",
                },
            },
            terminal = {
                type = "terminal",
                command = nil,
                width = 69,
                height = 8,
                opts = {
                    redraw = true,
                    window_config = {},
                },
            },
            buttons = {
                type = "group",
                val = {
                    button("Space p", "  Open projects"),
                    button("Space o", "✓ Start neorg"),
                },
                opts = {
                    spacing = 1,
                },
            },
            footer = {
                type = "text",
                val = "",
                opts = {
                    position = "center",
                    hl = "Number",
                },
            },
        }

        require 'alpha'.setup({
                layout = {
                    { type = "padding", val = 2 },
                    section.header,
                    { type = "padding", val = 2 },
                    section.buttons,
                    section.footer,
                },
                opts = {
                    margin = 5,
                },
        })
    end
}
