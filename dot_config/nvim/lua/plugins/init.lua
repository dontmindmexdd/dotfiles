local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function is_visible(cmp)
  return cmp.core.view:visible() or vim.fn.pumvisible() == 1
end

local lspconfig = require("lspconfig")
local luasnip = require("luasnip")
local cmp = require("cmp")

if vim.g.vscode then
  return {}
end

return {
  -- sync terminal background color
  { "typicode/bg.nvim", lazy = false, config = function() end },

  -- COLORSCHEMES
  {
    "doums/darcula",
  },
  {
    "NTBBloodbath/doom-one.nvim",
    config = function()
      -- Add color to cursor
      vim.g.doom_one_cursor_coloring = true
      -- Set :terminal colors
      vim.g.doom_one_terminal_colors = true
      -- Enable italic comments
      vim.g.doom_one_italic_comments = true
      -- Enable TS support
      vim.g.doom_one_enable_treesitter = true
      -- Color whole diagnostic text or only underline
      vim.g.doom_one_diagnostics_text_color = true
      -- Enable transparent background
      vim.g.doom_one_transparent_background = false

      -- Pumblend transparency
      vim.g.doom_one_pumblend_enable = false
      vim.g.doom_one_pumblend_transparency = 20

      -- Plugins integration
      vim.g.doom_one_plugin_neorg = true
      vim.g.doom_one_plugin_barbar = false
      vim.g.doom_one_plugin_telescope = true
      vim.g.doom_one_plugin_neogit = true
      vim.g.doom_one_plugin_nvim_tree = true
      vim.g.doom_one_plugin_dashboard = true
      vim.g.doom_one_plugin_startify = true
      vim.g.doom_one_plugin_whichkey = true
      vim.g.doom_one_plugin_indent_blankline = true
      vim.g.doom_one_plugin_vim_illuminate = true
      vim.g.doom_one_plugin_lspsaga = false
    end,
  },
  {
    "echasnovski/mini.base16",
    lazy = false,
    version = false,
  },
  { "Mofiqul/vscode.nvim" },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        keywordStyle = { italic = false, bold = false },
        statementStyle = { bold = false, italic = false },
      })
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
    opts = {
      italic = {
        strings = false,
        emphasis = false,
        comments = true,
        operators = false,
        folds = false,
      },
      contrast = "hard",
    },
  },
  { "EdenEast/nightfox.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {},
  },

  -- INDENTATION

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        char = "┊",
        highlight = "Whitespace",
      },
    },
  },

  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "│",
    },
  },

  -- STATUSLINE

  {
    "echasnovski/mini.statusline",
    enabled = not vim.g.vscode,
    version = false,
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },

  -- use git ancestor for eslint

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          root_dir = lspconfig.util.find_git_ancestor or vim.loop.cwd,
          settings = {
            workingDirectory = { mode = "location" },
          },
        },
      },
      inlay_hints = { enabled = false },
    },
  },

  -- SCROLLBAR

  { "petertriho/nvim-scrollbar", opts = {} },

  -- NEOTREE misc

  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>o",
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd("p")
          else
            vim.cmd.Neotree("focus")
          end
        end,
        desc = "Focus Neotree",
      },
    },
    opts = {
      filesystem = {
        filtered_items = { hide_hidden = true, hide_dotfiles = false },
      },
      window = {
        position = "right",
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
    },
    opts = {
      experimental = {
        ghost_text = false,
      },
      window = {
        completion = cmp.config.window.bordered({
          col_offset = -2,
          side_padding = 0,
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        }),
        documentation = cmp.config.window.bordered({
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        }),
      },
      -- sane mappings
      mapping = {
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-U>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-D>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-Y>"] = cmp.config.disable,
        ["<C-E>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
        ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if is_visible(cmp) then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if is_visible(cmp) then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      -- pop up autocomplete menu customization
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = " " .. (strings[1] or "") .. " "
          kind.menu = "    (" .. (strings[2] or "") .. ")"

          return kind
        end,
      },
    },
  },

  {
    "echasnovski/mini.basics",
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        float = {
          border = "single",
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        ["vim.lsp.util.stylize_markdown"] = true,
      },
      presets = {
        lsp_doc_border = true,
      },
    },
  },
}
