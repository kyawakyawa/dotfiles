local M = {}

local function should_hide(props)
  local cursor = vim.api.nvim_win_get_cursor(props.win)
  local line_count = vim.api.nvim_buf_line_count(props.buf)
  local buftype = vim.bo[props.buf].buftype
  local filetype = vim.bo[props.buf].filetype

  if buftype ~= "" then
    return false
  end

  if
    cursor[1] == 1
    and line_count <= 3
    and (filetype == "sh" or filetype == "zsh" or filetype == "bash")
  then
    return true
  end

  return false
end

function M.setup()
  local devicons = require("nvim-web-devicons")

  require("incline").setup({
    render = function(props)
      if should_hide(props) then
        return {}
      end

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

      local modified = vim.bo[props.buf].modified

      return {
        { get_diagnostic_label() },
        { get_git_diff() },
        { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
        { filename .. " ", gui = modified and "bold,italic" or "bold" },
        { modified and { " ", guifg = "#ff0000", gui = "bold" } or "" },
      }
    end,
  })
end

return M
