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
