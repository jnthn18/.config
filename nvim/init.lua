require("jmore.core")

vim.pack.add({
	{ src = "https://github.com/rose-pine/neovim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
})

local default_color = "rose-pine"
vim.cmd("colorscheme " .. default_color)

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "gopls", "ts_ls", "eslint" },
})
require("fidget").setup()
require("blink.cmp").setup()

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "markdown", "lua", "typescript", "javascript", "prisma" },
	callback = function()
		vim.treesitter.start()
	end,
})

require("fzf-lua").setup({
	keymap = {
		fzf = {
			["ctrl-q"] = "select-all+accept",
		},
	},
})

local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>sf", function()
	fzf.files()
end, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sb", function()
	fzf.buffers()
end, { desc = "[S]earch [B]uffers" })
-- Live Grep (search in current project)
vim.keymap.set("n", "<leader>ss", function()
	fzf.live_grep()
end, { desc = "[S]earch [S]trings" })
-- Old files (recently opened files)
vim.keymap.set("n", "<leader>so", function()
	fzf.oldfiles()
end, { desc = "[S]earch [O]ld files" })
-- Git files
vim.keymap.set("n", "<leader>sg", function()
	fzf.git_files()
end, { desc = "[S]earch [G]it" })
-- Help tags
vim.keymap.set("n", "<leader>sh", function()
	fzf.help_tags()
end, { desc = "[S]earch [H]elp Tags" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself.
		--
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Rename the variable under your cursor.
		--  Most Language Servers support renaming across files, etc.
		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

		-- Find references for the word under your cursor.
		map("grr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gri", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("grd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("gO", require("fzf-lua").lsp_document_symbols, "Open Document Symbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("gW", require("fzf-lua").lsp_live_workspace_symbols, "Open Workspace Symbols")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("grt", require("fzf-lua").lsp_typedefs, "[G]oto [T]ype Definition")
	end,
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		go = { "gofumpt", "goimports-reviser" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ buffnr = args.buf })
	end,
})

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Hunk [S]tage" })
		map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Hunk [R]eset" })

		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Hunk [S]tage" })

		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Hunk [R]eset" })

		map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
		map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
		map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Blame Line" })

		map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })

		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end)

		map("n", "<leader>hQ", function()
			gitsigns.setqflist("all")
		end)
		map("n", "<leader>hq", gitsigns.setqflist)

		-- Toggles
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
		map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select Hunk" })
	end,
})

require("which-key").setup({
	spec = {
		{ "<leader>h", group = "Git [H]unk" },
		{ "<leader>s", group = "[S]earch" },
		{ "<leader>p", group = "Vim Pack" },
		{ "<leader>t", group = "[T]oggle" },
		{ "gr", group = "LSP Commands" },
	},
})

local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

vim.keymap.set("n", "<leader>pc", pack_clean, { desc = "which_key_ignore" })
