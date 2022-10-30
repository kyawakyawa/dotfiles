local syntax_highlight = {}

syntax_highlight.setup = function(use)

    -- nvim-treesitter
    use ({
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
                               "bash"
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

        end,
        vim.api.nvim_command('command MyTSInstall lua my_ts_install()')
      end,
    })

    -- nvim-ts-rainbow
    use ({
      "p00f/nvim-ts-rainbow"
    })

    -- todo-comments.nvim
    use ({
      'folke/todo-comments.nvim',
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end,
    })
end

return syntax_highlight
