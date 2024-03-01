local Popup = require("plenary.popup")

QuickRunner_win_id = nil
QuickRunner_buf_id = nil

local function create_menu()
    local height = 20
    local width = 30
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local cb = nil

    QuickRunner_buf_id = vim.api.nvim_create_buf(false, false)

    local QuickRunner_win_id = Popup.create(QuickRunner_buf_id, {
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

local function toggle_menu()
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

vim.api.nvim_create_user_command('QuickRunnerToggleMenu', function()
    toggle_menu()
end, {})
