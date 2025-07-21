-- init.lua - Streamlined Neovim Configuration

-- Bootstrap vim-plug if not installed
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Core functionality plugins
Plug('neoclide/coc.nvim', {branch = 'release'})
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')  -- Keeping as requested
Plug('nvim-treesitter/nvim-treesitter', {['do'] = 'TSUpdate'})
Plug('nvim-treesitter/nvim-treesitter-textobjects')
Plug('kylechui/nvim-surround')
Plug('folke/which-key.nvim')

-- AI assistance
-- Plug('github/copilot.vim')

-- Color scheme (keeping one)
Plug('folke/tokyonight.nvim')

vim.call('plug#end')

-- Basic Vim settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable netrw (for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- General settings
vim.opt.encoding = 'utf-8'
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = 'yes'
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.colorcolumn = '80'
-- Color scheme and appearance
vim.opt.background = 'light'
vim.cmd('colorscheme tokyonight-day')

-- Highlight settings
vim.cmd('highlight ColorColumn ctermbg=0 guibg=#e1e2e7')
vim.cmd('highlight Folded guibg=none guifg=#8c8fa1')

-- Statusline colors to match theme
vim.cmd('highlight StatusLine guibg=#c4c8da guifg=#3760bf')
vim.cmd('highlight StatusLineNC guibg=#e9e9ed guifg=#6172b0')

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.filetype = 'plugin'

-- Folding
vim.opt.foldmethod = 'manual'
vim.opt.foldcolumn = '2'
vim.opt.foldlevel = 99

-- Enhanced file finding (native fuzzy finding)
vim.opt.path:append('**')
vim.opt.wildmenu = true
vim.opt.wildmode = {'longest:full', 'full'}
vim.opt.wildoptions = 'pum'

-- Statusline (native, enhanced)
vim.opt.laststatus = 2
vim.opt.statusline = table.concat({
  '%f',                     -- filename
  '%m',                     -- modified flag
  '%r',                     -- readonly flag
  '%{coc#status()}',        -- coc status
  '%{get(b:,"coc_current_function","")}', -- current function
  '%=',                     -- switch to right side
  '%y',                     -- filetype
  '[%{&fileencoding}]',     -- encoding
  '[%l/%L]',                -- line number/total
  '[%p%%]'                  -- percentage through file
})

-- Key mappings
local keymap = vim.keymap.set

-- Clear search highlight
keymap('n', '<Esc>', '<Esc>:noh<CR>', {silent = true})

-- Window navigation
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- Native file finding (replacing telescope)
keymap('n', '<leader><leader>', ':find *')
keymap('n', '<leader>fg', ':grep ')
keymap('n', '<leader>fb', ':buffer *<Tab>')
keymap('n', '<leader>fh', ':help *<Tab>')

-- Search and replace
keymap('n', '<leader>s', ':%s/')
keymap('v', '<leader>s', ':s/')

-- CoC configuration
vim.opt.pumheight = 15

-- CoC key mappings
local function check_backspace()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Tab completion
keymap('i', '<TAB>', function()
  if vim.fn['coc#pum#visible']() ~= 0 then
    return vim.fn['coc#pum#next'](1)
  elseif check_backspace() then
    return '<TAB>'
  else
    return vim.fn['coc#refresh']()
  end
end, {expr = true, silent = true})

keymap('i', '<S-TAB>', function()
  if vim.fn['coc#pum#visible']() ~= 0 then
    return vim.fn['coc#pum#prev'](1)
  else
    return '<C-h>'
  end
end, {expr = true})

keymap('i', '<S-CR>', '<Esc>o')

-- CoC trigger completion
keymap('i', '<c-space>', 'coc#refresh()', {expr = true, silent = true})

-- CoC navigation
keymap('n', '<leader>e', '<Plug>(coc-diagnostic-prev)')
keymap('n', '<leader>E', '<Plug>(coc-diagnostic-next)')
keymap('n', 'gd', '<Plug>(coc-definition)zz', {silent = true})
keymap('n', 'gy', '<Plug>(coc-type-definition)zz', {silent = true})
keymap('n', 'gi', '<Plug>(coc-implementation)zz', {silent = true})
keymap('n', 'gr', '<Plug>(coc-references)zz', {silent = true})

-- CoC documentation
keymap('n', 'K', function()
  if vim.fn['CocAction']('hasProvider', 'hover') then
    vim.fn['CocActionAsync']('doHover')
  else
    vim.api.nvim_feedkeys('K', 'in', false)
  end
end, {silent = true})

-- CoC actions
keymap('n', '<leader>rn', '<Plug>(coc-rename)')
keymap({'x', 'n'}, '<leader>f', '<Plug>(coc-format-selected)')
keymap({'x', 'n'}, '<leader>a', '<Plug>(coc-codeaction-selected)')
keymap('n', '<leader>ac', '<Plug>(coc-codeaction-cursor)')
keymap('n', '<leader>as', '<Plug>(coc-codeaction-source)')
keymap('n', '<leader>qf', '<Plug>(coc-fix-current)')
keymap({'x', 'n'}, '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', {silent = true})
keymap('n', '<leader>re', '<Plug>(coc-codeaction-refactor)', {silent = true})

-- CoC text objects
keymap({'x', 'o'}, 'if', '<Plug>(coc-funcobj-i)')
keymap({'x', 'o'}, 'af', '<Plug>(coc-funcobj-a)')
keymap({'x', 'o'}, 'ic', '<Plug>(coc-classobj-i)')
keymap({'x', 'o'}, 'ac', '<Plug>(coc-classobj-a)')

-- CoC scroll float windows
keymap('n', '<C-f>', function()
  if vim.fn['coc#float#has_scroll']() ~= 0 then
    return vim.fn['coc#float#scroll'](1)
  else
    return '<C-f>'
  end
end, {expr = true, silent = true, nowait = true})

keymap('n', '<C-b>', function()
  if vim.fn['coc#float#has_scroll']() ~= 0 then
    return vim.fn['coc#float#scroll'](0)
  else
    return '<C-b>'
  end
end, {expr = true, silent = true, nowait = true})

-- CoC Inlay Hints disable
local function toggle_coc_inlay_hints()
  -- Execute the CoC command to toggle inlay hints for current buffer
  vim.cmd('CocCommand document.toggleInlayHint')
end

-- Create the keymap
vim.keymap.set('n', '<leader>h', toggle_coc_inlay_hints, {
  desc = 'Toggle CoC inlay hints',
  silent = true
})

-- CoC range select
keymap({'n', 'x'}, '<C-s>', '<Plug>(coc-range-select)', {silent = true})

-- CoC commands
vim.api.nvim_create_user_command('Format', function()
  vim.fn['CocActionAsync']('format')
end, {})

vim.api.nvim_create_user_command('Fold', function(opts)
  vim.fn['CocAction']('fold', opts.fargs)
end, {nargs = '?'})

vim.api.nvim_create_user_command('OR', function()
  vim.fn['CocActionAsync']('runCommand', 'editor.action.organizeImport')
end, {})

-- Auto commands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- CoC highlight
local coc_group = augroup('CocGroup', {clear = true})
autocmd('CursorHold', {
  group = coc_group,
  callback = function()
    vim.fn['CocActionAsync']('highlight')
  end,
})

-- Format expression and signature help
autocmd('FileType', {
  pattern = {'typescript', 'json'},
  callback = function()
    vim.opt_local.formatexpr = 'CocAction("formatSelected")'
  end
})

autocmd('User', {
  pattern = 'CocJumpPlaceholder',
  callback = function()
    vim.fn['CocActionAsync']('showSignatureHelp')
  end
})

-- YAML specific settings
autocmd('FileType', {
  pattern = 'yaml',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end
})

-- Plugin configurations

-- nvim-tree setup
require('nvim-tree').setup({
  sort = {
    sorter = 'case_sensitive',
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- Treesitter setup
require('nvim-treesitter.configs').setup({
  ensure_installed = {'c', 'cpp', 'python', 'markdown', 'lua', 'cmake', 'rust'},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = {'markdown'},
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
      },
      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@function.outer'] = 'V'
      },
      include_surrounding_whitespace = true,
    },
  },
})

-- nvim-surround setup
require('nvim-surround').setup({})

-- Copilot settings
vim.g.copilot_filetypes = {
  markdown = false,
}


-- which-key setup
require('which-key').setup({
  -- You can leave this empty for default settings
  -- or add your preferred configuration
})

-- Optional: Add a keymap to show buffer-local keymaps
vim.keymap.set('n', '<leader>?', function()
  require('which-key').show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })
