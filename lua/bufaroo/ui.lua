local utils = require("bufaroo.utils")

local bufaroo_group = vim.api.nvim_create_augroup("Bufaroo", {
    clear = true,
})

local M = {}

M.bufnr = nil
M.win_id = nil
M.buffers = {}
M.closing = false

function M.create_window()
    utils.remove_external_buffers()

    local height = 10 -- 1 lines is default height
    local width = math.floor(vim.o.columns * 0.75)
    local bufnr = vim.api.nvim_create_buf(false, true)
    local win_id = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        title = "Bufaroo",
        title_pos = "center",
        row = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = "minimal",
        border = "single",
        zindex = 100,
    })

    if win_id == 0 then
        M.bufnr = bufnr
        M.close_window()
    end

    vim.api.nvim_buf_set_name(bufnr, "Bufaroo")
    vim.api.nvim_set_option_value("number", true, { win = win_id })
    vim.api.nvim_set_option_value("filetype", "bufaroo", { buf = bufnr })

    return {
        bufnr = bufnr,
        win_id = win_id,
    }
end

function M.close_window()
    if M.closing then
        return
    end

    M.closing = true

    local buffers = utils.get_buffers_from_names(
        M.buffers,
        vim.api.nvim_buf_get_lines(M.bufnr, 0, -1, false),
        true
    )

    if M.bufnr ~= nil and vim.api.nvim_buf_is_valid(M.bufnr) then
        vim.api.nvim_buf_delete(M.bufnr, { force = true })
    end

    if M.win_id ~= nil and vim.api.nvim_win_is_valid(M.win_id) then
        vim.api.nvim_win_close(M.win_id, true)
    end

    utils.remove_buffers(buffers)

    M.win_id = nil
    M.bufnr = nil
    M.buffers = buffers
    M.closing = false
end

function M.toggle_window()
    if M.win_id ~= nil then
        M.close_window()
        return
    end

    local current_buf = vim.api.nvim_get_current_buf()
    local window = M.create_window()

    local buffers = utils.update_buffers(M.buffers)
    local buf_names = utils.get_buffer_names(buffers, true)

    vim.api.nvim_buf_set_lines(window.bufnr, 0, -1, false, buf_names)

    local row = utils.get_buffer_index(buffers, "bufnr", current_buf)
    vim.api.nvim_win_set_cursor(window.win_id, { row, 0 })

    vim.keymap.set("n", "q", M.toggle_window, {
        buffer = window.bufnr,
        silent = true,
    })

    vim.keymap.set("n", "<ESC>", M.toggle_window, {
        buffer = window.bufnr,
        silent = true,
    })

    vim.keymap.set("n", "<C-c>", M.toggle_window, {
        buffer = window.bufnr,
        silent = true,
    })

    vim.keymap.set("n", "<CR>", function()
        local idx = vim.api.nvim_win_get_cursor(M.win_id)[1]
        local selected = vim.api.nvim_buf_get_lines(M.bufnr, idx - 1, idx, true)
        local buffer = nil

        if #selected > 0 and selected[0] ~= "" then
            buffer = utils.get_buffers_from_names(M.buffers, selected, true)[1]
        end

        M.toggle_window()

        if buffer ~= nil then
            M.open_buffer(buffer.bufnr)
        end
    end, {
        buffer = window.bufnr,
        silent = true,
    })

    vim.api.nvim_create_autocmd({ "BufLeave" }, {
        buffer = window.bufnr,
        callback = function()
            M.toggle_window()
        end,
        group = bufaroo_group,
    })

    vim.api.nvim_create_autocmd({ "BufModifiedSet" }, {
        buffer = window.bufnr,
        callback = function()
            vim.cmd("set nomodified")
        end,
        group = bufaroo_group,
    })

    M.win_id = window.win_id
    M.bufnr = window.bufnr
    M.buffers = buffers
end

function M.open_buffer(bufnr)
    if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_set_current_buf(bufnr)
    end
end

return {
    toggle_window = M.toggle_window,
}
