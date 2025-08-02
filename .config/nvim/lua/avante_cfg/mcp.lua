-- Avante 側のセットアップ - MCP統合の強化
return {
  -- MCPサーバの状態をsystem_promptに反映
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,

  -- MCPのツールをAvanteに追加
  custom_tools = function()
    return {
      require("mcphub.extensions.avante").mcp_tool(),
    }
  end,

  -- MCPと重複するAvanteのツールを無効化（必要に応じてコメントを外す）
  disabled_tools = {
    -- "rag_search",
    -- "python",
    -- "git_diff",
    -- "git_commit",
    -- "glob",
    -- "search_keyword",
    -- "read_file_toplevel_symbols",
    -- "read_file",
    -- "create_file",
    -- "move_path",
    -- "copy_path",
    -- "delete_path",
    -- "create_dir",
    -- "bash",
    -- "web_search",
    "fetch",
    -- 効率的にするため、MCPで提供されるツールを無効化
  },
}
