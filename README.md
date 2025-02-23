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
### Dependencies
- [snacks.nvim](https://github.com/folke/snacks.nvim) (optional for buffer delete method, will fallback to Neovim's built-in method)

## Usage
```lua
:lua require("bufaroo").toggle_window()
```
A floating popup window will appear with the list of your buffers. You can navigate the list with `j` and `k`, select the buffer with `<CR>` or with `1-9`. You can also delete the buffers simply by deleting the line.

![image](https://github.com/user-attachments/assets/9a0030b0-3683-421c-ad61-80889665136e)
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
```
## Similar plugins
-  [buffer_manager.nvim](https://github.com/j-morano/buffer_manager.nvim) - More options available, which I don't care about.
-  [rabbit.nvim](https://github.com/VoxelPrismatic/rabbit.nvim)
