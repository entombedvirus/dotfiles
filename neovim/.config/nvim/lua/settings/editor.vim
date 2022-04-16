augroup editor_settings_user_config
    autocmd!
    autocmd BufWritePost editor.vim source <afile> | redraw
augroup end
" nnoremap <leader>rv :source $MYVIMRC<cr>

" disable the built-in showing of mode in the command bar since airline will
" take care of that
set noshowmode
set noruler

" show both absolute current line no and relative numbers
set relativenumber number

" for letting swtich away from a modified buffer w/o warning
set hidden

" for highlighting search word
set hlsearch

" always show gitgutter col so text doesn't jump around when they come in
set signcolumn=yes

" Use the same symbols as TextMate for tabstops and EOLs
"set listchars=tab:▸\ ,eol:¬
set listchars=tab:»\ ,eol:¬

" Show invisible chars
set list

set title

" Always show the status line (even if no split windows)
set laststatus=2
" set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P

" Number of lines to keep between cursor and window boundary before scrolling
" kicks in.
set scrolloff=7
" Number of lines to jump when scrolling. Improves rendering speed
set scrolljump=5

" don't leave hardtabs
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

" highlight the current line
" 2016-01-32: disabling this since it slows down rendering
" set cursorline

" turn mouse on
set mouse=a
" set ttymouse=xterm2

" persistent undo file
set undofile
" the "//" at the end of each directory means that file names will be built
" from the complete path to the file with all path separators substituted to
" percent "%" sign. This will ensure file name uniqueness in the preserve
" directory.
set undodir=~/.tmp/neovim/.undo//
set backup
set writebackup
set backupdir=~/.tmp/.neovim/backup//
set directory=~/.tmp/.neovim/swp//
silent execute '!mkdir -p ' . &undodir . ' ' . &backupdir . ' ' &directory

" folding settings
set foldmethod=indent
set foldlevelstart=20

" misc
"set ai
set incsearch
set nowrapscan
set nowrap

" default is 4000 (4s), which is too long to wait to trigger events
" like "CursorHold"
set updatetime=300

set wildignore+=*.pyc,*.o,*.a,*.clj

" sync to system clipboard
set clipboard=unnamedplus

" For conceal markers.
if has('conceal')
    " hide concealed chars, except in insert, visual and command modes
    set conceallevel=2 concealcursor=n
endif

" prevent "Press enter to continue" message on auto type info
set cmdheight=2
set showtabline=2

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --ignore=html\ --ignore=js\ --ignore=css\ --ignore=clj/\ --ignore=vendor/\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
endif

if executable('rg')
  " Use ripgrep over grep
  set grepprg=rg\ --type-not=html\ --type-not=js\ --type-not=css\ --type-not=clojure\ --glob=\"\!vendor/\*\"\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
endif

" jump to beginning of line
nnoremap H ^
xnoremap H ^

" jump to end of line
nnoremap L $
xnoremap L $

" emulate vim-surround's aliases:
" r -> [ ]
vmap ar :<c-u>normal va]<cr>
omap ar :normal va]<cr>
vmap ir :<c-u>normal vi]<cr>
omap ir :normal vi]<cr>
" a -> < >
vmap aa :<c-u>normal va><cr>
omap aa :normal va><cr>
vmap ia :<c-u>normal vi><cr>
omap ia :normal vi><cr>

" destroy add buffers
nnoremap <leader>bd :bufdo bd<cr>

" CTRL-C doesn't trigger the InsertLeave autocmd. map to <ESC> instead.
inoremap <silent> <c-c> <ESC>

" start profile
nnoremap <leader>pr :profile start /tmp/profile.log<cr>:profile func *<cr>:profile file *<cr>

" quickfix nav
" default python plugin maps these to something else
let g:no_python_maps = 1
nnoremap [] :cclose<cr>
nnoremap ][ :copen<cr>

" location list nav
nnoremap () :lclose<cr>
nnoremap )( :lopen<cr>

" tab pages
nnoremap <leader>]t :tabnew<cr>
nnoremap <leader>]c :tabclose<cr>

" For vim-workspace
nnoremap <leader>S :mksession! /tmp/sess.vim<CR>:qa<CR>

" quick save
noremap <leader>s :write<cr>

" cycle between buffers faster
nnoremap <Tab><Tab> <C-W>w

" Common typos
command! Q  quit
command! W  write
command! Wq wq
command! Cq cq

" Some emacs keybindings thats used all over OS X
" delete one char in front
inoremap <C-d> <Delete>

" jump to start and end of line in insert mode
inoremap <C-a> <C-o>I
inoremap <C-e> <C-o>A

" move one char left or right while in insert mode
inoremap <C-f> <C-o>l
" conflicts with delete char
" inoremap <C-d> <C-o>h

" Automatically strip trailing whitespace
augroup strip_whitespace
    autocmd!
    autocmd BufWritePre * if exists(":StripWhitespace") | exe "StripWhitespace" | endif
augroup END

" Auto-detect git commit messages
augroup git_commit_msg
    autocmd!
    autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=gitcommit
augroup END

" yaml indentation
autocmd FileType yaml setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

" delete all hidden buffers
command! CloseHiddenBuffers call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete ".num
    endif
  endfor
endfunction

" reformat JSON
map <leader>jt  <Esc>:%!jq<CR>
