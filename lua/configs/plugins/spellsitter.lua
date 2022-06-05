-- https://github.com/lewis6991/spellsitter.nvim

local ok, spellsitter = pcall(require, "spellsitter")
if not ok then
    return
end

spellsitter.setup()

