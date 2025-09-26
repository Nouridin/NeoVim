-- ~/.config/nvim/init.lua
-- NOURIDIN'S NEOVIM CONFIG
-- VERSION: 1.5.0
-- DATE: 2025-05-07
-----------------------------------------------------------

-----------------------------------------------------------
-- 1. BOOTSTRAP & CORE SETTINGS -----------------------------------
-----------------------------------------------------------
local fn = vim.fn
local opt = vim.opt

-- Bootstrap lazy.nvim
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
opt.rtp:prepend(lazypath)

-- Basic options
opt.number           = true
opt.relativenumber   = true
opt.cursorline       = true
opt.cursorcolumn     = true
opt.wrap             = false
opt.expandtab        = true
opt.shiftwidth       = 4
opt.tabstop          = 4
opt.smartcase        = true
opt.incsearch        = true
opt.hlsearch         = true
opt.history          = 1000
opt.clipboard        = "unnamedplus"
opt.backup           = true
opt.backupdir        = fn.stdpath("data") .. "/backup"
opt.writebackup      = false
opt.swapfile         = false
opt.wildmenu         = true
opt.wildmode         = {"list", "longest"}
opt.wildignore       = {"*.jpg","*.png","*.gif","*.pdf","*.exe","*.pyc"}
opt.encoding         = "utf-8"
opt.showcmd          = true
opt.showmode         = true
opt.showmatch        = true
opt.guicursor        = "n-v-c:block,i:block,r:block,o:block"

-- Leader key
vim.g.mapleader = " "

-----------------------------------------------------------
-- 2. PLUGIN INSTALLATION (using lazy.nvim) --------------------
-- (added mason, null-ls, dap, which-key, luasnip, friendly-snippets, and switched nvim-tree to maintained repo)
-----------------------------------------------------------
require("lazy").setup({
  -- Dependencies
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

  -- Themes
  { "catppuccin/nvim",       name = "catppuccin" },
  "gruvbox-community/gruvbox",
  "sainnhe/sonokai",

  -- Dashboard
  { "goolord/alpha-nvim",    dependencies = "nvim-tree/nvim-web-devicons" },

  -- File explorer & icons (use maintained nvim-tree)
  { "nvim-tree/nvim-tree.lua" },
  { "akinsho/bufferline.nvim" },

  -- Statusline
  { "hoob3rt/lualine.nvim" },

  -- Treesitter & context
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-context",

  -- Indent guides
  "lukas-reineke/indent-blankline.nvim",
  "lewis6991/gitsigns.nvim",

  -- Popup UI
  "rcarriga/nvim-notify",
  "stevearc/dressing.nvim",
  "folke/noice.nvim",

  -- Floating terminal
  "akinsho/toggleterm.nvim",

  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- Git
  "tpope/vim-fugitive",

  -- Editing helpers
  "windwp/nvim-autopairs",
  "tpope/vim-surround",

  -- LSP & Completion & Snippets
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
  "saadparwaiz1/cmp_luasnip",

  -- Mason for LSP / DAP / tools
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "jay-babu/mason-nvim-dap.nvim",

  -- Null-ls for formatters/linters
  "jose-elias-alvarez/null-ls.nvim",

  -- DAP (debugging)
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",

  -- Which-key
  "folke/which-key.nvim",

  -- Tagbar
  "preservim/tagbar",
})

-----------------------------------------------------------
-- 3. COLORS & THEME TOGGLER ---------------------------------
-----------------------------------------------------------
vim.cmd("colorscheme catppuccin-mocha")

do
  local themes = { "catppuccin-mocha", "gruvbox", "sonokai" }
  local idx = 1
  vim.keymap.set("n", "<leader>tt", function()
    idx = idx % #themes + 1
    vim.cmd("colorscheme " .. themes[idx])
    print("Switched to theme: " .. themes[idx])
  end, { desc = "Toggle colorscheme" })
end

