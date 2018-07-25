" Name:     Vim Mutton
" Author:   Gabriel A. Nespoli <gabenespoli@gmail.com>

if exists('g:loaded_mutton')
  finish
endif
let g:loaded_mutton = 1

" Initialize some variables {{{1
let g:mutton_visible = {'left': '', 'right': ''}
let g:mutton_enabled = {'left': 0, 'right': 0}

" this doesn't get initalized until buffergator is called for the first time
if !exists('g:buffergator_viewport_split_policy')
  let g:buffergator_viewport_split_policy = 'L'
endif

" Commands & Keymaps {{{1
command! -nargs=? MuttonToggle call MuttonToggle(<args>)

if !exists('g:mutton_disable_keymaps') || g:mutton_disable_keymaps == 1
  nnoremap <silent> <C-w><C-e>  :MuttonToggle<CR>
  nnoremap <silent> <C-w>eh     :MuttonToggle('left')<CR>
  nnoremap <silent> <C-w>el     :MuttonToggle('right')<CR>
endif

" Function MuttonToggle() {{{1
" call with no input or 'both' to toggle both sides on/off
" call with 'left' or 'right' to toggle one side only
" call with function to open that sidebar
function! MuttonToggle(...)
  let l:mutton_visible = {'left': '', 'right': ''}
  if a:0 == 0 || a:1 ==# 'both'
    if g:mutton_enabled['left'] || g:mutton_enabled['right']
      let g:mutton_enabled['left'] = 0
      let g:mutton_enabled['right'] = 0
    else
      let g:mutton_enabled['left'] = 1
      let g:mutton_enabled['right'] = 1
    endif

  elseif a:1 ==# 'left' || a:1 ==# 'right'
    if g:mutton_enabled[a:1]
      let g:mutton_enabled[a:1] = 0
    else
      let g:mutton_enabled[a:1] = 1
    endif

  elseif a:1 ==# 'tagbar'
    if g:tagbar_left
      let l:mutton_visible['left'] = 'tagbar'
    else
      let l:mutton_visible['right'] = 'tagbar'
    endif

  elseif a:1 ==# 'nerdtree'
    let l:mutton_visible[g:NERDTreeWinPos] = 'nerdtree'

  elseif a:1 ==# 'buffergator'
    if g:buffergator_viewport_split_policy ==# 'L'
      let l:mutton_visible['left'] = 'buffergator'
    elseif g:buffergator_viewport_split_policy ==# 'R'
      let l:mutton_visible['right'] = 'buffergator'
    else
      echo 'For mutton, buffergator_viewport_split_policy must be L or R'
    endif

  endif

  call MuttonRefresh(l:mutton_visible)
endfunction

" Function MuttonRefresh(mutton_visible) {{{1
" - a:mutton_visible is what you want it to be; empty means no change from
"     what g:mutton_visible is
" - g:mutton_visible is the current state of affairs (but we should probably
"     check them to make sure the user hasn't done anything that mutton
"     doesn't know about)
" - g:mutton_enabled is whether blank should be opened if there is no sidebar
function! MuttonRefresh(mutton_visible)
  for side in ['left', 'right']
    let l:desired = a:mutton_visible[side]
    let l:current = g:mutton_visible[side]
    let l:blank = g:mutton_enabled[side]

    " if you want something different, change it
    if !empty(l:desired) 
      if l:desired !=# l:current
        call MuttonClose(side)
        call MuttonOpenPlugin(l:desired)
        let g:mutton_visible[side] = l:desired
      elseif l:desired ==# l:current
        call MuttonClose(side)
        let g:mutton_visible[side] = ''
      endif
    endif

    " cleanup blanks
    let l:current = g:mutton_visible[side]
    if l:blank == 1 && empty(l:current)
      call MuttonOpenBlank(side)
      let g:mutton_visible[side] = 'blank'
    elseif l:blank == 0 && l:current ==# 'blank'
      call MuttonClose(side)
      let g:mutton_visible[side] = ''
    endif

  endfor
endfunction

" Function MuttonClose(side) {{{1
" has to handle both plugins and mutton blank sidebars
function! MuttonClose(side)
  if g:mutton_visible[a:side] ==# 'blank'
    if a:side ==# 'left'
      execute '1 wincmd c'
    else
      execute '$ wincmd c'
    endif
  elseif g:mutton_visible[a:side] ==# 'tagbar'
    TagbarClose
  elseif g:mutton_visible[a:side] ==# 'nerdtree'
    NERDTreeClose
  elseif g:mutton_visible[a:side] ==# 'buffergator'
    BuffergatorClose
  endif
endfunction

" Function MuttonOpenPlugin(name) {{{1
" only handles plugins, not blank mutton sidebars
function! MuttonOpenPlugin(name)
  if a:name ==# 'tagbar'
    let g:tagbar_width = MuttonWidth()
    TagbarOpen
  elseif a:name ==# 'nerdtree'
    let g:NERDTreeWinSize = MuttonWidth()
    if !empty(expand('%'))
      NERDTreeFind
    else
      NERDTreeToggle
    endif
  elseif a:name ==# 'buffergator'
    let g:buffergator_vsplit_size = MuttonWidth()
    " TODO: use global mutton var to specify desired buffergator side?
    " or maybe do this in cider vinegar instead?
    " then we would have to save current val, change it, open buffergator,
    "   then change it back
    BuffergatorOpen
  endif
endfunction

" Function MuttonOpenBlank(side) {{{1
" accepts a count for the width of the window
" side input arg is required
" doesn't open if there is a sidebar there already
function! MuttonOpenBlank(side)
  " if g:mutton_visible[a:side] ==# 'blank'
  "   return
  " endif

  if a:side ==# 'left'
    let l:splitloc = 'topleft'
  else
    let l:splitloc = 'botright'
  endif
  let l:command = 'silent '.l:splitloc.' vertical '

  " if buffer already exists, just open it, else create it
  let l:bufnr = bufnr('[[Mutton]]')
  if l:bufnr > 0
    execute l:command.' sbuffer '.l:bufnr
  else
    execute 'noswapfile '.l:command.' split '.'[[Mutton]]'
    set filetype=mutton
    set buftype=nofile
  endif

  " set window and buffer options
  let l:width = MuttonWidth()
  " if v:count == 0
  "   let l:width = MuttonWidth()
  " else
  "   let l:width = v:count
  " endif
  execute 'vertical resize '.l:width
  set winfixwidth
  set nobuflisted
  setlocal nomodifiable 
  setlocal nonumber norelativenumber nocursorline nocursorcolumn
  setlocal statusline=\ 

  " automatically close mutton windows if they are the only open windows
  augroup mutton
    au!
    autocmd BufEnter <buffer> call MuttonLastWindow()
  augroup END

  wincmd p
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


" Function MuttonWidth() {{{1
function! MuttonWidth()
  if exists('b:MuttonWidth')
    let l:width = b:MuttonWidth
  elseif exists('g:MuttonWidth')
    let l:width = g:MuttonWidth
  else
    let l:width = &columns / 4
  endif
  if exists('g:mutton_min_center_width')
        \ && g:mutton_min_center_width > 0
    if (&columns - (l:width * 2)) < g:mutton_min_center_width 
      let l:width = (&columns - g:mutton_min_center_width) / 2
    endif
  endif
  return l:width
endfunction
