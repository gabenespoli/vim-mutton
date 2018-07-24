# mutton.vim

Add mutton chops to vim. Center a window on the screen by opening empty windows
on either side. Also supports opening various sidebar plugins in place of the
empty sidebars. Supports [Tagbar](https://github.com/majutsushi/tagbar),
[NERDTree](https://github.com/scrooloose/nerdtree), and
[Buffergator](https://github.com/jeetsukumaran/vim-buffergator).

## Motivation

I usually use n/vim in a full-screen terminal, which causes two problems
[especiall] on a large monitor. First, when editing code that is 80 characters
wide all of the text is on the far left and I'd much prefer it to be centered on
the screen. Second, when editing prose with soft line wrapping, each line (aka,
paragraph) is way to long across. I wanted to be able to center the buffer on
the screen. This plugin provides commands for toggling empty buffers on the left
and right parts of the screen, leaving your content in the middle part. This
plugin also provides wrappers for some sidebar plugins, so that they play nice
with the empty sidebars.

## Installation

vim-plug: `Plug gabenespoli/vim-mutton`

## Commands

`:MuttonToggle` = Enable mutton on both sides.

`:MuttonToggle('left')` or `:MuttonToggle('right')` = Enable mutton on only the
left or the right side.

`:MuttonToggle('tagbar')` = Open [Tagbar](https://github.com/majutsushi/tagbar)
and replace the mutton window if one exists. Use `g:tagbar_left` to control
which side it opens on.

`:MuttonToggle('nerdtree')` = Open [NERDTree](https://github.com/scrooloose/nerdtree) and replace the mutton window if
one exists. Use `g:NERDTreeWinPos` to control which side it opens on.

`:MuttonToggle('buffergator')` = Open [Buffergator](https://github.com/jeetsukumaran/vim-buffergator) and replace the mutton
window if one exists. Use `g:buffergator_viewport_split_policy` to control which
side it opens on

## Keymaps

Keymaps use the familiar window command key `<C-w>`, followed by `<C-e>`, which
is unused by vim. Think "window empty". The following maps are added by default.
Add `let g:mutton_disable_keymaps = 1` to your vimrc to disable them.

```vim
nnoremap <C-w><C-e>  :MuttonToggle()<CR>
nnoremap <C-w>eh     :MuttonToggle('left')<CR>
nnoremap <C-w>el     :MuttonToggle('right')<CR>
```

Keymaps for plugin toggles are not enabled by default. For example, I use the following in my vimrc:

```vim
nnoremap <leader>t :MuttonToggle('tagbar')<CR>
nnoremap <leader>- :MuttonToggle('nerdtree')<CR>
nnoremap <leader>= :MuttonToggle('buffergator')<CR>
```

## Options

`g:mutton_disable_keymaps` Set to 1 to disable the default keymaps.

`g:mutton_min_center_width` Force the middle (non-sidebar) window to have a
minimum width. This setting is for the case where you are on a smaller screen
with a bigger font, and want to open sidebars but no let the center window width
go below 80 characters, for example. Include the width of the fold/sign/number
columns in this value. I use the following in my vimrc to ensure at least 80
characters of text:

```vim
let g:mutton_min_center_width = 88
```
