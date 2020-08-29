" vim: set foldmethod=marker:

if &compatible
  " vint: -ProhibitSetNoCompatible
  set nocompatible
  " vint: +ProhibitSetNoCompatible
endif

" =============================================================================
" Vim Plug: {{{
" =============================================================================

" Define the 'vimrc' autocmd group
augroup vimrc
autocmd!
augroup END

autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

" Pathogen load
filetype off

execute pathogen#infect()
execute pathogen#helptags()

filetype plugin indent on
syntax on

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
function! SyntasticCheckHook(errors)
  if !empty(a:errors)
    let g:syntastic_loc_list_height = min([len(a:errors), 5])
  endif
endfunction
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" }}}
" =============================================================================
" General: {{{
" =============================================================================

if &shell =~# 'fish$'
  set shell=sh
endif
if has('gui_running')
  language messages en
  if has('multi_byte')
    set encoding=utf-8
    scriptencoding utf-8
  endif
endif
set autoread
set background=dark
set backspace=indent,eol,start
" Use the clipboard register '*'
set clipboard=unnamed
if has('unnamedplus')
  " Use X11 CLIPBOARD selection
  set clipboard=unnamedplus
endif
" How keyword completion works when CTRL-P and CTRL-N are used
" i: scan current and included files
set complete-=i
if has('patch-8.1.0360')
  set diffopt+=algorithm:patience
endif
if has('multi_byte')
  set fileencodings=ucs-bom,utf-8,cp949,latin1
endif
set fileformats=unix,mac,dos
if has('folding')
  " Sets 'foldlevel' when starting to edit another buffer in a window
  set foldlevelstart=99
endif
" Number of remembered ":" commands
set history=1000
" Ignore case in search
set ignorecase
if has('extra_search')
  " Show where the pattern while typing a search command
  set incsearch
endif
" Don't make a backup before overwriting a file
set nobackup
if exists('+fixendofline')
  " When writing a file and this option is on, <EOL> at the end of file will be
  " restored if missing
  set nofixendofline
endif
" Override the 'ignorecase' if the search pattern contains upper case
set smartcase
" Don't redraw the screen while executing macros, registers and other commands
" that have not been typed
set lazyredraw
" Enable list mode
set list
" Strings to use in 'list' mode and for the :list command
try
  set listchars=tab:→\ ,trail:·,extends:»,precedes:«,nbsp:~
catch /^Vim\%((\a\+)\)\=:E474/
  set listchars=tab:>\ ,trail:_,extends:>,precedes:<,nbsp:~
endtry
" The key sequence that toggles the 'paste' option
set pastetoggle=<F2>
if has('mksession')
  " Changes the effect of the :mksession command
  set sessionoptions-=buffers " hidden and unloaded buffers
endif
" Help to avoid all the hit-enter prompts caused by file messages and to avoid
" some other messages
" m: use "[+]" instead of "[Modified]"
" r: use "[RO]" instead of "[readonly]"
" c: don't give ins-completion-menu messages
" S: do not show search count message when searching, e.g. "[1/5]"
set shortmess+=m
set shortmess+=r
set shortmess+=c
if has('patch-8.1.1270')
  set shortmess-=S
endif
" Exclude East Asian characters from spell checking
set spelllang-=cjk
set spelllang+=cjk
" Files with these suffixes get a lower priority when multiple files match a
" wildcard
set suffixes+=.git,.hg,.svn
set suffixes+=.bmp,.gif,.jpeg,.jpg,.png
set suffixes+=.dll,.exe
set suffixes+=.swo
set suffixes+=.DS_Store
set suffixes+=.pyc
" Filenames for the tag command, separated by spaces or commas
if has('path_extra')
  set tags-=./tags
  set tags-=./tags;
  set tags^=./tags;
endif
" Maximum number of changes that can be undone
set undolevels=1000
" Update swap file and trigger CursorHold after 1 second
set updatetime=100
if exists('+wildignorecase')
  " Ignore case when completing file names and directories
  set wildignorecase
endif
if has('wildmenu')
  " Enhanced command-line completion
  set wildmenu
endif

if has('win32')
  if exists('+completeslash')
    " A forward slash is used for path completion in insert mode
    set completeslash=slash
  else
    " Use a forward slash when expanding file names
    set shellslash
  endif
endif

" C
let g:c_comment_strings = 1

" Rust
if executable('rustfmt')
  let g:rustfmt_autosave = 1
endif

" TeX
let g:tex_conceal = 'abdmg'
let g:tex_flavor = 'latex'

" }}}
" =============================================================================
" Vim UI: {{{
" =============================================================================

" Show as much as possible of the last line
set display+=lastline
" Show unprintable characters as a hex number
set display+=uhex
if has('extra_search')
  set hlsearch
endif
" Always show a status line
set laststatus=2
set number
" Don't consider octal number when using the CTRL-A and CTRL-X commands
set nrformats-=octal
set scrolloff=3
if has('cmdline_info')
  " Show command in the last line of the screen
  set showcmd
endif
" Briefly jump to the matching one when a bracket is inserted
set showmatch
" The minimal number of columns to scroll horizontally
set sidescroll=1
set sidescrolloff=10
if has('windows')
  set splitbelow
endif
if has('vertsplit')
  set splitright
endif
" :help xterm-true-color
if $TERM =~# '^screen'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors

augroup colorcolumn
  autocmd!
  if exists('+colorcolumn')
    " Highlight column after 'textwidth'
    set colorcolumn=+1
  else
    autocmd BufWinEnter *
          \ let w:m2 = matchadd('ErrorMsg', '\%' . (&textwidth + 1) . 'v', -1)
  endif
augroup END

" Highlight trailing whitespace
function! s:MatchExtraWhitespace(enabled)
  if a:enabled && index(['GV', 'vim-plug'], &filetype) < 0
    match ExtraWhitespace /\s\+$/
  else
    match ExtraWhitespace //
  endif
endfunction
highlight ExtraWhitespace ctermbg=red guibg=red
augroup ExtraWhitespace
  autocmd!
  autocmd BufWinEnter * call s:MatchExtraWhitespace(1)
  autocmd FileType * call s:MatchExtraWhitespace(1)
  autocmd InsertEnter * call s:MatchExtraWhitespace(0)
  autocmd InsertLeave * call s:MatchExtraWhitespace(1)
  if v:version >= 702
    autocmd BufWinLeave * call clearmatches()
  endif
augroup END
highligh Normal ctermfg=grey ctermbg=black
hi Normal ctermbg=NONE

colorscheme nightfly

" }}}
" =============================================================================
" GUI: {{{
" =============================================================================

if has('gui_running')
  set guifont=Consolas:h10:cANSI
  set guioptions-=m " Menu bar
  set guioptions-=T " Toolbar
  set guioptions-=r " Right-hand scrollbar
  set guioptions-=L " Left-hand scrollbar when window is vertically split

  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim

  if has('win32')
    set guifontwide=D2Coding:h10:cDEFAULT,
          \NanumGothicCoding:h10:cDEFAULT,
          \DotumChe:h10:cDEFAULT
  endif

  function! s:ScreenFilename()
    if has('amiga')
      return 's:.vimsize'
    elseif has('win32')
      return $HOME . '\_vimsize'
    else
      return $HOME . '/.vimsize'
    endif
  endfunction
  function! s:ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let l:f = s:ScreenFilename()
    if has('gui_running') && g:screen_size_restore_pos && filereadable(l:f)
      let l:vim_instance =
            \ (g:screen_size_by_vim_instance == 1 ? (v:servername) : 'GVIM')
      for l:line in readfile(l:f)
        let l:sizepos = split(l:line)
        if len(l:sizepos) == 5 && l:sizepos[0] == l:vim_instance
          silent! execute 'set columns=' . l:sizepos[1] .
                \ ' lines=' . l:sizepos[2]
          silent! execute 'winpos ' . l:sizepos[3] . ' ' . l:sizepos[4]
          return
        endif
      endfor
    endif
  endfunction
  function! s:ScreenSave()
    " Save window size and position.
    if has('gui_running') && g:screen_size_restore_pos
      let l:vim_instance =
            \ (g:screen_size_by_vim_instance == 1 ? (v:servername) : 'GVIM')
      let l:data = l:vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx() < 0 ? 0: getwinposx()) . ' ' .
            \ (getwinposy() < 0 ? 0: getwinposy())
      let l:f = s:ScreenFilename()
      if filereadable(l:f)
        let l:lines = readfile(l:f)
        call filter(l:lines, "v:val !~ '^" . l:vim_instance . "\\>'")
        call add(l:lines, l:data)
      else
        let l:lines = [l:data]
      endif
      call writefile(l:lines, l:f)
    endif
  endfunction
  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  augroup ScreenRestore
    autocmd!
    autocmd VimEnter *
          \ if g:screen_size_restore_pos == 1 |
          \   call s:ScreenRestore() |
          \ endif
    autocmd VimLeavePre *
          \ if g:screen_size_restore_pos == 1 |
          \   call s:ScreenSave() |
          \ endif
  augroup END
