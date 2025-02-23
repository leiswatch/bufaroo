# `bufaroo`
bufaroo is a dead simple buffer manager for Neovim.

## Installation
- Neovim 0.10+ is required
- Install bufaroo using `lazy.nvim`:
```lua
{
  "leiswatch/bufaroo",
  keys = {
      {
        "J",
        function()
          require("bufaroo").toggle_window()
        end,
        { noremap = true, silent = true, nowait = true },
      },
  },
  opts = {},
}
```

## Usage
```lua
:lua require("bufaroo").toggle_window()
```
A floating popup window will appear with the list of your buffers. You can navigate the list with `j` and `k`, select the buffer with `<CR>` or with `1-9`. You can also delete the buffers simply by deleting the line.

## Configuration
Default options:
```lua
opts = {
    use_short_names = true -- remove the vim.uv.cwd() from the beginning of the buffer name
    win_opts = {
        title = "Bufaroo",
        height = 10,
        width = math.floor(vim.o.columns * 0.5)
        border = "single",
    }
}
