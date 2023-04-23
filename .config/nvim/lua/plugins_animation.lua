local animation = {}

animation.setup = function(plugins)
    table.insert(plugins, {
        'echasnovski/mini.animate',
         version = '*',
         config = function()
            require('mini.animate').setup()
         end,
         lazy = true,
	     event = "BufReadPost", 
    })

    return plugins
end

return animation