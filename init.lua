-----------------------------------------------------------
-- NOURIDIN'S ADVANCED CONFIG FILES FOR NEOVIM (init.lua)
-- VERSION: 1.2.0
-- DATE: 2025 MARCH 22ND
-----------------------------------------------------------

-----------------------------------------------------------
-- 1. BASIC OPTIONS -------------------------------------------------------

local opt = vim.opt

-- Line numbering and search behavior
opt.number = true
opt.relativenumber = true
opt.incsearch = true
opt.smartcase = true
opt.hlsearch = true
opt.history = 1000
opt.showcmd = true
opt.showmode = true
opt.showmatch = true

-- File type detection, plugin, and indent support.
vim.cmd("filetype plugin indent on")

-- Indentation and formatting
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.wrap = false

-- Use the system clipboard.
opt.clipboard = "unnamedplus"

-- Visual enhancements for cursor and syntax.
opt.cursorline = true
opt.cursorcolumn = true
vim.cmd("syntax on")

-- Disable backup, swap files, and writebackup.
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Wildmenu and file ignore settings.
opt.wildmenu = true
opt.wildmode = {"list", "longest"}
opt.wildignore = {"*.docx", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe", "*.flv", "*.img", "*.xlsx"}

-- Encoding
opt.encoding = "utf-8"

-- Force a solid block cursor in all modes.
opt.guicursor = "n-v-c:block,i:block,r:block,o:block"

-----------------------------------------------------------
-- 2. PLUGIN MANAGEMENT WITH lazy.nvim ---------------------------
-- Bootstrapping lazy.nvim (if not already installed)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure and load plugins using lazy.nvim.
require("lazy").setup({
  -- Core utility (many plugins depend on it)
  "nvim-lua/plenary.nvim",

  -- File explorer and navigation.
  "preservim/nerdtree",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "hoob3rt/lualine.nvim",
    -- Optionally, add config or dependencies if needed.
  },

  -- Syntax parsing and highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Git integration.
  "tpope/vim-fugitive",
  "lewis6991/gitsigns.nvim",
  "f-person/git-blame.nvim",

  -- Code structure and navigation.
  "preservim/tagbar",
  "christoomey/vim-sort-motion",
  "ludovicchabant/vim-gutentags",
  "junegunn/gv.vim",

  -- Editor enhancements.
  "mattn/emmet-vim",
  "mhinz/vim-startify",

  -- Editing enhancements.
  "jiangmiao/auto-pairs",
  "tpope/vim-surround",
  "frazrepo/vim-rainbow",

  -- Minimap.
  "wfxr/minimap.vim",
  "wfxr/code-minimap",

  -- Icons.
  "ryanoasis/vim-devicons",

  -- Linting and fixing.
  "dense-analysis/ale",

  -- Autocompletion & LSP (coc.nvim acts as a complete framework here).
  "neoclide/coc.nvim",

  -- Motion enhancements.
  "folke/flash.nvim",

  -- Colorschemes.
  "gruvbox-community/gruvbox",
  "sainnhe/sonokai",

  -- Discord Rich Presence (Neocord).
  "IogaMaster/neocord",

  -- Optional: Session and undo management.
  "simnalamburt/vim-mundo",
})

-----------------------------------------------------------
-- 3. STATUSLINE CONFIGURATION ------------------------------------------
-- Using lualine for a clean, modern statusline.
require("lualine").setup({
  options = {
    theme = "sonokai",         -- Match your colorscheme
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
vim.opt.laststatus = 2  -- Always show statusline

-----------------------------------------------------------
-- 4. KEY MAPPINGS AND AUTOCOMMANDS -------------------------------------
-- Set leader key.
vim.g.mapleader = " "

-- General key mappings:
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Toggle Tagbar with F8.
vim.api.nvim_set_keymap("n", "<F8>", ":TagbarToggle<CR>", { noremap = true, silent = true })

-- Autocommand: Open NERDTree on startup and return to previous window.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("NERDTree | wincmd p")
  end,
})

-- Autocommand: Quit Neovim if NERDTree is the only window in a tab.
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.fn.tabpagenr("$") == 1 
       and vim.fn.winnr("$") == 1 
       and vim.b.NERDTree 
       and vim.b.NERDTree.isTabTree() == 1 then
      vim.fn.feedkeys(":quit<CR>:<BS>")
    end
  end,
})

-----------------------------------------------------------
-- 5. COLORS AND HIGHLIGHTING -------------------------------------------
-- Set colorscheme to Sonokai.
vim.cmd("colorscheme sonokai")

-- Override GitBlame highlighting.
vim.cmd("highlight GitBlame guifg=#808080 ctermfg=8 gui=italic cterm=italic")

-----------------------------------------------------------
-- 6. LSP AND AUTOCOMPLETION (Optional) -------------------------------
-- (Uncomment and modify the following block if you want to use built-in LSP)

--[[
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "tsserver", "clangd" },
})
local lspconfig = require("lspconfig")
lspconfig.pyright.setup{}
lspconfig.tsserver.setup{}
lspconfig.clangd.setup{}
--]]

-----------------------------------------------------------
-- 7. NEOCORD (DISCORD RICH PRESENCE) CONFIGURATION ---------------------
require("neocord").setup({
  -- General options
  logo                = "auto",    -- "auto" or URL for a custom logo
  logo_tooltip        = nil,       -- Tooltip text when hovering over the logo
  main_image          = "language",-- Use "language" to automatically show language icon, or "logo" for a fixed logo
  client_id           = "1157438221865717891", -- Discord client id (consider using your own if desired)
  log_level           = nil,
  debounce_timeout    = 10,
  blacklist           = {},
  file_assets         = {},
  show_time           = true,
  global_timer        = false,

  -- Rich Presence text options
  editing_text        = "Editing %s",
  file_explorer_text  = "Browsing %s",
  git_commit_text     = "Committing changes",
  plugin_manager_text = "Managing plugins",
  reading_text        = "Reading %s",
  workspace_text      = "Working on %s",
  line_number_text    = "Line %s out of %s",
  terminal_text       = "Using Terminal",
})

-----------------------------------------------------------
-- 8. ADDITIONAL PLUGIN CONFIGURATIONS (OPTIONAL) ------------------------
-- Telescope key mappings:
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find Files" })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live Grep" })

-----------------------------------------------------------
-- 9. FINAL TOUCHES -------------------------------------------------------
-- Optionally, you can modularize further by splitting your configuration into separate Lua files
-- (for example, create lua/settings.lua, lua/keymaps.lua, etc. and then require them below).
--
-- require("settings")
-- require("keymaps")
-- require("plugins")

-----------------------------------------------------------
-- End of Neovim Configuration -------------------------------------------

