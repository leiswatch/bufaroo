local ui = require("bufaroo.ui")

local M = {}

M.setup = function(opts)
    ui.register_config(opts)
end

M.new = function()
    return {
        setup = M.setup,
        toggle_window = ui.toggle_window,
    }
end

local bufaroo = M.new()

return bufaroo
