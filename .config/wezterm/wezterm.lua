-- vim:sw=2:ts=2:tw=0
local wezterm = require 'wezterm'
local act = wezterm.action
return {
  color_scheme = [[Tokyo Night Moon]],
  font = wezterm.font_with_fallback {
    { family = 'Cascadia Mono', weight = 'Regular' },
    { family = 'Symbols Nerd Font Mono' },
  },
  font_size = 14.0,
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  hide_tab_bar_if_only_one_tab = false,
  initial_cols = 150,
  initial_rows = 35,
  keys = {
    { key = 't', mods = 'ALT', action = act { SpawnTab = 'CurrentPaneDomain' } },
    { key = '1', mods = 'ALT', action = act { ActivateTab = 0 } },
    { key = '2', mods = 'ALT', action = act { ActivateTab = 1 } },
    { key = '3', mods = 'ALT', action = act { ActivateTab = 2 } },
    { key = '4', mods = 'ALT', action = act { ActivateTab = 3 } },
    { key = '5', mods = 'ALT', action = act { ActivateTab = 4 } },
    { key = '6', mods = 'ALT', action = act { ActivateTab = 5 } },
    { key = '7', mods = 'ALT', action = act { ActivateTab = 6 } },
    { key = '8', mods = 'ALT', action = act { ActivateTab = 7 } },
    { key = '9', mods = 'ALT', action = act { ActivateTab = 8 } },
    { key = '0', mods = 'ALT', action = act { ActivateTab = 9 } },
    { key = 'c', mods = 'ALT', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'ALT', action = act.PasteFrom 'Clipboard' },
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'Clipboard' },
    { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
    { key = 'w', mods = 'ALT', action = act { CloseCurrentPane = { confirm = true } } },
    { key = 'q', mods = 'ALT', action = act { CloseCurrentTab = { confirm = true } } },
    { key = 'PageUp', mods = 'ALT', action = act.ActivateTabRelative(-1) },
    { key = 'PageDown', mods = 'ALT', action = act.ActivateTabRelative(1) },
  },
  line_height = 1.1,
  mouse_bindings = {
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.CompleteSelection 'Clipboard',
    },
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.CompleteSelection 'Clipboard',
    },
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'SHIFT',
      action = wezterm.action.CompleteSelection 'Clipboard',
    },
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'ALT',
      action = wezterm.action.CompleteSelection 'Clipboard',
    },
    {
      event = { Down = { streak = 1, button = 'Middle' } },
      mods = 'NONE',
      action = wezterm.action.PasteFrom 'Clipboard',
    },
    {
      event = { Up = { streak = 2, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.CompleteSelection 'Clipboard',
    },
    {
      event = { Up = { streak = 3, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.CompleteSelection 'Clipboard',
    },
    {
      event = { Drag = { streak = 1, button = 'Left' } },
      mods = 'CTRL | ALT',
      action = wezterm.action.ExtendSelectionToMouseCursor 'Block',
    },
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL | ALT',
      action = wezterm.action.CompleteSelection 'Clipboard',
    },
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'SHIFT | ALT',
      action = wezterm.action.CompleteSelection 'Clipboard',
    },
  },
  pane_focus_follows_mouse = true,
  scrollback_lines = 20000,
  selection_word_boundary = '{}[]|\\()"\'`,;: <>',
  term = 'xterm-256color',
  use_cap_height_to_scale_fallback_fonts = true,
  window_decorations = 'INTEGRATED_BUTTONS|RESIZE',
  window_padding = {
    left = 20,
  },
}
