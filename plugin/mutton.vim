
if !exists('g:MuttonWidth')
  let g:MuttonWidth = &columns / 4
endif

"" Commands {{{1
command! MuttonToggle call MuttonToggle()

" SidebarEmptyToggle {{{2
function! MuttonToggle()
  if exists('g:MuttonEnabled') && g:MuttonEnabled = 1

    " Disable
    if exists('g:MuttonLeft') && g:MuttonLeft > 0
      execute bufwinnr(g:MuttonLeft).' wincmd c'
    endif
    if exists('g:MuttonRight') && g:MuttonRight > 0
      execute bufwinnr(g:MuttonRight).' wincmd c'
    endif
    let g:MuttonEnabled = 0
    highlight NonText ctermfg=0

  else

    " Enable
    if exists('b:MuttonWidth')
      let l:width = b:MuttonWidth
    else
      let l:width = g:MuttonWidth
    endif

    if a:position == 'left'
      execute 'silent topleft vertical '.l:width.' split [[MuttonLeft]]'
      let g:MuttonLeft = bufnr('')
    elseif a:position == 'right'
      execute 'silent vertical '.l:width.' split [[MuttonRight]]'
      let g:MuttonRight = bufnr('')
    endif

    setlocal winfixwidth nonumber norelativenumber nomodifiable
    set filetype=sidebar
    setlocal statusline=\ 
    set buftype=nofile
    set nobuflisted
    let g:MuttonEnabled = 1
    highlight NonText ctermfg=8

  endif
endfunction
