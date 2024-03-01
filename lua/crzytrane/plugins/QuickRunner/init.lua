local Path = require("plenary.path")
local Popup = require("plenary.popup")
local Strings = require("plenary.strings")
local WindowBorder = require("plenary.window.border")


local config_path = vim.fn.stdpath("config")
local data_path = vim.fn.stdpath("data")
local user_config = string.format("%s/harpoon.json", config_path)
local cache_config = string.format("%s/harpoon.json", data_path)

local M = {}

-- local content string = Strings.align_str("Hello World!", 20, true)
-- local buf_id = vim.api.nvim_create_buf(false, false)
-- vim.api.nvim_buf_set_lines(buf_id, 0, 0, false, content)
-- local window = WindowBorder.new(buf)
-- local popup = Popup.create(buf, { })

-- Import the Plenary library
local popup = require("plenary.popup")

QuickRunner_win_id = nil
QuickRunner_buf_id = nil

local function create_menu()
    local height = 20
    local width = 30
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local cb = nil

    QuickRunner_buf_id = vim.api.nvim_create_buf(false, false)

    local QuickRunner_win_id = popup.create(QuickRunner_buf_id, {
        title = "MyProjects",
        highlight = "MyProjectWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = cb,
    })

    return {
        win_id = QuickRunner_win_id,
        buf_id = QuickRunner_buf_id,
    }
end

local function close_menu()
    vim.api.nvim_win_close(QuickRunner_win_id, true)
    QuickRunner_win_id = nil
    QuickRunner_buf_id = nil
end

-- Define a function to show a custom menu window
function M.toggle_menu()
    if QuickRunner_win_id ~= nil and vim.api.nvim_win_is_valid(QuickRunner_win_id) then
        close_menu()
        return
    end

    local menu = create_menu()

    vim.api.nvim_buf_set_keymap(
        menu.buf_id,
        "n",
        "q",
        "<Cmd>lua require('custom.plugins.helloworld').toggle_menu()<CR>",
        { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        menu.buf_id,
        "n",
        "<ESC>",
        "<Cmd>lua require('custom.plugins.helloworld').toggle_menu()<CR>",
        { silent = true }
    )
    vim.cmd(
        string.format(
            "autocmd BufModifiedSet <buffer=%s> set nomodified",
            menu.buf_id
        )
    )

    -- Create the popup window
    -- Set a keymap to close the menu when 'q' is pressed
    vim.api.nvim_win_set_option(menu.win_id, "number", true)
    vim.api.nvim_buf_set_option(menu.buf_id, "bufhidden", "delete")
    vim.api.nvim_buf_set_option(menu.buf_id, "buftype", "acwrite")
    vim.cmd(
        "autocmd BufLeave <buffer> ++nested ++once silent lua require('custom.plugins.helloworld').toggle_menu()"
    )
end

function M.setup(config)
    print("Setup run!")
end

return {
    config = function()
        -- Switch for controlling whether you want autoformatting.
        --  Use :KickstartFormatToggle to toggle autoformatting on or off
        local show_menu = true
        vim.api.nvim_create_user_command('QuickRunnerToggleMenu', function()
            show_menu = not show_menu
            print('Setting show_menu to: ' .. tostring(show_menu))
        end, {})
    end
}
-- todo change this
--return {
--config = function()
--    print("Hello world plugin!")
--end
--}
-- return M
