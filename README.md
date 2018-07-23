# mutton.vim

Add mutton chops to vim. Center a window on the screen by opening empty windows
on either side. Eventually, use these windows to display the windows of various
plugins. Currently only supports [Tagbar](https://github.com/majutsushi/tagbar).

## Motivation

I usually use terminal vim in a full-screen terminal, which causes a couple of annoyances (when I'm not using splits). First, when editing code that is 80 characters wide all of the text is on the far left and I'd much prefer it to be centered on the screen. Second, when editing prose or markdown with soft line wrapping, each line is way to long across. I wanted to be able to center the buffer on the screen.

This plugin provides commands for toggling empty buffers on the left and right quarters of the screen, leaving your content in the middle half.

## Installation

vim-plug: `Plug gabenespoli/vim-mutton`

## Commands

`MuttonToggle`: When called without an input, toggle mutton on both sides. Input can be 'left', 'right', 'tagbar', 'nerdtree', or 'buffergator'

## Keymaps

Keymaps use the familiar window command key `<C-w>`, followed by `<C-e>`, which is unused by vim. Think "window empty".

- `<C-w><C-e>m` or `<C-w><C-e><C-m>` enables Mutton on both sides (like <C-m> enter, or m for mutton)
- `<C-w><C-e>j` or `<C-w><C-e><C-j>` enables Mutton on both sides (like <C-j> enter)
- `<C-w><C-e><CR>` enables Mutton on both sides
- `<C-w><C-e>h` or `<C-w><C-e><C-h>` opens an empty mutton sidebar on the left
- `<C-w><C-e>l` or `<C-w><C-e><C-l>` opens an empty mutton sidebar on the right

To use your own keymaps, disable the defaults and map the commands manually in your vimrc, like so:

```vim
let g:MuttonDisableKeymaps = 1
nnoremap <leader>mm :call MuttonToggle()<CR>
nnoremap <leader>mh :call MuttonToggle('left')<CR>
nnoremap <leader>ml :call MuttonToggle('right')<CR>
```

Toggles for specific plugins are not enabled by default. Mutton essentially wraps the open and close functions of [Tagbar](https://github.com/majutsushi/tagbar), [NERDTree](), and [Buffergator]() so that an empty sidebar is closed or re-opened depending on the situation. For example, I use the following in my vimrc:

```vim
nmap <leader>t :MuttonToggle('tagbar')<CR>
nmap <leader>- :MuttonToggle('nerdtree')<CR>
```

## Options

`g:mutton_disable_keymaps` Set to 1 to disable the default keymaps.

`g:mutton_min_center_width` Force the middle (non-sidebar) window to have a minimum width. This setting is for the case where you are on a smaller screen with a bigger font, and want to open sidebars but no let the center window width go below 80 characters, for example. Note that you should include the width of the gutter in this value. I use the following in my vimrc:

```vim
let g:mutton_min_center_width = 88
```
