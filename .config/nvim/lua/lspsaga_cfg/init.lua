local keymap = vim.keymap.set
local saga = require('lspsaga')
 
-- v0.8以上
use_win_bar = (vim.version()['major'] > 0 or vim.version()['minor'] >= 8)

if use_win_bar then
saga.init_lsp_saga({
    symbol_in_winbar = {
        in_custom = true,
        click_support = function(node, clicks, button, modifiers)
            -- To see all avaiable details: vim.pretty_print(node)
            local st = node.range.start
            local en = node.range['end']
            if button == "l" then
                if clicks == 2 then
                    -- double left click to do nothing
                else -- jump to node's starting line+char
                    vim.fn.cursor(st.line + 1, st.character + 1)
                end
            elseif button == "r" then
                if modifiers == "s" then
                    print "lspsaga" -- shift right click to print "lspsaga"
                end -- jump to node's ending line+char
                vim.fn.cursor(en.line + 1, en.character + 1)
            elseif button == "m" then
                -- middle click to visual select node
                vim.fn.cursor(st.line + 1, st.character + 1)
                vim.cmd "normal v"
                vim.fn.cursor(en.line + 1, en.character + 1)
            end
        end
    }
})
else
saga.init_lsp_saga()
end

-- Settings

local opts = { noremap=true, silent=true }

-- Rename
keymap("n", "<space>rn", "<cmd>Lspsaga rename<CR>", opts)

-- Hover Doc
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)

-- Finder
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)


-- Show line diagnostics
keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)

-- Show cursor diagnostic
keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
 
-- TODO(kyawakyawa)
-- -- Lsp finder find the symbol definition implmement reference
-- -- when you use action in finder like open vsplit then your can
-- -- use <C-t> to jump back
-- keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
-- 
-- -- Code action
-- keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
-- keymap("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", { silent = true })
-- 
-- -- Rename
-- keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })
-- 
-- -- Definition preview
-- keymap("n", "gd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })
-- 
-- -- Show line diagnostics
-- keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
-- 
-- -- Show cursor diagnostic
-- keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })
-- 
-- -- Diagnsotic jump
-- keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
-- keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
-- 
-- -- Only jump to error
-- keymap("n", "[E", function()
--   require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true })
-- keymap("n", "]E", function()
--   require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true })
-- 
-- -- Outline
-- keymap("n","<leader>o", "<cmd>LSoutlineToggle<CR>",{ silent = true })
-- 
-- -- Hover Doc
-- keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
-- 
-- -- Signature help
-- keymap("n", "gs", "<Cmd>Lspsaga signature_help<CR>", { silent = true })
-- 
-- local action = require("lspsaga.action")
-- -- scroll in hover doc or  definition preview window
-- vim.keymap.set("n", "<C-f>", function()
--     action.smart_scroll_with_saga(1)
-- end, { silent = true })
-- -- scroll in hover doc or  definition preview window
-- vim.keymap.set("n", "<C-b>", function()
--     action.smart_scroll_with_saga(-1)
-- end, { silent = true })


------- Show symbols in winbar(nvim 0.8+) or in statusline -------

function get_file_name(include_path)
    local file_name = require('lspsaga.symbolwinbar').get_file_name()
    if vim.fn.bufname '%' == '' then return '' end
    if include_path == false then return file_name end
    -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
    local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''), sep)
    local file_path = ''
    for _, cur in ipairs(path_list) do
        file_path = (cur == '.' or cur == '~') and '' or
                    file_path .. cur .. ' ' .. '%#LspSagaWinbarSep#>%*' .. ' %*'
    end
    return file_path .. file_name
end
    
if use_win_bar then

    -- Example:
    -- local function get_file_name(include_path)
    --     local file_name = require('lspsaga.symbolwinbar').get_file_name()
    --     if vim.fn.bufname '%' == '' then return '' end
    --     if include_path == false then return file_name end
    --     -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
    --     local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    --     local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''), sep)
    --     local file_path = ''
    --     for _, cur in ipairs(path_list) do
    --         file_path = (cur == '.' or cur == '~') and '' or
    --                     file_path .. cur .. ' ' .. '%#LspSagaWinbarSep#>%*' .. ' %*'
    --     end
    --     return file_path .. file_name
    -- end
    
    local function config_winbar_or_statusline()
        local exclude = {
            ['teminal'] = true,
            ['toggleterm'] = true,
            ['prompt'] = true,
            ['NvimTree'] = true,
            ['help'] = true,
        } -- Ignore float windows and exclude filetype
        if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
            vim.wo.winbar = ''
        else
            local ok, lspsaga = pcall(require, 'lspsaga.symbolwinbar')
            local sym
            if ok then sym = lspsaga.get_symbol_node() end
            local win_val = ''
            win_val = get_file_name(true) -- set to true to include path
            if sym ~= nil then win_val = win_val .. sym end
            vim.wo.winbar = win_val
            -- if work in statusline
            -- vim.wo.stl = win_val --statuslineに出すならここをコメントアウト
        end
    end
    
    local events = { 'BufEnter', 'BufWinEnter', 'CursorMoved' }
    
    vim.api.nvim_create_autocmd(events, {
        pattern = '*',
        callback = function() config_winbar_or_statusline() end,
    })
    
    vim.api.nvim_create_autocmd('User', {
        pattern = 'LspsagaUpdateSymbol',
        callback = function() config_winbar_or_statusline() end,
    })

-- lualineに表示したいときはこちらをコメントアウト
-- function symbol_string()
--     local exclude = {
--         ['teminal'] = true,
--         ['toggleterm'] = true,
--         ['prompt'] = true,
--         ['NvimTree'] = true,
--         ['help'] = true,
--     } -- Ignore float windows and exclude filetype
--     if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
--         return ''
--     else
--         local ok, lspsaga = pcall(require, 'lspsaga.symbolwinbar')
--         local sym
--         if ok then sym = lspsaga.get_symbol_node() end
--         local win_val = ''
--         win_val = get_file_name(true) -- set to true to include path
--         if sym ~= nil then win_val = win_val .. sym end
--         return win_val
--     end
-- end

end
