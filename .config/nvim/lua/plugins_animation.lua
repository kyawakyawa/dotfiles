local animation = {}

animation.setup = function(plugins)
    -- table.insert(plugins, {
    --     'echasnovski/mini.animate',
    --      version = '*',
    --      config = function()
    --         require('mini.animate').setup()
    --      end,
    --      lazy = true,
	  --    event = "BufReadPost", 
    -- })

    table.insert(plugins, {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup({
          easing_function = "quadratic" -- Default easing function
          -- Set any other options as needed
        })
        
        local t = {}
        -- Syntax: t[keys] = {function, {function arguments}}
        -- Use the "sine" easing function
        t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '10', [['sine']]}}
        t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '10', [['sine']]}}
        -- Use the "circular" easing function
        t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '15', [['circular']]}}
        t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '15', [['circular']]}}
        -- Pass "nil" to disable the easing animation (constant scrolling speed)
        t['<C-y>'] = {'scroll', {'-0.10', 'false', '10', nil}}
        t['<C-e>'] = {'scroll', { '0.10', 'false', '10', nil}}
        -- When no easing function is provided the default easing function (in this case "quadratic") will be used
        t['zt']    = {'zt', {'10'}}
        t['zz']    = {'zz', {'10'}}
        t['zb']    = {'zb', {'10'}}
        
        require('neoscroll.config').set_mappings(t)
      end,
      lazy = true,
      keys = {
        '<C-u>',
        '<C-d>',
        '<C-b>',
        '<C-f>',
        '<C-y>',
        '<C-e>',
        '<zt>',
        '<zz>',
        '<zb>',
      },
    })

    table.insert(plugins, {
      -- 'edluffy/specs.nvim',
      'cxwx/specs.nvim',
      config = function()
        require('specs').setup{ 
            show_jumps  = true,
            min_jump = 30,
            popup = {
                delay_ms = 0, -- delay before popup displays
                inc_ms = 5, -- time increments used for fade/resize effects 
                blend = 0, -- starting blend, between 0-100 (fully transparent), see :h winblend
                width = 24,
                winhl = "Pmenu",
                -- fader = require('specs').linear_fader,
                fader = require('specs').pulse_fader,
                resizer = require('specs').shrink_resizer
            },
            ignore_filetypes = {},
            ignore_buftypes = {
                nofile = true,
            },
        }

        vim.api.nvim_set_keymap('n', ';', ';:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', ',', ',:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })

        vim.api.nvim_set_keymap('n', 'w', 'w:lua require("specs").show_specs( { width=24, winhl = "Search", inc_ms=2} )<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'b', 'b:lua require("specs").show_specs( { width=24, winhl = "Search", inc_ms=2} )<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'e', 'e:lua require("specs").show_specs( { width=24, winhl = "Search", inc_ms=2} )<CR>', { noremap = true, silent = true })
        
        vim.api.nvim_set_keymap('n', 'L', 'L:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'M', 'M:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'H', 'H:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })

        -- You can even bind it to search jumping and more, example:
        vim.api.nvim_set_keymap('n', 'n', 'n:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'N', 'N:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '*', '*:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
        
        -- Or maybe you do a lot of screen-casts and want to call attention to a specific line of code:
        vim.api.nvim_set_keymap('n', '<leader>v', ':lua require("specs").show_specs({width = 97, winhl = "Search", delay_ms = 610, inc_ms = 21})<CR>', { noremap = true, silent = true })

        vim.api.nvim_set_keymap('n', 'gg', 'gg:lua require("specs").show_specs( {width = 50, winhl = "Search", delay_ms = 0, inc_ms = 10} )<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<S-G>', '<S-G>:lua require("specs").show_specs( {width = 50, winhl = "Search", delay_ms = 0, inc_ms = 10} )<CR>', { noremap = true, silent = true })

        settings = { width=24, winhl = "Search", inc_ms=20 }
        vim.api.nvim_set_keymap('n', '<C-w><C-w>', '<C-w><C-w>:lua require("specs").show_specs(settings)<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-w><C-j>', '<C-w><C-j>:lua require("specs").show_specs(settings)<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-w><C-k>', '<C-w><C-k>:lua require("specs").show_specs(settings)<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-w><C-h>', '<C-w><C-h>:lua require("specs").show_specs(settings)<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-w><C-l>', '<C-w><C-l>:lua require("specs").show_specs(settings)<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-w>j', '<C-w>j:lua require("specs").show_specs(settings)<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-w>k', '<C-w>k:lua require("specs").show_specs(settings)<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-w>h', '<C-w>h:lua require("specs").show_specs(settings)<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-w>l', '<C-w>l:lua require("specs").show_specs(settings)<CR>', { noremap = true, silent = true })
      end,
      lazy = true,
      event = "BufReadPost", 
    })

    return plugins
end

return animation
