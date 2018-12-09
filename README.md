# mutton.vim

Add mutton chops to vim. Center a window on the screen by opening empty windows
on either side. Also supports opening various sidebar plugins in place of the
empty sidebars. Supports [Tagbar](https://github.com/majutsushi/tagbar),
[NERDTree](https://github.com/scrooloose/nerdtree), and
[Buffergator](https://github.com/jeetsukumaran/vim-buffergator).

## Motivation

Opening a file in a full-screen window means that the text is aligned at the
far left of the screen. I would rather see the text in the middle of the
screen, especially if it is code hard-wrapped at 80 characters. This plugin is
basically a macro to open blank scratch buffers on both sides of the screen to
achieve this effect. It also plays nice with some popular sidebar plugins, so
that these plugins will replace the blank scratch buffers as appropriate.

## Installation

vim-plug: `Plug gabenespoli/vim-mutton`

## Commands

`MuttonToggle`: Enable mutton on both sides.

`MuttonToggle('left')` or `MuttonToggle('right')`: Enable mutton on only the
left or the right side.

`MuttonToggle('tagbar')`: Open [Tagbar](https://github.com/majutsushi/tagbar)
and replace the mutton window if one exists. Use `g:tagbar_left` to control
which side it opens on.

`MuttonToggle('nerdtree')`: Open
[NERDTree](https://github.com/scrooloose/nerdtree) and replace the mutton window
if one exists. Use `g:NERDTreeWinPos` to control which side it opens on.

`MuttonToggle('buffergator')`: Open
[Buffergator](https://github.com/jeetsukumaran/vim-buffergator) and replace the
mutton window if one exists. Use `g:buffergator_viewport_split_policy` to
control which side it opens on. It must be `'L'` or `'R'` to work with mutton.

## Keymaps

Keymaps use the familiar window command key `<C-w>`, followed by `<C-e>`, which
is unused by vim. Think "window empty". The following maps are added by default.
Put `let g:mutton_disable_keymaps = 1` in your vimrc to disable them.

```vim
nnoremap <silent> <C-w><C-e>  :MuttonToggle()<CR>
nnoremap <silent> <C-w>eh     :MuttonToggle('left')<CR>
nnoremap <silent> <C-w>el     :MuttonToggle('right')<CR>
```

Keymaps for plugin toggles are not enabled by default. For example, I use the
following in my vimrc:.

```vim
nnoremap <silent> <leader>t :MuttonToggle('tagbar')<CR>
nnoremap <silent> <leader>n :MuttonToggle('nerdtree')<CR>
nnoremap <silent> <leader>b :MuttonToggle('buffergator')<CR>
```

## Options

`g:mutton_disable_keymaps` Set to 1 to disable the default keymaps.

`g:mutton_min_center_width` Force the middle (non-sidebar) window to have a
minimum width. This setting is for the case where you are on a smaller screen
with a bigger font, and want to open sidebars but no let the center window width
go below 80 characters, for example. Include the width of the fold/sign/number
columns in this value. I use the following in my vimrc to ensure at least 80
characters of text by allowing an extra 8 characters for the gutter:

```vim
let g:mutton_min_center_width = 88
```
