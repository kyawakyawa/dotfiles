local config = require("config")

local M = {}

local uv = vim.uv or vim.loop

local function executable_path(cmd)
  local path = vim.fn.exepath(cmd)
  if path == "" then
    return nil
  end
  return path
end

local function file_exists(path)
  return path ~= nil and uv.fs_stat(path) ~= nil
end

local function dirname(path)
  return vim.fs.dirname(path)
end

local function basename(path)
  return vim.fs.basename(path)
end

local function parent(path)
  return dirname(path)
end

local function path_join(parts)
  local path_sep = package.config:sub(1, 1) == "\\" and ";" or ":"
  return table.concat(
    vim.tbl_filter(function(part)
      return part ~= nil and part ~= ""
    end, parts),
    path_sep
  )
end

local function run(args, opts)
  opts = opts or {}
  if vim.fn.executable(args[1]) ~= 1 then
    return nil
  end
  local result = vim.system(args, { text = true, cwd = opts.cwd }):wait(opts.timeout or 2000)
  if result.code ~= 0 then
    return nil
  end
  local out = vim.trim(result.stdout or "")
  if out == "" then
    return nil
  end
  return out
end

local function python_site_paths(python)
  local output = run({
    python,
    "-c",
    table.concat({
      "import json, site, sysconfig",
      "paths = []",
      "for p in site.getsitepackages():",
      "    paths.append(p)",
      "for key in ('purelib', 'platlib'):",
      "    p = sysconfig.get_paths().get(key)",
      "    if p:",
      "        paths.append(p)",
      "print(json.dumps(list(dict.fromkeys(paths))))",
    }, "\n"),
  })

  if not output then
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, output)
  if not ok or type(decoded) ~= "table" then
    return {}
  end

  return vim.tbl_filter(function(path)
    return file_exists(path)
  end, decoded)
end

local function find_root(start_path, markers)
  local start = uv.fs_realpath(start_path or uv.cwd()) or start_path or uv.cwd()
  local found = vim.fs.find(markers, { upward = true, path = start })[1]
  if found then
    return vim.fs.dirname(found)
  end
  return start
end

local resolvers = {}

function resolvers.manual(root, cfg)
  if not cfg.python_path then
    return nil
  end
  return {
    kind = "manual",
    root = root,
    python = cfg.python_path,
    venv_path = cfg.venv_path,
    run_prefix = cfg.run_prefix or {},
    env = {},
    source = "manual",
  }
end

function resolvers.uv(root)
  local venv_python = root .. "/.venv/bin/python"
  if file_exists(venv_python) then
    return {
      kind = "uv",
      root = root,
      python = venv_python,
      venv_path = root .. "/.venv",
      run_prefix = { "uv", "run" },
      env = {},
      source = ".venv",
    }
  end

  local python = run({ "uv", "python", "find" }, { cwd = root })
  if python and file_exists(python) then
    return {
      kind = "uv",
      root = root,
      python = python,
      venv_path = nil,
      run_prefix = { "uv", "run" },
      env = {},
      source = "uv python find",
    }
  end
end

function resolvers.activated(root)
  local virtual_env = vim.env.VIRTUAL_ENV
  if virtual_env and file_exists(virtual_env .. "/bin/python") then
    return {
      kind = "activated",
      root = root,
      python = virtual_env .. "/bin/python",
      venv_path = virtual_env,
      run_prefix = {},
      env = {},
      source = "VIRTUAL_ENV",
    }
  end

  local conda_prefix = vim.env.CONDA_PREFIX
  if conda_prefix and file_exists(conda_prefix .. "/bin/python") then
    return {
      kind = "activated",
      root = root,
      python = conda_prefix .. "/bin/python",
      venv_path = conda_prefix,
      run_prefix = {},
      env = {},
      source = "CONDA_PREFIX",
    }
  end

  local python = executable_path("python") or executable_path("python3")
  if python then
    return {
      kind = "activated",
      root = root,
      python = python,
      venv_path = nil,
      run_prefix = {},
      env = {},
      source = "PATH",
    }
  end
end

function resolvers.system(root)
  local python = executable_path("python3") or executable_path("python")
  if python then
    return {
      kind = "system",
      root = root,
      python = python,
      venv_path = nil,
      run_prefix = {},
      env = {},
      source = "system",
    }
  end
end

function M.resolve(start_path)
  local cfg = config.get("languages.python", {})
  local markers = cfg.project_root_markers or { "uv.lock", "pyproject.toml", ".venv", ".git" }
  local root = find_root(start_path, markers)

  local resolver_name = cfg.resolver or "uv"
  local resolver = resolvers[resolver_name]
  local resolved = resolver and resolver(root, cfg) or nil

  if not resolved and cfg.fallback_resolver then
    local fallback = resolvers[cfg.fallback_resolver]
    resolved = fallback and fallback(root, cfg) or nil
    if resolved then
      resolved.fallback_used = true
    end
  end

  return resolved
end

function M.pyright_settings(start_path)
  local resolved = M.resolve(start_path)
  if not resolved or not resolved.python then
    return nil, resolved
  end

  local settings = {
    python = {
      pythonPath = resolved.python,
    },
  }

  if resolved.venv_path then
    settings.python.venvPath = parent(resolved.venv_path)
    settings.python.venv = basename(resolved.venv_path)
  end

  local site_paths = python_site_paths(resolved.python)
  if not vim.tbl_isempty(site_paths) then
    settings.python.analysis = settings.python.analysis or {}
    settings.python.analysis.extraPaths = site_paths
  end

  return settings, resolved
end

function M.pyright_cmd_env(start_path)
  local resolved = M.resolve(start_path)
  if not resolved or not resolved.venv_path then
    return nil, resolved
  end

  return {
    VIRTUAL_ENV = resolved.venv_path,
    PATH = path_join({ resolved.venv_path .. "/bin", vim.env.PATH }),
  },
    resolved
end

function M.print_info(start_path)
  local resolved = M.resolve(start_path or uv.cwd())
  if not resolved then
    print("python resolver: not found")
    return
  end

  print("python resolver: " .. tostring(resolved.kind))
  print("python source: " .. tostring(resolved.source))
  print("python root: " .. tostring(resolved.root))
  print("python path: " .. tostring(resolved.python))
  print("python venv: " .. tostring(resolved.venv_path or "none"))
  print("python fallback_used: " .. tostring(resolved.fallback_used == true))

  local site_paths = python_site_paths(resolved.python)
  if not vim.tbl_isempty(site_paths) then
    print("python site-packages:")
    for _, path in ipairs(site_paths) do
      print("  " .. path)
    end
  end
end

return M
