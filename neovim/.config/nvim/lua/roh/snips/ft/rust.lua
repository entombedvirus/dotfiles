local fmt = require("luasnip.extras.fmt").fmt

local ls = require "luasnip"
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node

local M = {
	st = fmt(
		"#[derive(Debug)]\n{} {} {{\n\t{}\n}}\n",
		{
			c(1, { t("struct"), t("enum") }),
			i(2, "Name"),
			i(3, "field")
		}
	),

	allow = fmt(
		"#![allow({})]\n\n",
		{
			i(1, "unused, dead_code"),
		}
	),
};

return M;
