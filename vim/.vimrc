if &compatible
  set nocompatible
endif

" Bootstrap Plug
try
    let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
catch /E117/
    let autoload_plug_path = expand('~/.vim/autoload/plug.vim')
endtry

if !filereadable(autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path

call plug#begin('~/.vim/plugins/plugged')

" Navigation
Plug 'mileszs/ack.vim'
Plug 'justinmk/vim-dirvish'
Plug 'tweekmonster/fzf-filemru'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'rbtnn/vim-jumptoline'

" Git
"Plug 'airblade/vim-gitgutter'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" react / js
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Appearance
Plug 'frankier/neovim-colors-solarized-truecolor-only'
"Plug 'flazz/vim-colorschemes'
Plug 'justinmk/molokai'
Plug 'nanotech/jellybeans.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'morhetz/gruvbox'
Plug 'romainl/flattened'
Plug 'whatyouhide/vim-gotham'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rakr/vim-one'
Plug 'rakr/vim-two-firewatch'
Plug 'mhartington/oceanic-next'
Plug 'itchyny/lightline.vim'
Plug 'mgee/lightline-bufferline'
Plug 'joshdick/onedark.vim'
Plug 'KeitaNakamura/neodark.vim'
Plug 'neutaaaaan/iosvkem'
Plug 'chriskempson/base16-vim'
Plug 'ayu-theme/ayu-vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'NieTiger/halcyon-neovim'
Plug 'embark-theme/vim', { 'as': 'embark' }
Plug 'tiagovla/tokyodark.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'yashguptaz/calvera-dark.nvim'

" Linting
" using built-in based lsp
"Plug 'benekastah/neomake'

" Editing
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'michaeljsmith/vim-indent-object'
Plug 'coderifous/textobj-word-column.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'wellle/targets.vim'
Plug 'justinmk/vim-sneak'
Plug 'FooSoft/vim-argwrap'
Plug 'whiteinge/diffconflicts'
"Plug 'junegunn/vim-peekaboo' " shows register contents
Plug 'nelstrom/vim-visual-star-search' " search visual selected contents with '*' and '#'
Plug 'mg979/vim-visual-multi' " multiple cursors

" Jsonnet
Plug 'google/vim-jsonnet'

" Bazel
Plug 'bazelbuild/vim-ft-bzl'

" terminal
Plug 'voldikss/vim-floaterm'

" testing
Plug 'vim-test/vim-test'

" Initialize plugin system
call plug#end()

filetype plugin indent on
syntax enable

" vim-test config
nmap <silent> <leader>gtf :TestNearest<CR>
nmap <silent> <leader>gtl :TestLast<CR>
nmap <silent> <leader>gt :TestFile<CR>
" make test commands execute using dispatch.vim
let g:test#strategy = "floaterm"
" execute tests from package dir
let g:test#project_root = "%:h"

" vsnip config
" Jump forward or backward
imap <expr> <C-j>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-j>'
imap <expr> <C-k>   vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'
smap <expr> <C-j>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-j>'
smap <expr> <C-k>   vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'

" fzf-preview config
"
" disable MRU tracking inside fzf-preview by clearing the fzf_preview_mru
" group.  since it's slow and I don't use it. This can only be done until
" after the fzf_preview has been initialized, which is signaled by a User
" event.
let g:fzf_preview_disable_mru = 1

" colorscheme overrides. has to be before any colorscheme lines
augroup colorscheme_overrides
    autocmd!
    "autocmd ColorScheme * highlight Search cterm=underline ctermfg=217 ctermbg=16 gui=underline guifg=#f0a0c0 guibg=#302028
    autocmd ColorScheme * highlight Search cterm=underline ctermfg=217 ctermbg=NONE gui=italic guifg=#f0a0c0 guibg=NONE
    " comments should be ialic
    autocmd ColorScheme * highlight Comment cterm=italic gui=italic
    autocmd ColorScheme * highlight default link LspReferenceText Search
augroup END

" needed to make true colors work in TMUX and outside
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
colorscheme gruvbox
set background=dark

if has("gui")
    " Start without the toolbar
    set guioptions-=T
    " Start without the right toolbar
    set guioptions-=r
    set guioptions-=R
    " Start without the left toolbar
    set guioptions-=l
    set guioptions-=L
endif

if has("gui_macvim")
    "set guifont=Knack\ Nerd\ Font:h13
    set guifont="Iosevka Term Slab Light:h13"

    " Fullscreen takes up entire screen
    set fuoptions=maxhorz,maxvert

    " Map Command-# to switch tabs
    map  <D-0> 0gt
    imap <D-0> <Esc>0gt
    map  <D-1> 1gt
    imap <D-1> <Esc>1gt
    map  <D-2> 2gt
    imap <D-2> <Esc>2gt
    map  <D-3> 3gt
    imap <D-3> <Esc>3gt
    map  <D-4> 4gt
    imap <D-4> <Esc>4gt
    map  <D-5> 5gt
    imap <D-5> <Esc>5gt
    map  <D-6> 6gt
    imap <D-6> <Esc>6gt
    map  <D-7> 7gt
    imap <D-7> <Esc>7gt
    map  <D-8> 8gt
    imap <D-8> <Esc>8gt
    map  <D-9> 9gt
    imap <D-9> <Esc>9gt
endif

" remove the delay when pressing esc
set noesckeys

" cargo cult nvim defaults
set autoindent
set autoread
set backspace="indent,eol,start"
set display="lastline"
set formatoptions="tcqj"
set history=10000
set nrformats="bin,hex"
set showcmd
set smarttab
set tabpagemax=50
set tags="./tags;,tags"
set ttyfast
set wildmenu

" plain old vim
if !has("gui_macvim")
    " change cursor shape
    " Ps = 0  -> blinking block.
    " Ps = 1  -> blinking block (default).
    " Ps = 2  -> steady block.
    " Ps = 3  -> blinking underline.
    " Ps = 4  -> steady underline.
    " Ps = 5  -> blinking bar (xterm).
    " Ps = 6  -> steady bar (xterm).
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"

    " optional reset cursor on start:
    augroup cursor_shapes
        au!
        autocmd VimEnter * silent !echo -ne "\e[2 q"
    augroup END
endif

" Toggle background with <leader>bg
map <leader>bg :let &background = (&background == "dark" ? "light" : "dark")<cr>

set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd. map to <ESC> instead.
inoremap <silent> <c-c> <ESC>

" prevent "Press enter to continue" message on auto type info
set cmdheight=2

" js specific keybindings
augroup filetype_js
    autocmd!
    autocmd FileType javascript.jsx setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
    autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
    autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
augroup END

" vim-jsx config
let g:jsx_ext_required = 0

" fugitive shortcuts
" copy Github url to clipboard
nnoremap <leader>u :GBrowse!<cr>
xnoremap <leader>u :GBrowse!<cr>

" vim-sneak
" 2-character Sneak (don't let vim-sneak take s)
nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S
" visual-mode
xmap f <Plug>Sneak_s
xmap F <Plug>Sneak_S
" operator-pending-mode
omap f <Plug>Sneak_s
omap F <Plug>Sneak_S

" jump to start and end of line in insert mode
imap <C-a> <C-o>I
imap <C-e> <C-o>A

" FooSoft/vim-argwrap config
let g:argwrap_tail_comma = 1
nnoremap <silent> <leader>w :ArgWrap<CR>

" quick save
noremap <leader>s :write<cr>

" update MRU when opening buffers through any means, not just from FZF
" augroup custom_filemru
"   autocmd!
"   autocmd BufWinEnter * UpdateMru
" augroup END

"set wildignore+=*.pyc,*.o,*.a,*.clj,*.css,*.html,*.js
set wildignore+=*.pyc,*.o,*.a,*.clj

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

nnoremap <leader>rv :source $MYVIMRC<cr>

" jump to beginning of line
nnoremap H ^
vnoremap H ^
" jump to end of line
nnoremap L $
vnoremap L $

" destroy add buffers
nnoremap <leader>bd :bufdo bd<cr>

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

" moving selected lines
xnoremap <silent> <c-k> :move-2<CR>gv=gv
xnoremap <silent> <c-j> :move'>+<CR>gv=gv

" :Silent command to supress "Press Enter to continue" messages
command! -nargs=+ Silent execute 'silent <args>' | redraw!

" For vim-workspace
nnoremap <leader>S :mksession! /tmp/sess.vim<CR>:qa<CR>

" For vim-indent-guides
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" For google/vim-jsonnet
" disable fmt on save
let g:jsonnet_fmt_on_save = 0

" disable match paren functionality that causes scrolling to be slow
let g:loaded_matchparen = 1

" disable the built-in showing of mode in the command bar since airline will
" take care of that
set noshowmode
set noruler

" show both absolute current line no and relative numbers
set relativenumber number

" Common typos
command! Q  quit
command! W  write
command! Wq wq
command! Cq cq


" Some emacs keybindings thats used all over OS X

" duplicate line / block
" nmap <C-D> yyp
" vmap <C-D> y']pgv

" delete one char in front
inoremap <C-d> <Delete>

" Show cursor position
" 2016-01-31: disabling because perf & airline shows this anyway
set noruler

" for letting swtich away from a modified buffer w/o warning
set hidden

" for highlighting search word
set hlsearch

" always show gitgutter col so text doesn't jump around when they come in
set signcolumn=yes
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1

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

if has("autocmd")
    " Automatically lint files on save
    "autocmd! BufWritePost * Neomake
    "augroup auto_neomake
    "    autocmd!
    "    autocmd BufWritePost *.py if exists(":Neomake") | exe "Neomake" | endif
    "    "autocmd BufWritePost *.go if exists(":Neomake") | exe "Neomake" | endif
    "augroup END

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
endif

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

" remap'd keys
nnoremap <Tab><Tab> <C-W>w

" Show syntax highlighting groups for word under cursor
" nmap <C-S-P> :call <SID>SynStack()<CR>
function! SynStack()
  if !exists("*synstack")
    return
  endif
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunc

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

" persistent undo file
set undofile
" the "//" at the end of each directory means that file names will be built
" from the complete path to the file with all path separators substituted to
" percent "%" sign. This will ensure file name uniqueness in the preserve
" directory.
set undodir=~/.tmp/vim/.undo//
set backup
set writebackup
set backupdir=~/.tmp/vim/.backup//
set directory=~/.tmp/vim/.swp//
silent execute '!mkdir -p ' . &undodir . ' ' . &backupdir . ' ' &directory

" folding settings
set foldmethod=indent
set foldlevelstart=20

" misc
"set ai
set incsearch
set nowrapscan
set nowrap

" show live previews for :substitute
if has("inccommand")
    set inccommand=nosplit
endif

" default is 4000 (4s), which is too long to wait to trigger events
" like "CursorHold"
set updatetime=300

" reformat JSON
map <leader>jt  <Esc>:%!json_xs -f json -t json-pretty<CR>

" disable logipat plugin so that :E works again
let g:loaded_logipat = 1

" netrw settings
let g:netrw_liststyle=3

" sync to system clipboard
set clipboard=unnamedplus
