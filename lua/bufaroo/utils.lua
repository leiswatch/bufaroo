local M = {}

local function contains(table, property, value)
    for i = 1, #table do
        if table[i][property] == value then
            return true
        end
    end

    return false
end

function M.get_buffers()
    local buffers = {}

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.fn.buflisted(bufnr) == 1 then
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local short_bufname = nil
            local cwd = vim.uv.cwd()

            if cwd ~= nil then
                local _, end_index = string.find(bufname, cwd, nil, true)

                if end_index ~= nil then
                    short_bufname = string.sub(bufname, end_index + 1)
                    short_bufname = string.gsub(short_bufname, "/", "", 1)
                end
            end

            if bufname ~= "" then
                table.insert(buffers, {
                    bufnr = bufnr,
                    bufname = bufname,
                    short_bufname = short_bufname,
                })
            end
        end
    end

    return buffers
end

function M.get_buffer_names(buffers, use_short_names)
    local buf_names = {}
    local property = (use_short_names and "short_bufname") or "bufname"

    for _, buffer in ipairs(buffers) do
        table.insert(buf_names, buffer[property])
    end

    return buf_names
end

function M.remove_buffers(buffers, curr_buffers)
    curr_buffers = curr_buffers or M.get_buffers()

    for _, buf in ipairs(curr_buffers) do
        if not contains(buffers, "bufnr", buf.bufnr) then
            vim.api.nvim_buf_clear_namespace(buf.bufnr, -1, 1, -1)
            if Snacks ~= nil and Snacks.bufdelete ~= nil then
                Snacks.bufdelete(buf.bufnr)
            else
                vim.api.nvim_buf_delete(buf.bufnr, {})
            end
        end
    end
end

function M.update_buffers(buffers)
    local curr_buffers = M.get_buffers()

    for _, buf in ipairs(curr_buffers) do
        if not contains(buffers, "bufnr", buf.bufnr) then
            table.insert(buffers, buf)
        end
    end

    return buffers
end

function M.get_buffer_index(buffers, property, value)
    for index, buf in ipairs(buffers) do
        if buf[property] == value then
            return index
        end
    end

    return nil
end

function M.get_buffers_from_names(buffers, names, use_short_names)
    local result = {}
    local property = (use_short_names and "short_bufname") or "bufname"

    for _, name in ipairs(names) do
        if contains(buffers, property, name) then
            local index = M.get_buffer_index(buffers, property, name)

            table.insert(result, buffers[index])
        end
    end

    return result
end

function M.remove_external_buffers()
    local buffers = vim.api.nvim_list_bufs()

    if #buffers > 0 then
        for i = 1, #buffers do
            local filetype =
                vim.api.nvim_get_option_value("filetype", { buf = buffers[i] })

            if filetype == "harpoon" then
                vim.api.nvim_buf_delete(buffers[i], { force = true })
            end
        end
    end
end

return M
