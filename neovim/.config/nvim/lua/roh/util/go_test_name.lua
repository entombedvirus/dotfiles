-- Requires: Neovim with the 'go' treesitter parser installed.

local M = {}

-- Small compat wrapper: get the node under the cursor on 0.9/0.10+
local function node_at_cursor(bufnr)
	bufnr = bufnr or 0
	-- Neovim 0.10+
	if vim.treesitter.get_node then
		return vim.treesitter.get_node({ bufnr = bufnr })
	end
	-- Fallback for older versions
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local parser = vim.treesitter.get_parser(bufnr, "go")
	local tree = parser:parse()[1]
	if not tree then return nil end
	local root = tree:root()
	return root and root:named_descendant_for_range(row, col, row, col) or nil
end

local function text(node, bufnr)
	if not node then return nil end
	return vim.treesitter.get_node_text(node, bufnr or 0)
end

-- Returns true if `fn_name` is a top-level test function name (TestXxx)
local function is_test_function_name(fn_name)
	return fn_name and fn_name:match("^Test[%u%w_]*") ~= nil
end

-- Try to get the *top-level* enclosing Go test function name (e.g. TestFoo)
local function find_enclosing_top_test(node, bufnr)
	local cur = node
	while cur do
		if cur:type() == "function_declaration" then
			-- function_declaration: 'func' (identifier) (signature) (block)
			local name_field = cur:field("name")[1]
			local fn_name = text(name_field, bufnr)
			if is_test_function_name(fn_name) then
				return fn_name
			end
		end
		cur = cur:parent()
	end
	return nil
end

-- If inside a subtest func literal (the 2nd arg of t.Run), get that subtest's name.
-- Pattern: call_expression(selector_expression(identifier, field_identifier[Run]), argument_list(string_lit, func_literal))
local function subtest_name_from_func_literal(func_lit_node, bufnr)
	if not func_lit_node or func_lit_node:type() ~= "func_literal" then
		return nil
	end

	local arg_list = func_lit_node:parent()
	if not arg_list or arg_list:type() ~= "argument_list" then
		return nil
	end

	local call = arg_list:parent()
	if not call or call:type() ~= "call_expression" then
		return nil
	end

	-- Check the callee: should be a selector_expression ... . Run
	local callee = call:field("function")[1]
	if not callee or callee:type() ~= "selector_expression" then
		return nil
	end
	local method = callee:field("field")[1]
	if not method or text(method, bufnr) ~= "Run" then
		return nil
	end

	-- First argument should be a string literal naming the subtest
	local args = {}
	for child in arg_list:iter_children() do
		if child:named() then table.insert(args, child) end
	end
	if #args < 1 then return nil end

	local name_node = args[1]
	if not name_node then return nil end

	if name_node:type() == "interpreted_string_literal" or name_node:type() == "raw_string_literal" then
		local name = text(name_node, bufnr)
		if not name then return nil end
		-- Strip quotes/backticks
		name = name:gsub('^"', ""):gsub('"$', "")
		name = name:gsub("^`", ""):gsub("`$", "")
		return name
	end

	return nil
end

-- Walk upwards collecting nested subtest names by finding func_literal nodes that are
-- the function argument to a t.Run call. We collect from inner→outer, then reverse.
local function collect_enclosing_subtests(node, bufnr)
	local names = {}
	local seen = {}

	local cur = node
	while cur do
		if cur:type() == "func_literal" then
			local nm = subtest_name_from_func_literal(cur, bufnr)
			if nm and not seen[cur:id()] then
				table.insert(names, nm)
				seen[cur:id()] = true
			end
		end
		cur = cur:parent()
	end

	-- Reverse to get outermost→innermost subtest order
	for i = 1, math.floor(#names / 2) do
		names[i], names[#names - i + 1] = names[#names - i + 1], names[i]
	end
	return names
end

--- Public: returns a string like "TestFoo/subA/subB", or nil if not in a test.
function M.current_go_test_name(bufnr)
	bufnr = bufnr or 0
	local node = node_at_cursor(bufnr)
	if not node then return nil end

	local top = find_enclosing_top_test(node, bufnr)
	local subs = collect_enclosing_subtests(node, bufnr)

	if top and #subs > 0 then
		return top .. "/" .. table.concat(subs, "/")
	elseif top then
		return top
	elseif #subs > 0 then
		-- In case someone is inside a subtest function in a helper or similar,
		-- still return the subtest chain, though normally you'll also have a top.
		return table.concat(subs, "/")
	else
		return nil
	end
end

-- Optional convenience command:
function M.echo_current_go_test_name()
	local name = M.current_go_test_name(0)
	if name then
		vim.notify("Go test: " .. name, vim.log.levels.INFO)
	else
		vim.notify("No enclosing Go test found", vim.log.levels.WARN)
	end
end

return M
