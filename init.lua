-----------------------------------------------------------
-- ~/.config/nvim/init.lua
-- NOURIDIN'S NEOVIM CONFIG
-- VERSION: 1.3.1
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

  -- File explorer & icons
  { "kyazdani42/nvim-tree.lua",   tag = "nightly" },
  { "akinsho/bufferline.nvim" },

  -- Statusline
  { "hoob3rt/lualine.nvim" },

  -- Treesitter & context
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-context",

  -- Indent guides
  "lukas-reineke/indent-blankline.nvim",

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
  "lewis6991/gitsigns.nvim",

  -- Editing helpers
  "windwp/nvim-autopairs",
  "tpope/vim-surround",

  -- LSP & Completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" } },

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
    "   ⣀⣤⣶⣾⣿⣿⣶⣤⣀   ",
    "   Welcome, Nouridin!   ",
  }
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
-----------------------------------------------------------
require("nvim-tree").setup({
  view = { width = 30 },
  actions = { open_file = { quit_on_open = true } },
})
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Explorer" })

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
-----------------------------------------------------------
local cmp = require("cmp")
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

require("lspconfig").pyright.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

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

-----------------------------------------------------------
-- 14. FINAL NOTES -----------------------------------------
-----------------------------------------------------------
-- Check startup time with: `nvim --startuptime nvim.log`
-- Split into lua/ subfiles as needed: settings.lua, keymaps.lua, plugins.lua
