local window = {}

window.setup = function(plugins)
    table.insert(plugins, {
        'anuvyklack/windows.nvim',
        requires = { 'anuvyklack/middleclass', 'anuvyklack/animation.nvim' },
        config = function()
            vim.o.winwidth = 10
            vim.o.winminwidth = 10
            vim.o.equalalways = false
            require('windows').setup()

            local function cmd(command)
                return table.concat({ '<Cmd>', command, '<CR>' })
            end

            vim.keymap.set('n', '<C-w>z', cmd 'WindowsMaximize')
            vim.keymap.set('n', '<C-w>_', cmd 'WindowsMaximizeVertically')
            vim.keymap.set('n', '<C-w>|', cmd 'WindowsMaximizeHorizontally')
            vim.keymap.set('n', '<C-w>=', cmd 'WindowsEqualize')
        end,
        lazy = true,
        event = "BufWinEnter",
    })

    table.insert(plugins, {
        'anuvyklack/middleclass',
        lazy = true,
        -- event = "BufWinEnter",
    })
    table.insert(plugins, {
        'anuvyklack/animation.nvim',
        lazy = true,
        -- event = "BufWinEnter",
    })


    return plugins
end

return window
