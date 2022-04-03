local ok, ls = pcall(require, "luasnip")
if not ok then
    return
end

-- Source: https://github.com/tjdevries/config_manager/blob/600736982b8d893a939b43342110c01becbe2a43/xdg_config/nvim/after/plugin/luasnip.lua#L328
local types = require "luasnip.util.types"

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = true,

  -- Crazy highlights!!
  -- #vid3
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " <- Current Choice", "NonTest" } },
      },
    },
  },
}

-- TODO: use vim.keymap.set after upgrading to neovim 0.7
function LuaSnip_CycleChoices()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end
vim.api.nvim_exec([[
    imap <c-u> <cmd>lua require('luasnip').expand()<cr>
    imap <c-j> <cmd>lua require('luasnip').jump(1)<cr>
    imap <c-k> <cmd>lua require('luasnip').jump(-1)<cr>
    imap <c-l> <cmd>lua LuaSnip_CycleChoices()<cr>
]], false)

-- create snippet
-- s(context, nodes, condition, ...)
local snippet = ls.s

-- This is the simplest node.
--  Creates a new text node. Places cursor after node by default.
--  t { "this will be inserted" }
--
--  Multiple lines are by passing a table of strings.
--  t { "line 1", "line 2" }
local t = ls.text_node

-- Insert Node
--  Creates a location for the cursor to jump to.
--      Possible options to jump to are 1 - N
--      If you use 0, that's the final place to jump to.
--
--  To create placeholder text, pass it as the second argument
--      i(2, "this is placeholder text")
local i = ls.insert_node

local shortcut = function(val)
  if type(val) == "string" then
    return { t { val }, i(0) }
  end

  if type(val) == "table" then
    for k, v in ipairs(val) do
      if type(v) == "string" then
        val[k] = t { v }
      end
    end
  end

  return val
end

local make = function(tbl)
  local result = {}
  for k, v in pairs(tbl) do
    table.insert(result, (snippet({ trig = k, desc = v.desc }, shortcut(v))))
  end

  return result
end

local snippets = {}

snippets.all = {
    snippet('foo', t'bar'),
    ls.parser.parse_snippet({trig = "lsp"}, "$1 is ${2|hard,easy,challenging|}"),
}

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/roh/snips/ft/*.lua", true)) do
  local ft = vim.fn.fnamemodify(ft_path, ":t:r")
  snippets[ft] = make(loadfile(ft_path)())
end

ls.add_snippets(nil, snippets)
