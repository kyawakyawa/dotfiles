local treesitter = {}
local util = require("util")

local ensure_installed = {
  "c",
  "cpp",
  "cmake",
  "make",
  "cuda",
  "glsl",
  "rust",
  "python",
  "latex",
  "lua",
  "html",
  "css",
  "javascript",
  "typescript",
  "json",
  "jsonc",
  "json5",
  "tsx",
  "toml",
  "yaml",
  "vim",
  "bash",
  "regex",
  "markdown",
  "markdown_inline",
}

local start_filetypes = {
  "c",
  "cpp",
  "cmake",
  "make",
  "cuda",
  "glsl",
  "rust",
  "python",
  "latex",
  "lua",
  "html",
  "css",
  "javascript",
  "typescript",
  "json",
  "jsonc",
  "json5",
  "typescriptreact",
  "toml",
  "yaml",
  "vim",
  "bash",
  "regex",
  "markdown",
}

local function setup_treesitter_textobjects()
  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
      selection_modes = {
        ["@parameter.outer"] = "v",
        ["@function.outer"] = "V",
        ["@class.outer"] = "<c-v>",
      },
      include_surrounding_whitespace = true,
    },
    move = {
      set_jumps = true,
    },
  })

  vim.keymap.set({ "x", "o" }, "af", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "if", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ac", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ic", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "as", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
  end)

  vim.keymap.set({ "n", "x", "o" }, "]f", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]F", function()
    require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[f", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[F", function()
    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]c", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]C", function()
    require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[c", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[C", function()
    require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
  end)
end

treesitter.setup = function(plugins)
  -- nvim-treesitter
  util.add_plugin(plugins, {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      vim.api.nvim_create_user_command("MyTSInstall", function()
        require("nvim-treesitter").install(ensure_installed):wait(300000)
      end, {})

      vim.api.nvim_create_autocmd("FileType", {
        pattern = start_filetypes,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
    lazy = false,
  }, {
    vscode = true,
  })

  -- nvim-treesitter-context
  util.add_plugin(plugins, {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 5,
        min_window_height = 3,
      })
    end,
    lazy = true,
    event = "BufReadPost",
  }, {
    vscode = false,
  })

  -- nvim-treesitter/nvim-treesitter-textobjects
  util.add_plugin(plugins, {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = setup_treesitter_textobjects,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = true,
    event = "BufReadPost",
  }, {
    vscode = true,
  })

  return plugins
end

return treesitter
