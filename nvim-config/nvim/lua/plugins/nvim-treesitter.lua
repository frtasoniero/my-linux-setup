-- ================================================================================================
-- TITLE : nvim-treesitter
-- ABOUT : Treesitter configurations and abstraction layer for Neovim.
-- LINKS :
--   > github : https://github.com/nvim-treesitter/nvim-treesitter
-- ================================================================================================

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	lazy = false,
	config = function()
		-- language parsers that MUST be installed
		local ensure_installed = {
			"bash",
			"c",
			"cpp",
			"css",
			"dockerfile",
			"go",
			"html",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"rust",
			"svelte",
			"typescript",
			"vue",
			"yaml",
		}

		-- Install parsers
		local installed = require("nvim-treesitter.install")
		installed.prefer_git = true

		-- Ensure parsers are installed
		for _, lang in ipairs(ensure_installed) do
			local ok, parser = pcall(vim.treesitter.language.inspect, lang)
			if not ok then
				vim.cmd("TSInstall " .. lang)
			end
		end

		-- Enable highlighting
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})

		-- Enable indentation
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldenable = false

		-- Incremental selection keymaps
		vim.keymap.set("n", "<CR>", function()
			require("nvim-treesitter.incremental_selection").init_selection()
		end, { desc = "Init treesitter selection" })
		vim.keymap.set("v", "<CR>", function()
			require("nvim-treesitter.incremental_selection").node_incremental()
		end, { desc = "Increment treesitter selection" })
		vim.keymap.set("v", "<TAB>", function()
			require("nvim-treesitter.incremental_selection").scope_incremental()
		end, { desc = "Increment treesitter scope" })
		vim.keymap.set("v", "<S-TAB>", function()
			require("nvim-treesitter.incremental_selection").node_decremental()
		end, { desc = "Decrement treesitter selection" })
	end,
}
