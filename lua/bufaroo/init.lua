local ui = require("bufaroo.ui")

local M = {}

M.setup = function(opts)
    ui.register_config(opts)
end

vim.keymap.set("n", "<leader>j", ui.toggle_window, {})

return M
