local ok, web_devicons = pcall(require, 'nvim-web-devicons')

if not ok then
    vim.notify('nvim-web-devicons not found')
    return
end

web_devicons.setup({
  override = {
    html = {
      icon = "",
      color = "#E34F26",
      name = "HTML",
    },
    css = {
      icon = "",
      color = "#1572B6",
      name = "CSS",
    },
    js = {
      icon = "",
      color = "#F7DF1E",
      name = "JavaScript",
    },
    ts = {
      icon = "ﯤ",
      color = "#3178C6",
      name = "TypeScript",
    },
    Dockerfile = {
      icon = "",
      color = "#2496ED",
      name = "Dockerfile",
    },
    rb = {
      icon = "",
      color = "#CC342D",
      name = "Ruby",
    },
    vue = {
      icon = "﵂",
      color = "#4FC08D",
      name = "Vue",
    },
    py = {
      icon = "",
      color = "#d08770",
      name = "Python",
    },
    json = {
      icon = "",
      color = "#999999",
      name = "JSON",
    },
    toml = {
      icon = "",
      color = "#999999",
      name = "TOML",
    },
    yaml = {
      icon = "",
      color = "#999999",
      name = "YAML",
    },
    lock = {
      icon = "",
      color = "#DE6B74",
      name = "lock",
    },
    bash = {
      icon = "",
      color = "#4EAA25",
      name = "BASH",
    },
    zsh = {
      icon = "",
      color = "#4EAA25",
      name = "Zsh",
    },
    doomrc = {
      icon = "",
      color = "#7F5AB6",
      name = "doomrc",
    },
  },
  default = true,
})