endif

" }}}
" =============================================================================
" Text Formatting: {{{
" =============================================================================

set autoindent
if has('cindent')
  set cindent
endif
set expandtab
" Insert only one space after a '.', '?' and '!' with a join command
set nojoinspaces
" Number of spaces that a <Tab> counts for while editing
set softtabstop=2
" Number of spaces to use for each setp of (auto)indent
set shiftwidth=2
" Number of spaces that a <Tab> in the file counts for
set tabstop=8
" Maximum width of text that is being inserted
set textwidth=80
autocmd vimrc FileType c,cpp,java,json,markdown,perl,python
      \ setlocal softtabstop=4 shiftwidth=4
autocmd vimrc FileType asm,gitconfig,kconfig
      \ setlocal noexpandtab softtabstop=8 shiftwidth=8
autocmd vimrc FileType make
      \ let &l:shiftwidth = &l:tabstop
autocmd vimrc FileType go
      \ setlocal noexpandtab softtabstop=4 shiftwidth=4 tabstop=4
" t: Auto-wrap text using textwidth
" c: Auto-wrap comments using textwidth
" r: Automatically insert the current comment leader after hitting <Enter> in
"    Insert mode
" o: Automatically insert the current comment leader after hitting 'o' or 'O' in
"    Normal mode
" q: Allow formatting of comments with "gq"
" l: Long lines are not broken in insert mode
" j: Remove a comment leader when joining lines
autocmd vimrc FileType *
      \ setlocal formatoptions+=c
      \   formatoptions+=r
      \   formatoptions+=q
      \   formatoptions+=l |
      \ if &filetype ==# 'markdown' |
      \   setlocal formatoptions+=o |
      \ else |
      \   setlocal formatoptions-=o |
      \ endif |
      \ if index(['gitcommit', 'markdown', 'tex'], &filetype) < 0 |
      \   setlocal formatoptions-=t |
      \ endif |
      \ if v:version >= 704 || v:version == 703 && has('patch541') |
      \   setlocal formatoptions+=j |
      \ endif

" }}}
" =============================================================================
" Mappings: {{{
" =============================================================================

" Commander
nnoremap ; :

" We do line wrap
noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk
noremap gj j
noremap gk k

" Easy navigation on a line
noremap H ^
noremap L $

" Unix shell behavior
inoremap <C-A> <Esc>I
inoremap <C-E> <Esc>A
cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" Leave insert mode
function! s:CtrlL()
  " Keep the original feature of CTRL-L. See :help i_CTRL-L.
  if exists('&insertmode') && &insertmode
    call feedkeys("\<C-L>", 'n')
  else
    call feedkeys("\e", 't')
  endif
endfunction
inoremap <silent> <C-L> <C-O>:call <SID>CtrlL()<CR>

" Make Y behave like C and D
nnoremap Y y$

" Delete without copying
vnoremap <BS> "_d

