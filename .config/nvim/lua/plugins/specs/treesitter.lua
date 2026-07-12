local config = require("config")

local M = {}

local function path_join(parts)
  local path_sep = package.config:sub(1, 1) == "\\" and ";" or ":"
  return table.concat(
    vim.tbl_filter(function(part)
      return part ~= nil and part ~= ""
    end, parts),
    path_sep
  )
end

local function ensure_tree_sitter_cli_path()
  if vim.fn.executable("tree-sitter") == 1 then
    return
  end

  local cargo_bin = vim.fn.expand("~/.cargo/bin")
  local tree_sitter = cargo_bin .. "/tree-sitter"
  if vim.uv.fs_stat(tree_sitter) then
    vim.env.PATH = path_join({ cargo_bin, vim.env.PATH })
  end
end

local function git_supports_no_advice()
  local result = vim.system({ "git", "--no-advice", "version" }, { text = true }):wait()
  return result.code == 0
end

local function patch_tree_sitter_manager_git_args()
  local ok, util = pcall(require, "tree-sitter-manager.util")
  if not ok or util.__dotfiles_git_args_patch then
    return
  end

  local no_advice_supported = git_supports_no_advice()

  local function normalize_git_args(args)
    if type(args) ~= "table" or args[1] ~= "git" then
      return args
    end

    local normalized = { "git" }
    local work_tree

    for index, arg in ipairs(args) do
      local skip = index == 1 and arg == "git"

      if type(arg) == "string" and arg:sub(1, 12) == "--work-tree=" then
        work_tree = arg:sub(13)
        skip = true
      elseif arg == "--no-advice" and not no_advice_supported then
        skip = true
      end

      if not skip then
        table.insert(normalized, arg)
      end
    end

    local command = normalized[2]
    if work_tree and command and command ~= "clone" and command ~= "init" then
      table.insert(normalized, 2, work_tree)
      table.insert(normalized, 2, "-C")
    end

    return normalized
  end

  local run = util.run
  util.run = function(args, ...)
    return run(normalize_git_args(args), ...)
  end

  local run_async = util.run_async
  util.run_async = function(args, ...)
    return run_async(normalize_git_args(args), ...)
  end

  util.__dotfiles_git_args_patch = true
end

function M.setup()
  ensure_tree_sitter_cli_path()

  local parsers = config.get("languages.treesitter.parsers", {})

  local ok, manager = pcall(require, "tree-sitter-manager")
  if ok then
    patch_tree_sitter_manager_git_args()
    manager.setup({
      ensure_installed = {},
      auto_install = false,
      highlight = false,
    })
  end

  vim.api.nvim_create_user_command("TreesitterInstallConfigured", function()
    if not ok then
      vim.notify("tree-sitter-manager.nvim is not available", vim.log.levels.ERROR)
      return
    end
    if vim.tbl_isempty(parsers) then
      vim.notify("No treesitter parsers configured", vim.log.levels.INFO)
      return
    end
    vim.cmd("TSInstall " .. table.concat(parsers, " "))
  end, {})

  vim.api.nvim_create_user_command("TreesitterUpdateConfigured", function()
    if not ok then
      vim.notify("tree-sitter-manager.nvim is not available", vim.log.levels.ERROR)
      return
    end
    if vim.tbl_isempty(parsers) then
      vim.notify("No treesitter parsers configured", vim.log.levels.INFO)
      return
    end
    vim.cmd("TSUpdate " .. table.concat(parsers, " "))
  end, {})

  vim.api.nvim_create_user_command("TreesitterBufferInfo", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    local lang = vim.treesitter.language.get_lang(filetype) or filetype
    local active = vim.treesitter.highlighter.active[bufnr] ~= nil

    print("filetype: " .. tostring(filetype))
    print("language: " .. tostring(lang))
    print("active highlighter: " .. tostring(active))
    print("tree-sitter executable: " .. tostring(vim.fn.exepath("tree-sitter")))

    local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
    print("parser: " .. tostring(parser_ok))
    if not parser_ok then
      print(tostring(parser))
      return
    end

    local parse_ok, trees = pcall(function()
      return parser:parse()
    end)
    print("parse: " .. tostring(parse_ok) .. " trees=" .. tostring(trees and #trees or 0))

    for _, query_name in ipairs({ "highlights", "locals", "injections", "textobjects" }) do
      local query_ok, query = pcall(vim.treesitter.query.get, lang, query_name)
      print("query " .. query_name .. ": " .. tostring(query_ok and query ~= nil))
    end
  end, {})
end

return M
