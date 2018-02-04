# mutton.vim

Add mutton chops to vim. Center a window on the screen by opening empty windows
on either side. Eventually, use these windows to display the windows of various
plugins. Currently only supports [Tagbar](https://github.com/majutsushi/tagbar).

## Installation

vim-plug: `Plug gabenespoli/vim-mutton`

## Commands

`MuttonToggle`
`MuttonTagbarToggle`: Toggle Tagbar, respecting the state of Mutton.

## Recommended Keybindings

```vim
nmap <leader>m :MuttonToggle<CR>
nmap <leader>t :MuttonTagbarToggle<CR>
```