" Break the undo block when CTRL-U
inoremap <C-U> <C-G>u<C-U>

if has('wildmenu')
  " Move into subdirectory in wildmenu
  function! s:WildmenuEnterSubdir()
    call feedkeys("\<Down>", 't')
    return ''
  endfunction
  cnoremap <expr> <C-J> <SID>WildmenuEnterSubdir()
endif

" Move cursor between splitted windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" Reselect visual block after shifting
vnoremap < <gv
vnoremap > >gv

" Use CTRL-N to clear the highlighting
nnoremap <silent> <C-N> :nohlsearch<C-R>=has('diff') ? '<Bar>diffupdate' : ''<CR><CR>

" Clear screen
nnoremap <Leader><C-L> <C-L>

" Search for visually selected text
function! s:VSearch(cmd)
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  normal! gvy
  let l:pat = escape(@", a:cmd . '\')
  let l:pat = substitute(l:pat, '\n', '\\n', 'g')
  let @/ = '\V' . l:pat
  normal! gV
  call setreg('"', l:old_reg, l:old_regtype)
endfunction
vnoremap * :<C-U>call <SID>VSearch('/')<CR>/<C-R>/<CR>
vnoremap # :<C-U>call <SID>VSearch('?')<CR>?<C-R>/<CR>

" Center display after searching
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Execute @q which is recorded by qq
nnoremap Q @q

" Zoom and restore window
function! s:ZoomToggle()
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  elseif tabpagewinnr(tabpagenr('$'), '$') > 1
    " Resize only when multiple windows are in the current tab page
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
nnoremap <silent> <Leader>z :call <SID>ZoomToggle()<CR>

" Cscope mappings
if has('cscope')
  function! s:FindCscopeDB()
    let l:db = findfile('cscope.out', '.;')
    if !empty(l:db)
      silent cscope reset
      silent! execute 'cscope add' l:db
    elseif !empty($CSCOPE_DB)
      silent cscope reset
      silent! execute 'cscope add' $CSCOPE_DB
    endif
  endfunction

  set cscopetag
  set cscopetagorder=0
  set cscopeverbose
  call s:FindCscopeDB()

  " 0 or s: Find this C symbol
  " 1 or g: Find this definition
  " 2 or d: Find functions called by this function
  " 3 or c: Find functions calling this function
  " 4 or t: Find this text string
  " 6 or e: Find this egrep pattern
  " 7 or f: Find this file
  " 8 or i: Find files #including this file
  " 9 or a: Find places where this symbol is assigned a value
  nnoremap <C-\>s :cscope find s <C-R>=expand('<cword>')<CR><CR>
  nnoremap <C-\>g :cscope find g <C-R>=expand('<cword>')<CR><CR>
  nnoremap <C-\>d :cscope find d <C-R>=expand('<cword>')<CR><CR>
  nnoremap <C-\>c :cscope find c <C-R>=expand('<cword>')<CR><CR>
  nnoremap <C-\>t :cscope find t <C-R>=expand('<cword>')<CR><CR>
  xnoremap <C-\>t y:cscope find t <C-R>"<CR>
  nnoremap <C-\>e :cscope find e <C-R>=expand('<cword>')<CR><CR>
  nnoremap <C-\>f :cscope find f <C-R>=expand('<cfile>')<CR><CR>
  nnoremap <C-\>i :cscope find i ^<C-R>=expand('<cfile>')<CR>$<CR>
  nnoremap <C-\>a :cscope find a <C-R>=expand('<cword>')<CR><CR>
endif

function! s:RemapBufferQ()
  nnoremap <buffer> q :q<CR>
endfunction

augroup vimrc
  " Quit help, quickfix window
  autocmd FileType help,qf call s:RemapBufferQ()

  " Quit preview window
  autocmd BufEnter *
        \ if &previewwindow |
        \   call s:RemapBufferQ() |
        \ endif

  " C, C++ compile
  autocmd FileType c,cpp nnoremap <buffer> <F5> :w<CR>:make %<CR>
  autocmd FileType c,cpp inoremap <buffer> <F5> <Esc>:w<CR>:make %<CR>
  autocmd FileType c
        \ if !filereadable('Makefile') && !filereadable('makefile') |
        \   setlocal makeprg=gcc\ -o\ %< |
        \ endif
  autocmd FileType cpp
        \ if !filereadable('Makefile') && !filereadable('makefile') |
        \   setlocal makeprg=g++\ -o\ %< |
        \ endif

  " Markdown code snippets
  autocmd FileType markdown inoremap <buffer> <LocalLeader>` ```

  " Go
  autocmd FileType go nnoremap <buffer> <F5> :w<CR>:!go run %<CR>
  autocmd FileType go inoremap <buffer> <F5> <Esc>:w<CR>:!go run %<CR>

  " Python
  autocmd FileType python nnoremap <buffer> <F5> :w<CR>:!python %<CR>
  autocmd FileType python inoremap <buffer> <F5> <Esc>:w<CR>:!python %<CR>

  " Ruby
  autocmd FileType ruby nnoremap <buffer> <F5> :w<CR>:!ruby %<CR>
  autocmd FileType ruby inoremap <buffer> <F5> <Esc>:w<CR>:!ruby %<CR>
augroup END

" File execution
if has('win32')
  nnoremap <F6> :!%<.exe<CR>
  inoremap <F6> <Esc>:!%<.exe<CR>
elseif has('unix')
  nnoremap <F6> :!./%<<CR>
  inoremap <F6> <Esc>:!./%<<CR>
endif


augroup vimrc
  " Reload vimrc on the fly
  autocmd BufWritePost $MYVIMRC nested source $MYVIMRC

  " Automatically update the diff after writing changes
  autocmd BufWritePost * if &diff | diffupdate | endif

  " Exit Paste mode when leaving Insert mode
  autocmd InsertLeave * set nopaste

  " Check if any buffers were changed outside of Vim
  autocmd FocusGained,BufEnter * checktime

  " Keyword lookup program
  autocmd FileType c,cpp setlocal keywordprg=man
  autocmd FileType gitconfig
        \ setlocal keywordprg=man\ git-config\ \|\ less\ -i\ -p
  autocmd FileType help,vim setlocal keywordprg=:help
  autocmd FileType ruby setlocal keywordprg=ri

  " Plain view for plugins
  autocmd FileType GV,vim-plug
        \ setlocal colorcolumn= nolist textwidth=0

  " Remeber previous line
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
        \ exe "normal! g'\"" | endif

  " Ruby configuration files view
  autocmd BufNewFile,BufRead Gemfile,Guardfile setlocal filetype=ruby

  " ASM view
  autocmd BufNewFile,BufRead *.S setlocal filetype=gas

  " Gradle view
  autocmd BufNewFile,BufRead *.gradle setlocal filetype=groovy

  " LD script view
  autocmd BufNewFile,BufRead *.lds setlocal filetype=ld

  " Markdown view
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown

  " mobile.erb view
  autocmd BufNewFile,BufRead *.mobile.erb
        \ let b:eruby_subtype = 'html' |
        \ setlocal filetype=eruby

  " zsh-theme view
  autocmd BufNewFile,BufRead *.zsh-theme setlocal filetype=zsh
augroup END

" Auto insert for git commit
let s:gitcommit_insert = 0
augroup gitcommit_insert
  autocmd!
  autocmd FileType gitcommit
        \ if byte2line(2) == 2 |
        \   let s:gitcommit_insert = 1 |
        \ endif
  autocmd VimEnter *
        \ if (s:gitcommit_insert) |
        \   startinsert |
        \ endif
augroup END

" Reload symlink of vimrc on the fly
let s:resolved_vimrc = resolve(expand($MYVIMRC))
if expand($MYVIMRC) !=# s:resolved_vimrc
  execute 'autocmd vimrc BufWritePost ' . s:resolved_vimrc .
        \ ' nested source $MYVIMRC'
endif
unlet s:resolved_vimrc

