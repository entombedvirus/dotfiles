nmap <silent> <leader>gtf :TestNearest<CR>
nmap <silent> <leader>gtl :TestLast<CR>
nmap <silent> <leader>gt :TestFile<CR>

let g:test#strategy = "floaterm"

" execute tests from package dir
let g:test#project_root = "%:h"
