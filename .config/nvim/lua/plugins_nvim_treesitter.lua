local treesitter = {}

treesitter.setup = function(plugins)

    -- nvim-treesitter
    table.insert(plugins, {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require'nvim-treesitter.configs'.setup {
          -- A list of parser names, or "all"
          ensure_installed = { "c", "cpp", "cmake", "make", "cuda", "glsl",
                               "rust",
                               "python",
                               "lua",
                               "html", "css", "javascript", "typescript", "json", "jsonc", "json5", "tsx",
                               "toml", "yaml",
                               "vim",
                               "bash",
                               "regex",
                               "markdown", "markdown_inline"
                             },

          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,

          -- Automatically install missing parsers when entering buffer
          auto_install = true,

          highlight = {
            enable = true,
            disable = {
              -- 'vue',
            }
          },
          rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
          }
        }

        my_ts_install = function()
          vim.api.nvim_command('TSUpdate')

          vim.api.nvim_command('echo "C/C++"')
          vim.api.nvim_command('TSInstall c cpp cmake make cuda glsl')

          vim.api.nvim_command('echo "Rust"')
          vim.api.nvim_command('TSInstall rust')

          vim.api.nvim_command('echo "Python"')
          vim.api.nvim_command('TSInstall python')

          vim.api.nvim_command('echo "Lua"')
          vim.api.nvim_command('TSInstall lua')

          vim.api.nvim_command('echo "Web"')
          vim.api.nvim_command('TSInstall html css javascript typescript json jsonc json5 tsx')

          vim.api.nvim_command('echo "TOML/YAML"')
          vim.api.nvim_command('TSInstall toml yaml')

          vim.api.nvim_command('echo "Vim"')
          vim.api.nvim_command('TSInstall vim')

          vim.api.nvim_command('echo "Bash"')
          vim.api.nvim_command('TSInstall bash')

          vim.api.nvim_command('echo "Regex"')
          vim.api.nvim_command('TSInstall regex')

          vim.api.nvim_command('echo "Markdown"')
          vim.api.nvim_command("TSInstall markdown markdown_inline")
        end,
        vim.api.nvim_command('command MyTSInstall lua my_ts_install()')
      end,
      lazy = true,
    	event = "BufReadPost",
    })

    -- nvim-treesitter-context
    table.insert(plugins, {
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
    })

    -- nvim-treesitter/nvim-treesitter-textobjects
    table.insert(plugins, {
      "nvim-treesitter/nvim-treesitter-textobjects",
      config = function ()
        require("nvim-treesitter.configs").setup({
          textobjects = {
            select = {
              enable = true,

              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,

              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                -- You can optionally set descriptions to the mappings (used in the desc parameter of
                -- nvim_buf_set_keymap) which plugins like which-key display
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                -- You can also use captures from other query groups like `locals.scm`
                ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
              },

              selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
              },
              include_surrounding_whitespace = true,
            },
            move = {
              enable = true,
              goto_next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = { query = "@class.outer", desc = "Next class start" },
              },
              goto_next_end = {
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
              },
              goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
              },
              goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
              },
            },
          }
        })
      end,
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
      }
      lazy = true,
    	event = "BufReadPost",
    })

    return plugins
end

return treesitter
