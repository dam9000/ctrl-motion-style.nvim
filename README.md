# Ctrl-Motion Style for Neovim

This provides an easy way to set the ctrl-motion keys to a predefined style such as `vscode`, `borland`, etc...

The keys covered are `ctrl + cursor keys, Home/End, PageUp/Down`

The style needs to be specified via setup(opts) and can be done for all keys
(with `style='name'`) or individual keys (with `c_key='style'` or `c_key='action'`).
Currently these styles are defined: `vim`, `vscode`, `borland`, `preset1`, `preset2`, `preset3`.

See below for examples and the source [ctrl-motion-style.lua](lua/ctrl-motion-style.lua) for
details on behaviours, styles, keys and actions.

## Installation

Install the plugin with your preferred package manager, or copy to your nvim config dir and add to `init.lua`:

```lua
require'ctrl-motion-style'.setup({ style='vscode', })
```

Examples for [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager:

set style for all keys to vscode:
```lua
{ 'dam9000/ctrl-motion-style.nvim', opts={ style='vscode' }, },
```
or, set style for all keys to vscode except left/right to borland:
```lua
{ 'dam9000/ctrl-motion-style.nvim', opts={
  style='vscode',
  c_Left='borland',
  c_Right='borland',
},},
```
or, only set only specific keys to a specific action:
```lua
{ 'dam9000/ctrl-motion-style.nvim', opts={
  c_Left  = 'backward_alnum',
  c_Right = 'forward_alnum',
  c_Up    = 'scroll_window_up',
  c_Down  = 'scroll_window_down',
}, },
```

