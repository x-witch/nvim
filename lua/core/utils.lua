local M = {}

M.starts_with = function(str, start)
  return str:sub(1, #start) == start
end

M.ends_with = function(str, ending)
  return ending == "" or str:sub(- #ending) == ending
end

M.path_join = function(...)
    return table.concat(vim.tbl_flatten({ ... }), "/")
end

M.str_title = function(s)
    return (s:gsub("(%a)([%w_']*)", function(f, r)
        return f:upper() .. r:lower()
    end))
end

M.close_buffer = function(force)
   if vim.bo.buftype == "terminal" then
      vim.api.nvim_win_hide(0)
      return
   end

   local fileExists = vim.fn.filereadable(vim.fn.expand "%p")
   local modified = vim.api.nvim_buf_get_option(vim.fn.bufnr(), "modified")

   -- if file doesnt exist & its modified
   if fileExists == 0 and modified then
      print "no file name? add it now!"
      return
   end

   force = force or not vim.bo.buflisted or vim.bo.buftype == "nofile"

   -- if not force, change to prev buf and then close current
   local close_cmd = force and ":bd!" or ":bp | bd" .. vim.fn.bufnr()
   vim.cmd(close_cmd)
end

function M.toggle_sidebar(target_ft)
    local offset_ft = {
        "NvimTree",
        "undotree",
        "dbui",
        "spectre_panel",
    }
    local wins = vim.api.nvim_list_wins()
    for _, win_id in ipairs(wins) do
        if vim.api.nvim_win_is_valid(win_id) then
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")
            if ft ~= target_ft and vim.tbl_contains(offset_ft, ft) then
                vim.api.nvim_win_close(win_id, true)
            end
        end
    end
end

function M.hiset(name, opts)
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
function M.higet(name, style)
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
function M.hilink(definition_hi, link_hi)
    vim.cmd("highlight link " .. definition_hi .. " " .. link_hi)
end

--[[
Clear preset highlights
Defined for themes without background highlighting
]]
function M.hitransparent()
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

return M
