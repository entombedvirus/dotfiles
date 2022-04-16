vim.cmd [[
" colorscheme overrides. has to be before any colorscheme lines
augroup colorscheme_overrides
    autocmd!
    "autocmd ColorScheme * highlight Search cterm=underline ctermfg=217 ctermbg=16 gui=underline guifg=#f0a0c0 guibg=#302028
    autocmd ColorScheme * highlight Search cterm=underline ctermfg=217 ctermbg=NONE gui=italic guifg=#f0a0c0 guibg=NONE
    " comments should be ialic
    autocmd ColorScheme * highlight Comment cterm=italic gui=italic
    autocmd ColorScheme * highlight default link LspReferenceText Search
augroup END

" Toggle background with <leader>bg
map <leader>bg :let &background = (&background == "dark" ? "light" : "dark")<cr>
]]

-- local nightfox = require('nightfox')
-- nightfox.setup({
--     fox = "nightfox", -- change the colorscheme to use nordfox
--     transparent = true,
--     styles = {
--         comments = "italic", -- change style of comments to be italic
--         keywords = "bold,italic", -- change style of keywords to be bold
--         functions = "italic", -- styles can be a comma separated list
--         strings = "italic", -- styles can be a comma separated list
--     },
--     inverse = {
--         match_paren = true, -- inverse the highlighting of match_parens
--     },
-- })
-- if not vim.g.lightline then
--     vim.g.lightline = { colorscheme = 'nightfox' }
-- end


-- -- Load the configuration set above and apply the colorscheme
-- nightfox.load()

-- let g:two_firewatch_italics=1
-- colorscheme two-firewatch
-- set background=dark

-- colorscheme PaperColor
-- set background=dark

-- let g:rehash256 = 1
-- let g:molokai_original = 1
-- colorscheme molokai
-- set background=dark

-- colorscheme jelleybeans
-- set background=light

-- set background=dark
-- colorscheme kalisi

-- colorscheme Tomorrow-Night
-- set background=dark

-- let g:gruvbox_italic=1
-- let g:gruvbox_contrast_dark="medium"
-- set background=dark
-- colorscheme gruvbox

-- colorscheme OceanicNext
-- set background=dark
-- let g:airline_theme='oceanicnext'

-- colorscheme one
-- set background=dark

-- colorscheme onedark
-- set background=dark

-- colorscheme neodark
-- set background=dark

-- let g:neodark#terminal_transparent = 1 " default: 0
--  let g:embark_terminal_italics = 1
--  colorscheme embark
--  let g:lightline = {
--    \ 'colorscheme': 'embark',
--    \ }

-- let g:tokyodark_transparent_background = 1
-- let g:tokyodark_enable_italic_comment = 1
-- let g:tokyodark_enable_italic = 1
-- let g:tokyodark_color_gamma = "1.5"
-- colorscheme tokyodark

-- let g:lightline = {'colorscheme': 'tokyonight'}
-- let g:tokyonight_style = "night"
-- let g:tokyonight_day_brightness = 0.1
-- colorscheme tokyonight

-- let g:calvera_italic_comments = 1
-- let g:calvera_italic_keywords = 1
-- let g:calvera_italic_functions = 1
-- let g:calvera_contrast = 1
-- colorscheme calvera

-- hi Comment cterm=italic
-- let g:nvcode_hide_endofbuffer=1
-- let g:nvcode_terminal_italics=1
-- let g:nvcode_termcolors=256
-- colorscheme nvcode
-- set background=dark
-- hi LineNr ctermbg=NONE guibg=NONE

-- colorscheme zephyr
-- set background=dark

-- colorscheme Iosvkem
-- set background=dark

-- colorscheme base16-gruvbox-dark-medium
-- set background=dark

-- colorscheme base16-eighties
-- set background=dark

-- let ayucolor="light"
-- let ayucolor="dark"
-- "let ayucolor="mirage"
-- colorscheme ayu

-- set background=dark
-- colorscheme palenight
-- let g:lightline = { 'colorscheme': 'palenight' }
-- let g:palenight_terminal_italics=1

-- set background=dark
-- colorscheme kuroi

-- colorscheme halcyon
-- set background=dark
