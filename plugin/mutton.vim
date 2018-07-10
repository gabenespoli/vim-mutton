" Name:     Vim Mutton
" Author:   Gabriel A. Nespoli <gabenespoli@gmail.com>

" Commands {{{1
command! MuttonToggle call MuttonToggle()
command! MuttonTagbarToggle call MuttonTagbarToggle()
command! MuttonSplit call MuttonSplit()
command! MuttonEnabled call MuttonEnabled()

" TODO: autocmd WinLeave if mutton windows open resize them?

" Function MuttonToggle() {{{1
function! MuttonToggle()
  if MuttonEnabled()
    call MuttonCloseAll()
  else
    call MuttonOn()
  endif
endfunction

" Function MuttonOn() {{{1
function! MuttonOn()
  if winnr('$') == 1
    call MuttonOpen('left')
    call MuttonOpen('right')
  elseif winnr('$') == 2
    " TODO: if winnr() is tagbar, we don't want it to be the center
    if winnr() == 1
      call MuttonOpen('left')
    else
      call MuttonOpen('right')
    endif
  endif
  call MuttonResize()
endfunction

" Function MuttonResize() {{{1
function! MuttonResize()
  let l:resize = 'vertical resize '.MuttonWidth()
  if winnr('$') == 3
    for i in [1, 3]
      execute i.' wincmd w'
      execute l:resize
    endfor
    2 wincmd w
  elseif winnr('$') == 2
    1 wincmd w
    if &filetype ==# 'mutton' || &filetype ==# 'tagbar'
      execute l:resize
    endif
  endif
endfunction

" Function MuttonOpen(side) {{{1
function! MuttonOpen(side)
  if a:side ==# 'left'
    let l:splitloc = 'topleft'
  else
    let l:splitloc = 'botright'
  endif
  let l:command = 'silent '.l:splitloc.' vertical '
  let l:bufnr = bufnr('[[Mutton]]')
  if l:bufnr > 0
    execute l:command.' sbuffer '.l:bufnr
  else
    execute 'noswapfile '.l:command.' split '.'[[Mutton]]'
    set filetype=mutton
    set buftype=nofile
  endif
  " execute 'vertical resize '.MuttonWidth()
  " setlocal winfixwidth
  setlocal nomodifiable 
  setlocal nonumber norelativenumber nocursorline nocursorcolumn
  set nobuflisted
  setlocal statusline=\ 
  augroup mutton
    au!
    autocmd BufEnter <buffer> call MuttonLastWindow()
  augroup END
  wincmd p
endfunction

" Function MuttonCloseAll() {{{1
function! MuttonCloseAll()
  let l:winnrs = MuttonWinnrs()
  while !empty(l:winnrs)
    execute l:winnrs[0].' wincmd c'
    let l:winnrs = MuttonWinnrs()
  endwhile
endfunction

" Function MuttonWinnrs() {{{1
function! MuttonWinnrs()
  let l:winids = win_findbuf(bufnr('[[Mutton]]'))
  let l:winnrs = map(l:winids, 'win_id2win(v:val)')
  return l:winnrs
endfunction

" Function MuttonLastWindow() {{{1
function! MuttonLastWindow()
  if &filetype ==# 'mutton'
    if winnr('$') == 1
      quit
    elseif winnr('$') == 2
      let l:bufnr = bufnr('[[Mutton]]')
      if winbufnr(1) == l:bufnr && winbufnr(2) == l:bufnr
        quitall
      endif
    endif
  endif
endfunction

" Function MuttonSplit() {{{1
function! MuttonSplit(...)
  if exists('g:MuttonEnabled') && g:MuttonEnabled == 1
    let l:mutton = 1
    MuttonToggle
  else
    let l:mutton = 0
  endif
  wincmd v
  if l:mutton
    " TODO: make this a BufHidden autocmd
    " but have to turn off the autocmd after it's hidden so that 
    " it doesn't stick to the buffer for the whole vim session
    " execute "nnoremap <buffer> q :quit<CR>:MuttonToggle<CR>"
    " autocmd BufHidden <buffer> execute ":autocmd! BufHidden <buffer><CR>:MuttonToggle<CR>"
  endif
endfunction

" Function MuttonTagbarToggle() {{{1
function! MuttonTagbarToggle()
  " get tagbar side
  " if winnr() == 2
    " let l:side = 'right'
  if exists('g:tagbar_left') && g:tagbar_left == 1
    let l:sidewinnr = 1
  else
    let l:sidewinnr = 3
  endif
  " let l:MuttonWinNr = s:MuttonWinNr(l:side)

  if exists('t:tagbar_buf_name') && bufwinnr(t:tagbar_buf_name) != -1
    " if tagbar is visible, close it
    if MuttonEnabled()
      execute bufwinnr(t:tagbar_buf_name).' wincmd w'
      execute 'buffer '.bufnr('[[Mutton]]')
      execute 'wincmd p'
    else
      let g:tagbar_width = MuttonWidth()
      execute 'TagbarToggle'
    endif

  else
    " if tagbar isn't visible, show it
    if MuttonEnabled()
      " close corresponding mutton window if visible
      if exists('g:tagbar_left') && g:tagbar_left == 1
        let l:sidewinnr = 1
      else
        let l:sidewinnr = 3
      endif
      execute l:sidewinnr.' wincmd c'
    endif
    let g:tagbar_width = MuttonWidth()
    execute 'TagbarToggle'
  endif
endfunction

" Function s:MuttonWinNr(side) {{{1
function! s:MuttonWinNr(side)
  if a:side ==# 'left'
    if exists('g:MuttonLeft') && g:MuttonLeft > 0
      return bufwinnr(g:MuttonLeft)
    else
      return -1
    endif
  elseif a:side ==# 'right'
    if exists('g:MuttonRight') && g:MuttonRight > 0
      return bufwinnr(g:MuttonRight)
    else
      return -1
    endif
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

" Function MuttonEnabled() {{{1
function! MuttonEnabled()
  if empty(win_findbuf(bufnr('[[Mutton]]')))
    return 0
  else
    return 1
  endif
endfunction

" TODO autocmd
" event WinNew: if mutton is enabled, disable it
" event WinNew,WinEnter,WinLeave call muttontoggle for sticky mutton