-----------------------------------------------------------
-- 4. DASHBOARD (alpha-nvim) --------------------------------
-----------------------------------------------------------
local ok, alpha = pcall(require, "alpha")
if ok then
  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.header.val = {
  "███╗░░██╗░█████╗░██╗░░░██╗██████╗░██╗██████╗░██╗███╗░░██╗██╗░██████╗  ███╗░░██╗██╗░░░██╗██╗███╗░░░███╗",
  "████╗░██║██╔══██╗██║░░░██║██╔══██╗██║██╔══██╗██║████╗░██║╚█║██╔════╝  ████╗░██║██║░░░██║██║████╗░████║",
  "██╔██╗██║██║░░██║██║░░░██║██████╔╝██║██║░░██║██║██╔██╗██║░╚╝╚█████╗░  ██╔██╗██║╚██╗░██╔╝██║██╔████╔██║",
  "██║╚████║██║░░██║██║░░░██║██╔══██╗██║██║░░██║██║██║╚████║░░░░╚═══██╗  ██║╚████║░╚████╔╝░██║██║╚██╔╝██║",
  "██║░╚███║╚█████╔╝╚██████╔╝██║░░██║██║██████╔╝██║██║░╚███║░░░██████╔╝  ██║░╚███║░░╚██╔╝░░██║██║░╚═╝░██║",
  "╚═╝░░╚══╝░╚════╝░░╚═════╝░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝╚═╝░░╚══╝░░░╚═════╝░  ╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝",  }
  dashboard.section.buttons.val = {
    dashboard.button("f", "  Find file",    ":Telescope find_files<CR>"),
    dashboard.button("e", "  New file",     ":ene <BAR> startinsert<CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
    dashboard.button("q", "  Quit NVIM",    ":qa<CR>"),
  }
  alpha.setup(dashboard.config)
  vim.keymap.set("n", "<leader>a", ":Alpha<CR>", { desc = "Dashboard" })
end

-----------------------------------------------------------
-- 5. FILE EXPLORER & BUFFERLINE ---------------------------
-- (nvim-tree updated to not auto-open; added defensive autocmd)
-----------------------------------------------------------
require("nvim-tree").setup({
  disable_netrw       = false,
  hijack_netrw        = true,
  open_on_tab         = false,
  update_focused_file = {
    enable = false,
    update_cwd = false,
  },
  view = {
    width = 30,
    side = "left",
  },
  actions = {
    open_file = { quit_on_open = true },
  },
})

require("bufferline").setup({
  options = {
    offsets = {{ filetype = "NvimTree", text = "Explorer", padding = 1 }},
    show_buffer_close_icons = false,
    show_close_icon = false,
    diagnostics = "nvim_lsp",
  },
})

-----------------------------------------------------------
-- 6. STATUSLINE (lualine.nvim) ----------------------------
-----------------------------------------------------------
require("lualine").setup({
  options = {
    theme = "catppuccin",
    section_separators = "",
    component_separators = "|",
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff"},
    lualine_c = {"filename"},
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"},
  },
})
opt.laststatus = 2

-----------------------------------------------------------
-- 7. TREESITTER & CONTEXT ---------------------------------
-----------------------------------------------------------
require("nvim-treesitter.configs").setup({
  ensure_installed = {"lua", "cpp", "c", "python", "javascript", "html", "css", "elixir", "rust", "java", "ruby", "typescript" },
  highlight = { enable = true },
})
require("treesitter-context").setup({ enable = true })

-----------------------------------------------------------
-- 8. INDENT GUIDES ----------------------------------------
-----------------------------------------------------------
require("ibl").setup({
  indent = {
    char = "▏",
  },
  scope = {
    enabled = true,
  },
})

-----------------------------------------------------------
-- 9. POPUPS & NOTIFICATIONS -------------------------------
-----------------------------------------------------------
require("notify").setup({ stages = "fade_in_slide_out", timeout = 2000 })
vim.notify = require("notify")

require("dressing").setup({ input = { enabled = true }, select = { enabled = true } })

require("noice").setup({
  lsp = { override = { "vim.lsp.util.convert_input_to_markdown_lines" } },
  routes = {
    { view = "notify", filter = { event = "msg_show", find = "%d+L, %d+B" } },
  },
})

-----------------------------------------------------------
-- 10. FLOATING TERMINAL -----------------------------------
-----------------------------------------------------------
require("toggleterm").setup({
  size = 20,
  open_mapping = [[<c-\>]],
  shade_factor = 2,
})

-- quick build/run helpers using toggleterm (C/C++ friendly)
vim.keymap.set("n", "<leader>m", ":wa<CR>:TermExec cmd='make' direction=float<CR>", { desc = "Make" })
vim.keymap.set("n", "<leader>r", ":w<CR>:TermExec cmd='g++ -std=c++20 % -o %:r && ./%:r' direction=horizontal size=15<CR>", { desc = "Compile & Run current file" })

-----------------------------------------------------------
-- 11. TELESCOPE -------------------------------------------
-----------------------------------------------------------
require("telescope").setup()
require("telescope").load_extension("fzf")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>",   { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help Tags" })

