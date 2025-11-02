local animation = {}
local util = require("util")

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

  util.add_plugin(plugins, {
    "karb94/neoscroll.nvim",
    config = function()
      neoscroll = require("neoscroll")

      neoscroll.setup({
        mappings = { -- Keys to be mapped to their corresponding default scrolling animation
          "<C-u>",
          "<C-d>",
          "<C-b>",
          "<C-f>",
          "<C-y>",
          "<C-e>",
          "zt",
          "zz",
          "zb",
        },
      })

      local get_rows = function()
        local buf = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(buf)
        local ui_info = vim.api.nvim_list_uis()[1]

        -- 行数（高さ）を取得
        local height = ui_info.height

        -- vim.notify("現在のVim画面の行数: " .. height)
        return height
      end

      local ctrl_udbf = function(callback, key, param)
        rows = get_rows()

        -- 行数が小さき時だけ
        if rows <= 90 then
          -- duration = math.floor(param / get_rows() * 30)
          -- vim.notify("duration: " .. duration)
          callback({ duration = param })
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
        end
      end

      local limit_by_rows = function(callback, key)
        local rows = get_rows()
        -- vim.notify("rows: " .. tostring(rows))

        -- 行数が小さき時だけ
        if rows <= 75 then
          callback()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
        end
      end

      local keymap = {
        ["<C-u>"] = function()
          limit_by_rows(function()
            neoscroll.ctrl_u({ duration = 48 })
          end, "<C-u>")
        end,
        ["<C-d>"] = function()
          limit_by_rows(function()
            neoscroll.ctrl_d({ duration = 48 })
          end, "<C-d>")
        end,
        ["<C-b>"] = function()
          limit_by_rows(function()
            neoscroll.ctrl_b({ duration = 48 })
          end, "<C-b>")
        end,
        ["<C-f>"] = function()
          limit_by_rows(function()
            neoscroll.ctrl_f({ duration = 48 })
          end, "<C-f>")
        end,
        ["<C-y>"] = function()
          limit_by_rows(function()
            neoscroll.scroll(-0.1, { move_cursor = false, duration = 32 })
          end, "<C-y>")
        end,
        ["<C-e>"] = function()
          limit_by_rows(function()
            neoscroll.scroll(0.1, { move_cursor = false, duration = 32 })
          end, "<C-e>")
        end,
        ["zt"] = function()
          limit_by_rows(function()
            neoscroll.zt({ half_win_duration = 48 })
          end, "zt")
        end,
        ["zz"] = function()
          limit_by_rows(function()
            neoscroll.zz({ half_win_duration = 48 })
          end, "zz")
        end,
        ["zb"] = function()
          limit_by_rows(function()
            neoscroll.zb({ half_win_duration = 48 })
          end, "zb")
        end,
      }
      local modes = { "n", "v", "x" }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end
    end,
    lazy = true,
    keys = {
      "<C-u>",
      "<C-d>",
      "<C-b>",
      "<C-f>",
      "<C-y>",
      "<C-e>",
      "<zt>",
      "<zz>",
      "<zb>",
    },
  }, {
    vscode = false,
  })

  util.add_plugin(plugins, {
    -- 'edluffy/specs.nvim',
    "cxwx/specs.nvim",
    config = function()
      require("specs").setup({
        show_jumps = true,
        min_jump = 30,
        popup = {
          delay_ms = 0, -- delay before popup displays
          inc_ms = 5,   -- time increments used for fade/resize effects
          blend = 0,    -- starting blend, between 0-100 (fully transparent), see :h winblend
          width = 24,
          winhl = "Pmenu",
          -- fader = require('specs').linear_fader,
          fader = require("specs").pulse_fader,
          resizer = require("specs").shrink_resizer,
        },
        ignore_filetypes = {},
        ignore_buftypes = {
          nofile = true,
        },
      })

      vim.api.nvim_set_keymap(
        "n",
        ";",
        ';:lua require("specs").show_specs()<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        ",",
        ',:lua require("specs").show_specs()<CR>',
        { noremap = true, silent = true }
      )

      vim.api.nvim_set_keymap(
        "n",
        "w",
        'w:lua require("specs").show_specs( { width=24, winhl = "Search", inc_ms=2} )<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "b",
        'b:lua require("specs").show_specs( { width=24, winhl = "Search", inc_ms=2} )<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "e",
        'e:lua require("specs").show_specs( { width=24, winhl = "Search", inc_ms=2} )<CR>',
        { noremap = true, silent = true }
      )

      vim.api.nvim_set_keymap(
        "n",
        "L",
        'L:lua require("specs").show_specs()<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "M",
        'M:lua require("specs").show_specs()<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "H",
        'H:lua require("specs").show_specs()<CR>',
        { noremap = true, silent = true }
      )

      -- You can even bind it to search jumping and more, example:
      vim.api.nvim_set_keymap(
        "n",
        "n",
        'n:lua require("specs").show_specs()<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "N",
        'N:lua require("specs").show_specs()<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "*",
        '*:lua require("specs").show_specs()<CR>',
        { noremap = true, silent = true }
      )

      -- Or maybe you do a lot of screen-casts and want to call attention to a specific line of code:
      vim.api.nvim_set_keymap(
        "n",
        "<leader>v",
        ':lua require("specs").show_specs({width = 97, winhl = "Search", delay_ms = 610, inc_ms = 21})<CR>',
        { noremap = true, silent = true }
      )

      vim.api.nvim_set_keymap(
        "n",
        "gg",
        'gg:lua require("specs").show_specs( {width = 50, winhl = "Search", delay_ms = 0, inc_ms = 10} )<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<S-G>",
        '<S-G>:lua require("specs").show_specs( {width = 50, winhl = "Search", delay_ms = 0, inc_ms = 10} )<CR>',
        { noremap = true, silent = true }
      )

      settings = { width = 24, winhl = "Search", inc_ms = 20 }
      vim.api.nvim_set_keymap(
        "n",
        "<C-w><C-w>",
        '<C-w><C-w>:lua require("specs").show_specs(settings)<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w><C-j>",
        '<C-w><C-j>:lua require("specs").show_specs(settings)<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w><C-k>",
        '<C-w><C-k>:lua require("specs").show_specs(settings)<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w><C-h>",
        '<C-w><C-h>:lua require("specs").show_specs(settings)<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w><C-l>",
        '<C-w><C-l>:lua require("specs").show_specs(settings)<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w>j",
        '<C-w>j:lua require("specs").show_specs(settings)<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w>k",
        '<C-w>k:lua require("specs").show_specs(settings)<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w>h",
        '<C-w>h:lua require("specs").show_specs(settings)<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<C-w>l",
        '<C-w>l:lua require("specs").show_specs(settings)<CR>',
        { noremap = true, silent = true }
      )
    end,
    lazy = true,
    event = "BufReadPost",
  }, {
    vscode = false,
  })

  return plugins
end

return animation
