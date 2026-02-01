local line = {}
local util = require("util")

local setup_incline = function()
  local devicons = require("nvim-web-devicons")
  require("incline").setup({
    render = function(props)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      if filename == "" then
        filename = "[No Name]"
      end
      local ft_icon, ft_color = devicons.get_icon_color(filename)

      local function get_git_diff()
        local icons = { removed = "", changed = "", added = "" }
        local signs = vim.b[props.buf].gitsigns_status_dict
        local labels = {}
        if signs == nil then
          return labels
        end
        for name, icon in pairs(icons) do
          if tonumber(signs[name]) and signs[name] > 0 then
            table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
          end
        end
        if #labels > 0 then
          table.insert(labels, { "┊ " })
        end
        return labels
      end

      local function get_diagnostic_label()
        local icons = { error = "", warn = "", info = "", hint = "" }
        local label = {}

        for severity, icon in pairs(icons) do
          local n = #vim.diagnostic.get(
            props.buf,
            { severity = vim.diagnostic.severity[string.upper(severity)] }
          )
          if n > 0 then
            table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
          end
        end
        if #label > 0 then
          table.insert(label, { "┊ " })
        end
        return label
      end

      -- modified check
      local modified = vim.bo[props.buf].modified

      return {
        { get_diagnostic_label() },
        { get_git_diff() },
        { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
        { filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
        -- { '┊  ' .. vim.api.nvim_win_get_number(props.win), group = 'DevIconWindows' },
        { modified and { " ", guifg = "#ff0000", gui = "bold" } or "" },
      }
    end,
  })
end

line.setup = function(plugins)
  -- incline.nvim
  util.add_plugin(plugins, {
    "b0o/incline.nvim",
    config = function()
      setup_incline()
    end,
    -- Optional: Lazy load Incline
    event = "VeryLazy",
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
  })

  -- -- lualine.nvim
  -- util.add_plugin(plugins, {
  --   "nvim-lualine/lualine.nvim",
  --   lazy = true,
  --   event = "VeryLazy",
  --   config = function()
  --     require("lualine_cfg")
  --   end,
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  -- }, {
  --   vscode = false,
  -- })

  -- -- barbar.nvim
  -- util.add_plugin(plugins, {
  --   "romgrk/barbar.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "lewis6991/gitsigns.nvim",     -- OPTIONAL: for git status
  --     "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
  --   },
  --   init = function()
  --     vim.g.barbar_auto_setup = false
  --   end,
  --   opts = {
  --     -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
  --     -- animation = true,
  --     -- insert_at_start = true,
  --     -- …etc.
  --   },
  --   version = "^1.0.0", -- optional: only update when a new 1.x version is released
  -- }, {
  --   vscode = false,
  -- })

  -- -- sidebar.nvim
  -- table.insert(plugins, {
  --   'sidebar-nvim/sidebar.nvim',
  --   config = function()
  --     local sidebar = require("sidebar-nvim")
  --     sidebar.setup({
  --       sections = {
  --         "datetime",
  --         "git",
  --         "diagnostics",
  --         require("dap-sidebar-nvim.breakpoints")
  --       },
  --       dap = {
  --           breakpoints = {
  --               icon = "🔍"
  --           }
  --       }
  --     })

  --     local bufopts = { noremap=true }
  --     vim.keymap.set('n', '<space>s', require("sidebar-nvim").toggle, bufopts)
  --   end,
  -- })

  -- -- sections-dap
  -- table.insert(plugins, {
  --   'sidebar-nvim/sections-dap',
  -- })

  return plugins
end

return line
