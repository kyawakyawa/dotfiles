-- Avante 側のセットアップ - MCP統合の強化
return {
  -- MCPサーバの状態をsystem_promptに反映
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    if hub then
      -- MCPサーバが存在する場合、そのプロンプトを取得
      return hub:get_active_servers_prompt() or ""
    end
    return ""
  end,

  -- MCPのツールをAvanteに追加
  custom_tools = function()
    local tools = {}

    -- MCPツールを追加
    local mcp_tool = require("mcphub.extensions.avante").mcp_tool()
    if mcp_tool then
      table.insert(tools, mcp_tool)
    end

    -- スラッシュコマンドを使うには以下のようなカスタムツールを追加できる
    -- table.insert(tools, {
    --     name = "run_tests",
    --     description = "プロジェクトのテストを実行します",
    --     func = function(params, on_log, on_complete)
    --         -- カスタムツールの実装
    --         return vim.fn.system("npm test")
    --     end,
    -- })

    return tools
  end,

  -- MCPと重複するAvanteのツールを無効化（必要に応じてコメントを外す）
  -- disabled_tools = {
  --    "list_files", "search_files", "read_file", "write_file",
  --    -- 効率的にするため、MCPで提供されるツールを無効化
  -- }
}
