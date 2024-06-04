local M = {}

M.lazy_load = function(plugin)
	return function()
		local augroup = 'LazyLoad' .. plugin

		vim.api.nvim_create_autocmd({ 'BufRead', 'BufWinEnter', 'BufNewFile' }, {
			group = vim.api.nvim_create_augroup(augroup, { clear = true }),
			callback = function()
				local file = vim.fn.expand '%'
				local condition = file ~= 'NvimTree_1' and file ~= '[lazy]' and file ~= ''

				if condition then
					vim.api.nvim_del_augroup_by_name(augroup)
					if plugin ~= 'nvim-treesitter' then
						vim.schedule(function()
							require('lazy').load { plugins = plugin }

							if plugin == 'nvim-lspconfig' then
								vim.cmd [[ silent! do FileType ]]
							end
						end)
					else
						require('lazy').load { plugins = plugin }
					end
				end
			end,
		})
	end
end

M.git_lazy_load = function(plugin)
	return function()
		local augroup = 'GitLazyLoad' .. plugin

		vim.api.nvim_create_autocmd('BufRead', {
			group = vim.api.nvim_create_augroup(augroup, { clear = true }),
			callback = function()
				vim.fn.system('git -C ' .. '"' .. vim.fn.expand '%:p:h' .. '"' .. ' rev-parse')
				if vim.v.shell_error == 0 then
					vim.api.nvim_del_augroup_by_name(augroup)
					vim.schedule(function()
						require('lazy').load { plugins = plugin }
					end)
				end
			end,
		})
	end
end

M.lsp_lazy_load = function(plugin)
	local augroup = 'LspLazyLoad' .. plugin
	return function()
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup(augroup, { clear = true }),
			callback = function()
				vim.api.nvim_del_augroup_by_name(augroup)
				vim.schedule(function()
					require('lazy').load({ plugins = plugin })
				end)
			end,
		})
	end
end

return M
