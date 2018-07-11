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

`MuttonToggle`: Toggle Mutton.

`MuttonToggle('left')` and `MuttonToggle('right')`: Toggle Mutton on the left or right side only.

`MuttonTagbarToggle`: Toggle Tagbar, respecting the state of Mutton.

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

A [Tagbar](https://github.com/majutsushi/tagbar) toggle keymap is not enabled by default. I use the following in my vimrc:

```vim
nmap <leader>t :MuttonTagbarToggle<CR>
```

## Options

`g:MuttonDisableKeymaps` Set to 1 to disable the default keymaps.
