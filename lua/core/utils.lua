local M = {}
local api = vim.api

-- Create an augroup
function M.create_augroup(autocmds, name, clear)
    local group = api.nvim_create_augroup(name, { clear = clear })

    for _, autocmd in ipairs(autocmds) do
        autocmd.opts.group = group
        api.nvim_create_autocmd(autocmd.event, autocmd.opts)
    end
end

-- Create a buffer-local augroup
function M.create_buf_augroup(bufnr, autocmds, name, clear)
    bufnr = bufnr or 0

    for _, autocmd in ipairs(autocmds) do
        autocmd.opts.buffer = bufnr
    end

    M.create_augroup(autocmds, name, clear)
end

function M.starts_with(str, start)
  return str:sub(1, #start) == start
end

function M.ends_with(str, ending)
  return ending == "" or str:sub(- #ending) == ending
end

-- 高亮相关
function M.hi_set(name, opts)
    local command = "highlight! " .. name
    for k, v in pairs(opts) do
        if k ~= "gui" then
            command = command .. " gui" .. k .. "=" .. v
        else
            command = command .. " " .. k .. "=" .. v
        end
    end
    vim.cmd(command)
end

--[[
Get neovim highlight
Example:
    hi.get("Comment", "fg")
    => "#Green"
]]
function M.hi_get(name, style)
    local opts = {}
    local output = vim.fn.execute("highlight " .. name)
    local lines = vim.fn.trim(output)
    for k, v in lines:gmatch("(%a+)=(#?%w+)") do
        opts[k] = v
    end
    if style ~= "gui" then
        return opts["gui" .. style]
    end
    return opts[style]
end

--[[
Link neovim highlight
Example:
   hi.link("Comment", "Link")
   => nil
]]
function M.hi_link(definition_hi, link_hi)
    vim.cmd("highlight link " .. definition_hi .. " " .. link_hi)
end

--[[
Clear preset highlights
Defined for themes without background highlighting
]]
function M.hi_transparent()
    local clear_hi = {
        "Normal",
        "NormalNC",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "SignColumn",
        "CursorLineNr",
        -- nvim-tree
        "NvimTreeNormal",
        "NvimTreeVertSplit",
    }

    for _, group in ipairs(clear_hi) do
        vim.cmd(string.format("hi %s ctermbg=NONE guibg=NONE", group))
    end
end
-- 高亮相关

return M
