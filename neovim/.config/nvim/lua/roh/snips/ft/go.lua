local ls = require "luasnip"

-- local snippet = ls.s
local snippet_from_nodes = ls.sn

local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local shared = R "roh.snips"
local same = shared.same

local ts_locals = require "nvim-treesitter.locals"
local ts_utils = require "nvim-treesitter.ts_utils"

local get_node_text = vim.treesitter.get_node_text

vim.treesitter.set_query(
  "go",
  "LuaSnip_Result",
  [[ [
    (method_declaration result: (_) @id)
    (function_declaration result: (_) @id)
    (func_literal result: (_) @id)
  ] ]]
)

local transform = function(text, info)
  if string.find(text, "int", 1, true) then
    return t "0"
  elseif string.find(text, "float", 1, true) then
    return t "0"
  elseif text == "error" then
    if info then
      info.index = info.index + 1

      return c(info.index, {
        t(string.format('obserr.Annotate(%s, "%s failed")', info.err_name, info.func_name or "something")),
        t(info.err_name),
      })
    else
      return t "err"
    end
  elseif text == "bool" then
    return t "false"
  elseif text == "string" then
    return t '""'
  elseif string.find(text, "*", 1, true) then
    return t "nil"
  elseif string.find(text, "map[", 1, true) then
    return t "nil"
  elseif string.find(text, "[]", 1, true) then
    return t "nil"
  end

  return t(text .. "{}")
end

local handlers = {
  ["parameter_list"] = function(node, info)
    local result = {}

    local count = node:named_child_count()
    for idx = 0, count - 1 do
      table.insert(result, transform(get_node_text(node:named_child(idx), 0), info))
      if idx ~= count - 1 then
        table.insert(result, t { ", " })
      end
    end

    return result
  end,

  ["type_identifier"] = function(node, info)
    local text = get_node_text(node, 0)
    return { transform(text, info) }
  end,
}

local function go_result_type(info)
  local cursor_node = ts_utils.get_node_at_cursor()
  local scope = ts_locals.get_scope_tree(cursor_node, 0)

  local function_node
  for _, v in ipairs(scope) do
    if v:type() == "function_declaration" or v:type() == "method_declaration" or v:type() == "func_literal" then
      function_node = v
      break
    end
  end

  local query = vim.treesitter.get_query("go", "LuaSnip_Result")
  for _, node in query:iter_captures(function_node, 0) do
    if handlers[node:type()] then
      return handlers[node:type()](node, info)
    end
  end
  return {}
end

local go_ret_vals = function(args)
  return snippet_from_nodes(
    nil,
    go_result_type {
      index = 0,
      err_name = args[1][1],
      func_name = args[2] and args[2][1],
    }
  )
end

local M = {
  main = {
    t { "func main() {", "\t" },
    i(0),
    t { "", "}" },
  },

  t = fmt(
    "func Test{}(t *testing.T) {{\n\t{}\n{}\n}}",
    {
        i(1, "Something"),
        i(2, "t.Parallel()"),
        i(0),
    }
  ),

  f = fmt(
    "func {}({}) {} {{\n\t{}\n}}",
    { i(1, "f"), i(2), i(3), i(0) }
  ),

  ef = {
    i(3, { "val" }),
    t ", err := ",
    i(1, { "f" }),
    t "(",
    i(2),
    t ")",
    i(0),
  },

  ie = fmt(
    "if {} != nil {{\n\treturn {}\n}}{}",
    {
      i(1, "err"),
      d(2, go_ret_vals, {1}),
      i(0),
    }
  ),

  ief = fmt(
    "if {}, {} := {}({}); {} != nil {{\n\treturn {}\n}}{}",
    {
      i(3, { "val" }),
      i(4, { "err" }),
      i(1, { "f" }),
      i(2, { "" }),
      same(3),
      d(5, go_ret_vals, { 4, 1 }),
      i(0),
    }
  ),

  efi = {
    i(1, { "val" }),
    t ", ",
    i(2, { "err" }),
    t " := ",
    i(3, { "f" }),
    t "(",
    i(4),
    t ")",
    t { "", "if " },
    same(2),
    t { " != nil {", "\treturn " },
    d(5, go_ret_vals, { 2, 3 }),
    t { "", "}" },
    i(0),
  },
}


return M