-----------------------------------------------------------
-- 12. LSP & COMPLETION ------------------------------------
-- (wired nvim-cmp + clangd + pyright kept; added mason + null-ls)
-----------------------------------------------------------
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
  cmp.setup({
    snippet = {
      expand = function(args) require("luasnip").lsp_expand(args.body) end,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
    },
  })
end

-- mason + mason-lspconfig for tool management
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup()
end

-- mason-lspconfig
local mlsp_ok, mlsp = pcall(require, "mason-lspconfig")
if mlsp_ok then
  mlsp.setup({
    ensure_installed = { "clangd", "clang-format", "codelldb" },
  })
end

-- LSP capabilities for cmp
local capabilities = {}
if cmp_ok then capabilities = require("cmp_nvim_lsp").default_capabilities() end

-- clangd (C/C++) and keep pyright working
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if lspconfig_ok then
  -- clangd
  lspconfig.clangd.setup({
    capabilities = capabilities,
    cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
    on_attach = function(client, bufnr)
      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
      vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ bufnr = bufnr }) end, bufopts)
    end,
  })

  -- pyright (preserve existing)
  pcall(function() lspconfig.pyright.setup({ capabilities = capabilities }) end)
end

-- null-ls for formatting (clang-format)
local ok_null, null_ls = pcall(require, "null-ls")
if ok_null then
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.clang_format.with({
        extra_args = { "--style=file" } -- prefer project .clang-format
      }),
    },
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
        })
      end
    end,
  })
end

-----------------------------------------------------------
-- 13. GENERAL KEYMAPS --------------------------------------
-----------------------------------------------------------
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit NVIM" })

vim.keymap.set("n", "<F8>", ":TagbarToggle<CR>", { silent = true })

-- Telescope: Search inside files
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Search in project" })
vim.keymap.set("v", "<leader>fs", "\"+y:lua require('telescope.builtin').grep_string({ search = vim.fn.getreg('+') })<CR>", { desc = "Search selected text" })

-----------------------------------------------------------
-- 14. DAP (debug) + DAP-UI --------------------------------
-- (codelldb adapter; keymaps for debugging)
-----------------------------------------------------------
local dap_ok, dap = pcall(require, "dap")
local dapui_ok, dapui = pcall(require, "dapui")
if dap_ok and dapui_ok then
  dapui.setup()
  dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
      command = "codelldb",
      args = {"--port", "${port}"},
    }
  }
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp

  -- DAP keymaps
  vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "DAP Continue" })
  vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "DAP Step Over" })
  vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "DAP Step Into" })
  vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "DAP Step Out" })
  vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
  vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP UI Toggle" })
end

-----------------------------------------------------------
-- 15. LUALSNIP: friendly-snippets + small example -----------
-----------------------------------------------------------
pcall(function()
  local luasnip = require("luasnip")
  require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets
  -- simple cpp main snippet
  luasnip.add_snippets("cpp", {
    luasnip.snippet("main", {
      luasnip.text_node({"#include <bits/stdc++.h>", "", "using namespace std;", "", "int main() {", "\t"}),
      luasnip.insert_node(0),
      luasnip.text_node({"", "\treturn 0;", "}"}),
    }),
  })
end)

-----------------------------------------------------------
-- 16. WHICH-KEY: helpful groups ----------------------------
-----------------------------------------------------------
pcall(function()
  require("which-key").setup({})
  require("which-key").register({
    ["<leader>c"] = { name = "+code", r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" }, f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format" } },
    ["<leader>d"] = { name = "+debug", b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle Breakpoint" }, c = { "<cmd>lua require'dap'.continue()<CR>", "Continue" } },
  }, { prefix = "<leader>" })
end)

-----------------------------------------------------------
-- 17. FINAL NOTES -----------------------------------------
-----------------------------------------------------------
-- After saving this file:
-- 1. Restart Neovim
-- 2. Run :Lazy sync  (to install new plugins)
-- 3. Run :Mason  and ensure clangd, clang-format, codelldb are installed (or run :MasonInstall ...)
-- 4. For C/C++ projects, prefer having compile_commands.json (CMake: -DCMAKE_EXPORT_COMPILE_COMMANDS=ON) for best clangd results
-- Check startup time with: `nvim --startuptime nvim.log`
-- Split into lua/ subfiles as needed: settings.lua, keymaps.lua, plugins.lua

