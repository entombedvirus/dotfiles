require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,                    -- false will disable the whole extension
        disable = {  },                   -- list of language that will be disabled
        --disable = { 'go' },               -- list of language that will be disabled
    },
    incremental_selection = {
        enable = true,
        --disable = { 'cpp', 'lua' },
        keymaps = {                       -- mappings for incremental selection (visual mappings)
          init_selection = 'gnn',         -- maps in normal mode to init the node/scope selection
          node_incremental = "grn",       -- increment to the upper named parent
          scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
          node_decremental = "grm",      -- decrement to the previous node
        }
    },
    ensure_installed = {
        'bash',
        'c',
        'cpp',
        'css',
        'go',
        'html',
        'javascript',
        'json',
        'lua',
        'python',
        'typescript',
        'yaml',
    } -- one of 'all', 'language', or a list of languages
}
