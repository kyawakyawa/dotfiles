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
end

return syntax_highlight
