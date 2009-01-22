set ts=2
set sts=2
set sw=2
set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

" Common typos
command! Q  quit
command! W  write
command! Wq wq 

set title

" Auto-detect git commit messages
autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=gitcommit

map <leader>t :FuzzyFinderTextMate<CR>

