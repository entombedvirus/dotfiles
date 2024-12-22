return {
	'mfussenegger/nvim-dap',
	config = function()
		local spawn_dlv = function(spawn_opts)
			local stdout = vim.loop.new_pipe(false)
			local stderr = vim.loop.new_pipe(false)
			local handle
			local pid_or_err
			local port = 38697
			local opts = vim.tbl_deep_extend("keep", spawn_opts, {
				args = {
					"dap",
					"--log",
					"--log-output", "dap,rpc",
					"--log-dest", "/tmp/dlv.log",
					"-l", "127.0.0.1:" .. port,
				},
				stdio = { nil, stdout, stderr },
				detached = true
			})
			handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
				stdout:close()
				stderr:close()
				handle:close()
				if code ~= 0 then
					print('dlv exited with code', code)
				end
			end)
			assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
			local append_to_repl = function(err, chunk)
				assert(not err, err)
				if chunk then
					-- tell dap we successfully started the server
					vim.schedule(function()
						require('dap.repl').append(chunk)
					end)
				end
			end
			stdout:read_start(append_to_repl)
			stderr:read_start(append_to_repl)

			return {
				type = "server",
				host = "127.0.0.1",
				port = port,
			}
		end
		local last_r_input
		local dap = require('dap')
		dap.adapters.go_with_args = function(callback, config)
			local on_confirm = function(main_pkg_and_args)
				if not main_pkg_and_args then
					-- r canceled
					return
				end
				local it = main_pkg_and_args:gmatch("%S+")
				local main_pkg_path = it()
				local args = {}
				for arg in it do
					table.insert(args, arg)
				end
				config.args = args
				local resolved_adapter = spawn_dlv({ cwd = main_pkg_path })
				vim.defer_fn(function() callback(resolved_adapter) end, 100)
				last_r_input = main_pkg_and_args
			end

			vim.ui.input({
				prompt = 'main package path and args: ',
				default = last_r_input or vim.fn.expand('%:h'),
				kind = 'dap_args',
			}, on_confirm)
		end

		dap.adapters.go_without_args = function(callback)
			local cwd = vim.fn.expand('%:h')
			local resolved_adapter = spawn_dlv({ cwd = cwd })
			-- Wait for delve to start
			vim.defer_fn(function() callback(resolved_adapter) end, 100)
		end

		local last_test_at_cursor_state
		dap.adapters.go_test_at_cursor = function(callback, config)
			local test_name, err = require('settings/treesitter').get_cursor_test_name()
			if err and not last_test_at_cursor_state then
				print('get_cursor_test_name failed: ' .. err)
				return
			end

			local cwd = vim.fn.expand('%:h')
			if not test_name then
				test_name = last_test_at_cursor_state.test_name
				cwd = last_test_at_cursor_state.cwd
			end

			config.args = { '-test.run=' .. test_name .. '$' }
			local resolved_adapter = spawn_dlv({ cwd = cwd })
			-- Wait for delve to start
			vim.defer_fn(function() callback(resolved_adapter) end, 100)
			last_test_at_cursor_state = {
				test_name = test_name,
				cwd = cwd,
			}
		end

		dap.configurations.go = {
			{
				type = "go_test_at_cursor",
				name = "Debug cursor test",
				request = "launch",
				mode = "test",
				cwd = "${fileDirname}",
				program = "./",
			},
			{
				type = "go_without_args",
				name = "Debug all tests",
				request = "launch",
				mode = "test",
				cwd = "${fileDirname}",
				program = "./",
			},
			{
				type = "go_with_args",
				name = "Debug w/ args",
				request = "launch",
				program = "./",
				prompt_r_for_args = true,
			},
		}

		local opts = { silent = true, noremap = true }
		vim.keymap.set('n', '<leader>dd', "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
		vim.keymap.set('n', '<leader>dB',
			"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", opts)
		vim.keymap.set('n', '<leader>ddl',
			"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", opts)
		vim.keymap.set('n', '<leader>dc', "<cmd>lua require'dap'.continue()<cr>", opts)
		vim.keymap.set('n', '<leader>dl', "<cmd>lua require'dap'.run_last()<cr>", opts)
		vim.keymap.set('n', '<leader>dn', "<cmd>lua require'dap'.step_over()<cr>", opts)
		vim.keymap.set('n', '<leader>dN', "<cmd>lua require'dap'.step_into()<cr>", opts)
		vim.keymap.set('n', '<leader>dr', "<cmd>lua require'dap'.run_to_cursor()<cr>", opts)
		vim.keymap.set('n', '<leader>dk', "<cmd>lua require('dap.ui.widgets').hover()<cr>", opts)
		vim.keymap.set('n', '<leader>dR', "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
		vim.keymap.set('n', '<leader>dq', "<cmd>lua require'dap'.terminate()<cr>", opts)
	end,
}
