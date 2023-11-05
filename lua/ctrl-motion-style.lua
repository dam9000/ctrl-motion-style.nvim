-- ctrl-motion-style

-- Set the style of ctrl+motion keys according to behaviour of some of the
-- well known text editors

--[[

Behaviours:

vim/neovim:

  ctrl-Left:      start of previous WORD (B)
  ctrl-Right:     start of next WORD (W)
  ctrl-Up/Down:   nop
  ctrl-Home:      first line + opt.startofline (gg)
  ctrl-End:       end of last line (G$)
  ctrl-PageUp:    previous tab (gT)
  ctrl-PageDown:  next tab (gt)

vim:    opt.startofline default = true
neovim: opt.startofline default = false

vscode:

  ctrl-Left:      start of previous alphanum word or start of line
  ctrl-Right:     end of next alphanum word or end of line
  ctrl-Up/Down:   scroll window contents
  ctrl-Home:      start of first line
  ctrl-End:       end of last line
  ctrl-PageUp:    previous tab
  ctrl-PageDown:  next tab

Borland:

  ctrl-Left:      start of previous alphanum word or line
  ctrl-Right:     start of next alphanum word or end of line
  ctrl-Up/Down:   nop
  ctrl-Home:      first line of window, same column
  ctrl-End:       last line of window, same column
  ctrl-PageUp:    start of first line
  ctrl-PageDown:  end of last line

// example of ctrl-right jumps in different editors

    for (i = 0; i < 10; i++) { printf("Hello, i=%d\n", i); }
//  ^    ^   ^  ^   ^   ^      ^       ^      ^  ^ ^   ^   ^  // Borland ctrl-right
//  ^   ^^ ^ ^^ ^ ^ ^ ^ ^^   ^ ^     ^ ^    ^ ^^ ^^^^  ^^  ^  // Notepad++ ctrl-right
//  ^   ^^ ^ ^^ ^ ^ ^ ^ ^^   ^ ^     ^ ^    ^ ^^ ^^^^  ^^  ^  // vim-w
//  ^   ^  ^ ^  ^ ^ ^   ^    ^ ^              ^        ^   ^  // vim-W
//    ^ ^^ ^ ^^ ^ ^  ^^ ^  ^ ^      ^ ^    ^^ ^ ^^^^ ^ ^ ^ ^  // vim-e
//     ^  ^ ^ ^^ ^ ^  ^^ ^  ^ ^      ^ ^    ^^ ^ ^^ ^ ^ ^ ^ ^ // vscode ctrl-right

--]]

local M = {}

-- forward to start of alphanum word or end of line
function M.forward_alnum()
  vim.fn.search('\\<\\|$')
end

-- forward to end of alphanum word or end of line
function M.forward_alnum_end()
  vim.fn.search('\\>\\|$')
end

-- backward to start of alphanum word or start of line
function M.backward_alnum()
  vim.fn.search('\\<\\|^', 'b')
end

-- backward to end of alphanum word or start of line
function M.backward_alnum_end()
  vim.fn.search('\\>\\|^', 'b')
end

-- kname -> kcode
M.map_keys = {
  c_Left =     '<c-Left>',
  c_Right =    '<c-Right>',
  c_Up =       '<c-Up>',
  c_Down =     '<c-Down>',
  c_Home =     '<c-Home>',
  c_End =      '<c-End>',
  c_PageUp =   '<c-PageUp>',
  c_PageDown = '<c-PageDown>',
}

-- action -> { kcode or fun, desc }
M.map_action = {
  vim_w               = { 'w',  desc='forward vim word', },
  vim_W               = { 'W',  desc='forward vim WORD', },
  vim_e               = { 'e',  desc='forward end of vim word', },
  vim_E               = { 'E',  desc='forward end of vim WORD', },
  vim_b               = { 'b',  desc='backward vim word', },
  vim_B               = { 'B',  desc='backward vim WORD', },
  vim_gg              = { 'gg', desc='first line + opt.startofline', },
  vim_G               = { 'G',  desc='last line + opt.startofline', },
  up_2                = { '2k', desc='up 2 lines', },
  up_3                = { '3k', desc='up 3 lines', },
  up_4                = { '4k', desc='up 4 lines', },
  down_2              = { '2j', desc='down 2 lines', },
  down_3              = { '3j', desc='down 3 lines', },
  down_4              = { '4j', desc='down 4 lines', },
  forward_alnum       = { M.forward_alnum,      desc='forward alphanum word or end of line', },
  forward_alnum_end   = { M.forward_alnum_end,  desc='forward end of alphanum word or end of line', },
  backward_alnum      = { M.backward_alnum,     desc='backward alphanum word or start of line', },
  backward_alnum_end  = { M.backward_alnum_end, desc='backward end of alphanum word or start of line', },
  first_line_start    = { 'gg0',  ins='<c-o>gg<c-o>0', desc='start of first line', },
  last_line_start     = { 'G0',   ins='<c-o>G<c-o>0', desc='start of last line', },
  last_line_end       = { 'G$',   ins='<c-o>G<c-o>$', desc='end of last line', },
  window_top          = { 'H',      desc='move to top of window', },
  window_bottom       = { 'L',      desc='move to bottom of window', },
  scroll_window_up    = { '<c-y>',  desc='scroll window up', },
  scroll_window_down  = { '<c-e>',  desc='scroll window down', },
  previous_tab        = { 'gT',     desc='previous tab', },
  next_tab            = { 'gt',     desc='next tab', },
}

