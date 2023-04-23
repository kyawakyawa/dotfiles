local greeter = {}

greeter.setup = function(plugins)
    table.insert(plugins, {
        'goolord/alpha-nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            -- require'alpha'.setup(require'alpha.themes.startify'.config)
            require'alpha'.setup(require'alpha.themes.dashboard'.config)
        end,
        lazy = true,
        event = "BufWinEnter",
    })

    return plugins
end

return greeter