
" TODO: don't hard code hi NonText colors

" Commands {{{1
command! MuttonToggle call MuttonToggle()
command! MuttonTagbarToggle call MuttonTagbarToggle()

" Function MuttonTagbarToggle() {{{1
function! MuttonTagbarToggle()
  " get tagbar side
  if exists('g:tagbar_left') && g:tagbar_left == 1
    let l:side = 'left'
  else
    let l:side = 'right'
  endif
  let l:MuttonWinNr = s:MuttonWinNr(l:side)

  if exists('t:tagbar_buf_name') && bufwinnr(t:tagbar_buf_name) != -1
    " if tagbar is visible, close it
    if exists('g:MuttonEnabled') && g:MuttonEnabled == 1
      " if mutton is enabled, switch to 
      execute bufwinnr(t:tagbar_buf_name).' wincmd w'
      if l:side == 'left'
        execute 'buffer '.g:MuttonLeft
      elseif l:side == 'right'
        execute 'buffer '.g:MuttonRight
      endif
      " move away from empty mutton window
      execute 'wincmd p'
    else
      let g:tagbar_width = MuttonWidth()
      execute 'TagbarToggle'
    endif

  else
    " if tagbar isn't visible, show it
    if l:MuttonWinNr != -1
      " close corresponding mutton window if visible
      execute l:MuttonWinNr.' wincmd c'
    endif
    let g:tagbar_width = MuttonWidth()
    execute 'TagbarToggle'
  endif
endfunction

" Function MuttonWidth() {{{1
function! MuttonWidth()
  if exists('b:MuttonWidth')
    let l:width = b:MuttonWidth
  elseif exists('g:MuttonWidth')
    let l:width = g:MuttonWidth
  else
    let l:width = &columns / 4
  endif
  return l:width
endfunction

" Function MuttonToggle() {{{1
function! MuttonToggle()
  if exists('g:MuttonEnabled') && g:MuttonEnabled == 1

    " Disable
    if s:MuttonWinNr('left') != -1
      execute bufwinnr(g:MuttonLeft).' wincmd c'
    endif
    if s:MuttonWinNr('right') != -1
      execute bufwinnr(g:MuttonRight).' wincmd c'
    endif
    let g:MuttonEnabled = 0

  else

    let l:width = MuttonWidth()

    " close tagbar first
    if exists('t:tagbar_buf_name') && bufwinnr(t:tagbar_buf_name) != -1
      execute 'TagbarClose'
      let l:do_tagbar = 1
    else
      let l:do_tagbar = 0
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

    if l:do_tagbar
      execute 'MuttonTagbarToggle'
    endif

  endif
endfunction

" Function s:MuttonSetBufferOptions() {{{1
function! s:MuttonSetBufferOptions()
  setlocal winfixwidth nonumber norelativenumber nomodifiable
  set filetype=mutton
  set buftype=nofile
  set nobuflisted
  setlocal statusline=\ 
  autocmd BufEnter <buffer> call MuttonLastWindow()
endfunction

" Function MuttonLastWindow() {{{1
function! MuttonLastWindow()
  if &filetype=="mutton"
    if winbufnr(2) == -1 " last window open
      quit
    elseif winbufnr(3) == -1 " two windows open
      let l:nrs = [g:MuttonLeft, g:MuttonRight]
      if index(l:nrs, winbufnr(1)) != -1 && index(l:nrs, winbufnr(2)) != -1
        quitall
      endif
    endif
  endif
endfunction

" Function s:MuttonWinNr(side) {{{1
function! s:MuttonWinNr(side)
  if a:side == 'left'
    if exists('g:MuttonLeft') && g:MuttonLeft > 0
      return bufwinnr(g:MuttonLeft)
    else
      return -1
    endif
  elseif a:side == 'right'
    if exists('g:MuttonRight') && g:MuttonRight > 0
      return bufwinnr(g:MuttonRight)
    else
      return -1
    endif
  endif
endfunction
