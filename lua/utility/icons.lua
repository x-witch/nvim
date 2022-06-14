local icons = {}

icons.lsp_hover = {
    Action = "💡",
}


-- icons.kind = {
--     -- Method: פּ
--     Text = "",
--     Method = "",
--     Function = "",
--     Constructor = "",
--     Field = "ﰠ",
--     Variable = "",
--     Class = "",
--     Interface = "",
--     Module = "ﰪ",
--     Property = "ﳋ",
--     Unit = "塞",
--     Value = "",
--     Enum = "",
--     Keyword = "",
--     Snippet = "",
--     Color = "",
--     File = "",
--     Reference = "",
--     Folder = "",
--     EnumMember = "",
--     Constant = "",
--     Struct = "﬌",
--     Event = "",
--     Operator = "",
--     TypeParameter = "",
-- }

icons.platform_icons = {
    -- unix = " ",
    unix = " ",
    dos = " ",
    mac = " ",
}

icons.vscode = {
    Text = " ",
    Method = " ",
    Function = " ",
    Constructor = " ",
    Field = " ",
    Variable = " ",
    Class = " ",
    Interface = " ",
    Module = " ",
    Property = " ",
    Unit = " ",
    Value = " ",
    Enum = " ",
    Keyword = " ",
    Snippet = " ",
    Color = " ",
    File = " ",
    Reference = " ",
    Folder = " ",
    EnumMember = " ",
    Constant = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
}

-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- find more here: https://www.nerdfonts.com/cheat-sheet
-- if vim.fn.has 'mac' == 1 then
-- elseif vim.fn.has 'mac' == 1 then
icons.debug = {
    name = 'debug',
    char = '🐛',
    foreground = '#f8f8f2',
    background = '#44475a',
}
icons.signs = {
    debug = '',
    debug_into = '',
    debug_out = '',
    debug_over = '',
    debug_breakpoint = '',
    debug_breakpoint_reject = '⚫', --
    debug_breakpoint_error = '🛑', -- 🔴
    debug_breakpoint_stop = '', -- 🟢

    hint = '', -- 﫢
    info = '', -- ●
    warning = '', --﹗▲！⚠️
    error = '', -- ■💊
    link = '', -- 
    null = '', -- 🚫
    todo = '',
    hack = '',
    note = '',
    perf = '龍',
    fix = '',
    bookmark = '🔖',
    trash = '🗑️',
    deleted = '🕳️', -- 

    check = '',
    check_all = '',
    check_circle = '﫟',

    unpack = '',
    pack = '',

    arrow_right = '',
    arrow_up = '',
    arrow_left = '',
    arrow_down = '',

    search = '🔎', -- 

    flash = '',
    bulb = '💡',
    flag = '',

    vim = '',
    skull = '💀',
}
icons.kind = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = '',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = '',
}
icons.type = {
    Array = '',
    Number = '',
    String = '',
    Boolean = '蘒',
    Object = '',
}
icons.documents = {
    File = '',
    Files = '',
    Folder = '',
    OpenFolder = '',
}
icons.git = {
    Add = '',
    Mod = '',
    Remove = '',
    Ignore = '',
    Rename = '',
    Diff = '',
    Repo = '',

    unstaged = '●',
    staged = '',
    unmerged = '',
    rename = 'R', -- ➜
    untracked = '',
    deleted = '',
    ignored = '◌', -- 

    line_branch = '',
    line_add = '',
    line_modified = '',
    line_removed = '',
    line_ignored = '',
    line_rename = '',
    line_diff = '',
    line_repo = '',

    sign_add = '│',
    sign_change = '│',
    sign_delete = '_',
    sign_topdelete = '‾',
    sign_changedelete = '~'
}
icons.ui = {
    Lock = '',
    Circle = '',
    BigCircle = '',
    BigUnfilledCircle = '',
    Close = '',
    NewFile = '',
    Search = '',
    Lightbulb = '',
    Project = '',
    Dashboard = '',
    History = '',
    Comment = '',
    Bug = '',
    Code = '',
    Telescope = '',
    Gear = '',
    Package = '',
    List = '',
    SignIn = '',
    Check = '',
    Fire = '',
    Note = '',
    BookMark = '',
    Pencil = '',
    -- ChevronRight = '',
    ChevronRight = '>',
    Table = '',
    Calendar = '',
}
icons.diagnostics = {
    Error = '',
    Warn = '',
    Info = '',
    Question = '',
    Hint = '',
}
icons.misc = {
    Robot = 'ﮧ',
    Squirrel = '',
    Tag = '',
    Watch = '',
}
--   פּ ﯟ   蘒練 some other good icons
return icons
