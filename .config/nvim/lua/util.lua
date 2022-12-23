local M = {}

function M.OSX()

return vim.cmd([[exec has('macunix')]])

end

return M

