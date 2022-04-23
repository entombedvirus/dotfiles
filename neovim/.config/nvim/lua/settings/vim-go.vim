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
augroup END
