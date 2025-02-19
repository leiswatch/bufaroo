local ui = require("bufaroo.ui")

local M = {}

M.setup = function()
    -- nothing
end

vim.keymap.set("n", "<leader>j", ui.toggle_window, {})

return M