-- preset -> { kname -> action }
M.map_styles = {
  -- vim preset
  vim = {
    c_Left      = 'vim_B',
    c_Right     = 'vim_W',
    c_Up        = nil,
    c_Down      = nil,
    c_Home      = 'vim_gg',
    c_End       = 'last_line_end',
    c_PageUp    = 'previous_tab',
    c_PageDown  = 'next_tab',
  },
  -- vscode preset
  vscode = {
    c_Left      = 'vim_b',
    c_Right     = 'vim_e',
    c_Up        = 'scroll_window_up',
    c_Down      = 'scroll_window_down',
    c_Home      = 'first_line_start',
    c_End       = 'last_line_end',
    c_PageUp    = 'previous_tab',
    c_PageDown  = 'next_tab',
  },
  -- borland preset
  borland = {
    c_Left      = 'backward_alnum',
    c_Right     = 'forward_alnum',
    c_Up        = nil,
    c_Down      = nil,
    c_Home      = 'window_top',
    c_End       = 'window_bottom',
    c_PageUp    = 'first_line_start',
    c_PageDown  = 'last_line_end',
  },
  -- preset1: vim, but left/right from borland, home/end form vscode
  preset1 = {
    c_Left      = 'borland',
    c_Right     = 'borland',
    c_Up        = 'vim',
    c_Down      = 'vim',
    c_Home      = 'vscode',
    c_End       = 'vscode',
    c_PageUp    = 'vim',
    c_PageDown  = 'vim',
  },
  -- preset2: vscode, but left/right from borland
  preset2 = {
    c_Left      = 'borland',
    c_Right     = 'borland',
    c_Up        = 'vscode',
    c_Down      = 'vscode',
    c_Home      = 'vscode',
    c_End       = 'vscode',
    c_PageUp    = 'vscode',
    c_PageDown  = 'vscode',
  },
  -- preset3: custom
  preset3 = {
    c_Left      = 'backward_alnum',
    c_Right     = 'forward_alnum',
    c_Up        = 'up_3',
    c_Down      = 'down_3',
    c_Home      = 'first_line_start',
    c_End       = 'last_line_start',
    c_PageUp    = 'window_top',
    c_PageDown  = 'window_bottom',
  },
}

function M.get_map(opts, kname)
  if not opts then
    return nil
  end
  local action = opts[kname]
  if not action and opts.style then
    action = M.map_styles[opts.style][kname]
  end
  if not action then
    return nil
  end
  -- action can be a reference to a style
  -- limit number of redirections
  local _
  for _ = 1, 4 do
    if M.map_action[action] then
      return M.map_action[action]
    elseif M.map_styles[action] then
      -- action is a style
      --print("redirect", kname, action, "->", M.map_styles[action][kname])
      action = M.map_styles[action][kname]
    else
      return nil
    end
  end
  return nil
end

function M.setup(opts)

  vim.g.loaded_classic_motions = 1

  if not opts then
    return
  end
  -- map keys as specified by opts
  for kname, kcode in pairs(M.map_keys) do
    local kmap = M.get_map(opts, kname)
    if kmap then
      --print("map ", kname, kcode, kmap[1], '"', kmap.desc, '"')

      -- mode '' = n, v, o
      vim.keymap.set('', kcode, kmap[1], { desc = kmap.desc })

      -- in visual mode add also shift-ctrl-motion
      -- this is useful in case opt.keymodel=startsel which starts visual selection
      -- when shift-motion is pressed. In this way shift-ctrl-motion will be
      -- consistent with ctrl-motion
      -- this can be disabled by setting opts.shift=false
      if not (opts.shift == false) then
        local shift_kcode = kcode:gsub('^<c%-', '<sc-')
        --print("vmap ", kname, shift_kcode, kmap[1], '"', kmap.desc, '"')
        vim.keymap.set('v', shift_kcode, kmap[1], { desc = kmap.desc })
      end

      -- mode 'i' = insert
      if (type(kmap[1]) == 'function') then
        vim.keymap.set('i', kcode, kmap[1], { desc = kmap.desc })
      elseif kmap.ins then
        vim.keymap.set('i', kcode, kmap.ins, { desc = kmap.desc })
      else
        vim.keymap.set('i', kcode, '<c-o>'..kmap[1], { desc = kmap.desc })
      end
    end
  end

end


return M

-- vim: ts=2 sts=2 sw=2 et
