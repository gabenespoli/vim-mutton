
command! MuttonToggle call MuttonToggle()

function! MuttonToggle()
  if exists('g:MuttonEnabled') && g:MuttonEnabled == 1

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

    if exists('b:MuttonWidth')
      let l:width = b:MuttonWidth
    elseif exists('g:MuttonWidth')
      let l:width = g:MuttonWidth
    else
      let l:width = &columns / 4
    endif

    execute 'silent topleft vertical '.l:width.' split [[MuttonLeft]]'
    let g:MuttonLeft = bufnr('')
    call s:MuttonSetBufferOptions()
    wincmd p

    execute 'silent vertical '.l:width.' split [[MuttonRight]]'
    let g:MuttonRight = bufnr('')
    call s:MuttonSetBufferOptions()
    wincmd p

    let g:MuttonEnabled = 1
    highlight NonText ctermfg=8

  endif
endfunction

function! s:MuttonSetBufferOptions()
  setlocal winfixwidth nonumber norelativenumber nomodifiable
  set filetype=sidebar
  setlocal statusline=\ 
  set buftype=nofile
  set nobuflisted
endfunction
