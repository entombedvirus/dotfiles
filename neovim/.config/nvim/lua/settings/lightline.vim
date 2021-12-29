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
