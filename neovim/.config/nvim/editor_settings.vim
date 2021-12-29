augroup editor_settings_user_config
    autocmd!
    autocmd BufWritePost editor_settings.vim source <afile> | redraw
augroup end
" nnoremap <leader>rv :source $MYVIMRC<cr>

" jump to beginning of line
nnoremap H ^
xnoremap H ^

" jump to end of line
nnoremap L $
xnoremap L $

" scroll faster
" nnoremap <C-j> 5j
" nnoremap <C-k> 5k

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

" reformat JSON
map <leader>jt  <Esc>:%!json_xs -f json -t json-pretty<CR>

" disable logipat plugin so that :E works again
let g:loaded_logipat = 1

" netrw settings
let g:netrw_liststyle=3

" sync to system clipboard
set clipboard=unnamedplus

" ===== plugin config =====
" vim-test config

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

" vimpostor/vim-tpipeline config
let g:tpipeline_split = 1

" For conceal markers.
if has('conceal')
    " hide concealed chars, except in insert, visual and command modes
    set conceallevel=2 concealcursor=n
endif

" vim-go
let g:go_fmt_autosave = 0 " let nvim-lsp handle formatting
let g:go_imports_autosave = 0
let g:go_gopls_enabled = 0
let g:go_gopls_options = ['-remote=auto', '-logfile=/tmp/gopls.vim-go.log', '-rpc.trace']
"let g:go_debug = ["lsp"]

if executable('gopls')
    " register gopls for go-to-def and auto-info
    let g:go_def_mode = 'gopls'
    let g:go_info_mode = 'gopls'
    let g:go_referrers_mode = 'gopls'
endif

let g:go_snippet_engine = 'ultisnips'
let g:go_decls_mode = 'fzf'
let g:go_highlight_types = 0
let g:go_highlight_fields = 0
let g:go_highlight_format_strings = 0
let g:go_highlight_methods = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_functions = 0
"let g:go_highlight_build_constraints = 1
"let g:go_highlight_generate_tags = 1
let g:go_diagnostics_enabled = 0
let g:go_doc_popup_window = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_def_mapping_enabled = 0

" seems to lead to weird artifacts. vim-go uncoditionally calls UltiSnips#Anon
" if this is turned on and that does not interact well with ncm2_ultisnips.
let g:go_gopls_use_placeholders = 0

" suppress "Completion SUCCESS" messages
let g:go_echo_go_info = 0

" reduce the delay before auto_sameids and auto_type_info activates
let g:go_updatetime = 300
let g:go_auto_sameids = 0
let g:go_auto_type_info = 0

" Add the failing test name to the output of :GoTest
let g:go_test_show_name = 1

" prevent "Press enter to continue" message on auto type info
set cmdheight=2

" go specific keybindings
augroup filetype_go
    autocmd!
    autocmd FileType go nnoremap <buffer> <localleader>gb :GoBuild<CR>
    autocmd FileType go nnoremap <buffer> <localleader>gi :GoInstall -i<CR>
    " autocmd FileType go nnoremap <buffer> <localleader>gt :GoTest<CR>
    " autocmd FileType go nnoremap <buffer> <localleader>gtf :GoTestFunc<CR>
    autocmd FileType go nnoremap <buffer> <localleader>gc :GoCoverageToggle<CR>
    autocmd FileType go nnoremap <buffer> <localleader>gf :GoImports<CR>
    autocmd FileType go nnoremap <buffer> <localleader>gm :GoMetaLinter<CR>
    " autocmd FileType go nnoremap <buffer> <localleader>gd :GoDecls<CR>
    autocmd FileType go nnoremap <buffer> <localleader>ge :GoIfErr<CR>
    "autocmd FileType go nnoremap <buffer> <C-i> :GoAutoTypeInfoToggle<CR>

    " tagbar
    autocmd FileType go nnoremap <silent> <localleader>tb :TagbarToggle<CR>
augroup END

"
" js specific keybindings
augroup filetype_js
    autocmd!
    autocmd FileType javascript.jsx setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
    autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
    autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
augroup END

" vim-jsx config
let g:jsx_ext_required = 0

" lightline config
set showtabline=2
let g:lightline#bufferline#unnamed         = '[No Name]'
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline                    = get(g:, 'lightline', {})
let g:lightline.active             = {
\                                      'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'relativepath', 'modified']],
\                                      'right': [['lineinfo'], ['percent'], ['gutentags', 'fileformat', 'fileencoding', 'filetype']]
\                                    }
let g:lightline.inactive           = {'left': [ [ 'relativepath', 'modified' ] ], 'right': [ [ 'lineinfo' ],[ 'percent' ] ] }
let g:lightline.component          = {'sep': '-> '}
let g:lightline.component_function = {'gitbranch': 'LightlineGitBranch'}
"let g:lightline.component_function = {'gitbranch': 'LightlineGitBranch', 'gutentags': 'gutentags#statusline'}
let g:lightline.component_expand   = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type     = {'buffers': 'tabsel'}
let g:lightline.tabline            = {'left': [['tabs'], ['sep'], ['buffers']]}
let g:lightline.tab                = {}
let g:lightline.tab.inactive       = ['tabnum']
let g:lightline.tab.active         = ['tabnum']

function! LightlineGitBranch()
    let name = get(b:, 'gitsigns_head', '<unavailable>')
    "let name = fugitive#head()
    return name ==# '' ? '' : ' ' . name
endfunction

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
