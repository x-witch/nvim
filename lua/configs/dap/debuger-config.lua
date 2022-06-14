local _M = {}

local status_ok, _ = pcall(require, 'dap')
if not status_ok then
    return _M
end

local find_next_start = function(str, cur_idx)
    while cur_idx <= #str and str:sub(cur_idx, cur_idx) == ' ' do
        cur_idx = cur_idx + 1
    end
    return cur_idx
end

local str2argtable = function(str)
    if str == nil then return {} end
    str = string.gsub(str, '^%s*(.-)%s*$', '%1')
    local arg_list = {}

    local start = 1
    local i = 1
    local quote_refs_cnt = 0
    while i <= #str do
        local c = str:sub(i, i)
        if c == '"' then
            quote_refs_cnt = quote_refs_cnt + 1
            start = i
            i = i + 1
            -- find next quote
            while i <= #str and str:sub(i, i) ~= '"' do
                i = i + 1
            end
            if i <= #str then
                quote_refs_cnt = quote_refs_cnt - 1
                arg_list[#arg_list + 1] = str:sub(start, i)
                start = find_next_start(str, i + 1)
                i = start
            end
            -- find next start
        elseif c == ' ' then
            arg_list[#arg_list + 1] = str:sub(start, i - 1)
            start = find_next_start(str, i + 1)
            i = start
        else
            i = i + 1
        end
    end

    -- add last arg if possiable
    if start ~= i and quote_refs_cnt == 0 then
        arg_list[#arg_list + 1] = str:sub(start, i)
    end
    return arg_list
end

local get_args = function()
    local input = vim.fn.input('dap-args: ')
    return str2argtable(input)
end

local debug_server_config = {
    python = {
        adapter = {
            type = 'executable', -- or server, which needs host and port
            command = 'python3',
            args = { '-m', 'debugpy.adapter' }
        },
        config = {
            {
                name = 'Launch file';
                type = 'python';
                request = 'launch';
                program = '${file}';
                args = get_args;
                pythonPath = function()
                    local cwd = vim.fn.getcwd()
                    if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                        return cwd .. '/venv/bin/python'
                    elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                        return cwd .. '/.venv/bin/python'
                    else
                        return 'python'
                    end
                end;
            }

        },
    },
}

_M.debug_servers = {
    names = {
        python = 'python',
        -- cpp = 'cppdbg',
        -- c = 'c',
        -- rust = 'rust',
    },
    config = {
        python = debug_server_config.python,
        -- cpp = debug_server_config.cpp,
        -- c = debug_server_config.cpp,
        -- rust = debug_server_config.cpp
    }
}

return _M
