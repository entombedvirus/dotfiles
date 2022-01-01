local installed, ts = pcall(require, 'nvim-treesitter.configs')
if not installed then
    return
end
ts.setup {
    highlight = {
        enable = true,                    -- false will disable the whole extension
        disable = { 'python' },                   -- list of language that will be disabled
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
        'rust',
        'typescript',
        'yaml',
    }, -- one of 'all', 'language', or a list of languages
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]F"] = "@function.outer",
                ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
                ["[F"] = "@function.outer",
                ["[A"] = "@parameter.inner",
            },
        },
    },
}
