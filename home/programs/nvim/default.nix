{ inputs, pkgs, config, lib, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
#    colorschemes = {
#      nord = {
#        enable = true;
#        settings = {
#          borders = true;
#          contrast = true;
#        };
#      };
#    };
    clipboard.register = "unnamedplus";
    globals = {
      mapleader = " ";
      VM_maps = {
        "Select Cursor Down" = "<C-j>";
        "Select Cursor Up" = "<C-k>";
      };
    };
    opts = {
      undofile = true;
      smartindent = true;
      autoindent = true;
      tabstop = 2;
      shiftwidth = 2;
      shiftround = true;
      expandtab = true;
      scrolloff = 3;
      mouse = "a";
      incsearch = true;
      ignorecase = true;
      ttimeoutlen = 5;
      hidden = true;
      shortmess = "atI";
      wrap = false;
      backup = false;
      writebackup = false;
      errorbells = false;
      swapfile = false;
      showmode = false;
      laststatus = 3;
      pumheight = 6;
      splitright = true;
      splitbelow = true;
      completeopt = "menuone,noselect";
      showmatch = true;
      smartcase = true;
      hlsearch = true;
      number = true;
      relativenumber = true;
      termguicolors = true;
      #set wildmode=longest,list
      #set cc=80
      #filetype plugin indent on
      #syntax on
      #filetype plugin on
      cursorline = true;
      #set ttyfast
    };
    plugins = {
      render-markdown = {
        enable = true;
      };
      lualine = {
        enable = true;
        settings.sections = {
          lualine_x = [
            "encoding" "fileformat" "filetype" "overseer"
          ];
          lualine_c = [
          {
            __unkeyed-1 = "filename";
            file_status = true;
            newfile_status = false;
            path = 1;
            shorting_target = 40;
          }
          ];
        };
      };
      lazygit.enable = true;
      treesitter = {
        enable = true;
      };
      bufferline.enable = true;
      telescope = {
        enable = true;
        extensions.live-grep-args = {
          enable = true;
          settings =  {
            mappings = {
              i = {
                "<C-i>" = {
                  __raw = "require(\"telescope-live-grep-args.actions\").quote_prompt({ postfix = \" --iglob \" })";
                };
                "<C-t>" = {
                  __raw = "require(\"telescope-live-grep-args.actions\").quote_prompt({ postfix = \" -t \" })";
                };
                "<C-k>" = {
                  __raw = "require(\"telescope-live-grep-args.actions\").quote_prompt()";
                };
                "<C-space>" = {
                  __raw = "require(\"telescope.actions\").to_fuzzy_refine";
                };
              };
            };
          };
        };
        settings = {
          defaults = {
            mappings = {
              i = {
                "<esc>" = {
                  __raw = "require('telescope.actions').close";
                };
              };
            };
          };
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp = {
        enable = true;
        settings = {
          sources = [{ name = "nvim_lsp"; }];
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = true }),

                -- Navigate between completion items
                ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
                ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),

                -- `Enter` key to confirm completion

                -- Ctrl+Space to trigger completion menu
                ['<C-Space>'] = cmp.mapping.complete(),

                ['<C-e>'] = cmp.mapping.abort(),

                -- Scroll up and down in the completion documentation
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
              })
            '';
          };

        };
      };
      lsp = {
        enable = true;
       # servers = let 
       #   activateLsp = {
       #     enable = true;
       #     autostart = true;
       #     # important for mono repo to detect root
       #     # rootDir = "require('lspconfig.util').root_pattern('.git')";
       #     rootDir = "require('lspconfig.util').find_package_json_ancestor";
       #   };
       # in {
       #   tailwindcss = activateLsp;
       #   ts_ls = activateLsp;
       # };
        keymaps = {
          diagnostic = {
            gn = "goto_next";
            gp = "goto_prev";
            gD = "open_float";
          };
          lspBuf = {
            gh = "hover";
            gd = "definition";
            gI = "implementation";
            # lower-case gr will be mapped to telescope which gives better overview, less functionality
            gR = "references";
            go = "type_definition";
            "<F2>" = "rename";
            ga = "code_action";
          };
        };
      };
      nvim-tree = {
        enable = true;
        actions.openFile.quitOnOpen = true;
        disableNetrw = true;
        hijackCursor = true;
        syncRootWithCwd = true;
        sortBy = "case_sensitive";
        extraOptions = {
          filters = {
            dotfiles = false;
          };
          view = {
            width = 60;
          };
        };
      };
      web-devicons.enable = true;
      nvim-autopairs.enable = true;
      ts-autotag = {
        enable = true;
        settings = {
          opts = {
            enable_close = true;
            enable_rename = true;
            enable_close_on_slash = false;
          };
        };
      };
      luasnip.enable = true;
      comment.enable = true;
      nvim-surround.enable = true;
      yazi.enable = true;
      nix.enable = true;
      nvim-bqf = {
        enable = true;
        autoEnable = true;
      };
      startify = {
        enable = true;
        settings = {
          session_persistence = true;
          change_to_vcs_root = true;
          bookmarks = [
            { f = "/home/tobias/nixos-config/flake.nix"; }
            { v = "/home/tobias/nixos-config/home/programs/nvim/default.nix"; }
          ];
        };
      };
      overseer = {
        enable = true;
        settings = {
          task_list = {
            direction = "left";
            bindings = {
              "<CR>" = "RunAction";
              "q" = "Close";
              "p" = "TogglePreview";
            };
          };
        };
        luaConfig.post = ''
          require('overseer').register_template({
            name = "Generate GraphQL Schema",
            builder = function(params)
              -- This must return an overseer.TaskDefinition
              return {
                -- cmd is the only required field
                cmd = {'nix-shell'},
                -- additional arguments for the cmd
                args = {"-p", "yarn", "--run", "yarn graphql:generate"},
                -- the name of the task (defaults to the cmd of the task)
                name = "GraphQL generate",
                -- set the working directory for the task
                cwd = "/home/tobias/git/pocketbitcoin/pocketapp",
                -- additional environment variables
                env = {},
                -- the list of components or component aliases to add to the task
                components = {
                  { "on_complete_notify", system = "always" },
                  { "open_output", on_complete = "failure", on_start = "never", direction = "float", focus = true },
                  "default"
                },
                -- arbitrary table of data for your own personal use
                metadata = {},
              }
            end,
            condition = {
              dir = "/home/tobias/git/pocketbitcoin/pocketapp",
            },
          })
        '';
      };
      dressing = {
        enable = true;
      };
      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 3;
          trim_scope = "inner";
        };
      };
      gitblame = {
        enable = true;
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-easymotion
      vim-visual-multi
      plenary-nvim
    ];
    keymaps = [
      { mode = "n"; key = "<C-f>"; options.silent = true; action = "<cmd>NvimTreeFindFileToggle<CR>"; }
      { mode = "n"; key = "<C-t>"; options.silent = true; action = "<cmd>OverseerToggle<CR>"; }
      { mode = "n"; key = "<leader>t"; options.silent = true; action = "<cmd>OverseerRun<CR>"; }
      { mode = "n"; key = "<C-p>"; options.silent = true; action = "<cmd>Telescope git_files<CR>"; }
      { mode = "n"; key = "<leader>b"; options.silent = true; action = "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<CR>"; }
      { mode = "n"; key = "<leader>o"; options.silent = true; action = "<cmd>Telescope oldfiles<CR>"; }
      { mode = "n"; key = "gr"; options.silent = true; action = "<cmd>Telescope lsp_references<CR>"; }
      { mode = "n"; key = "<leader>Q"; options.silent = true; action = "<cmd>BufferLineCloseOther<CR>"; }
      { mode = "n"; key = "<leader>g"; options.silent = true; action = "<cmd>LazyGit<CR>"; }
      { mode = "n"; key = "<leader>y"; options.silent = true; action = "<cmd>Yazi<CR>"; }
      { mode = "n"; key = "<leader>q"; options.silent = true; action = "<cmd>bd<CR>"; }
      { mode = "n"; key = "<leader>w"; options.silent = true; action = "<cmd>w<CR>"; }
      { mode = "n"; key = "<leader>W"; options.silent = true; action = "<cmd>wa<CR>"; }
      { mode = "n"; key = "<C-h>"; options.silent = true; action = "<cmd>bp!<CR>"; }
      { mode = "n"; key = "<C-l>"; options.silent = true; action = "<cmd>bn!<CR>"; }
      { mode = "n"; key = "gs"; options.silent = true; action = "<cmd>Telescope lsp_document_symbols ignore_symbols=variable,property<CR>"; }
      { mode = "n"; key = "gS"; options.silent = true; action = "<cmd>Telescope lsp_workspace_symbols<CR>"; }
      { mode = "n"; key = "<leader>h"; options.silent = true; action = "<cmd>wincmd h<CR>"; }
      { mode = "n"; key = "<leader>l"; options.silent = true; action = "<cmd>wincmd l<CR>"; }
      { mode = "n"; key = "<leader>j"; options.silent = true; action = "<cmd>wincmd j<CR>"; }
      { mode = "n"; key = "<leader>k"; options.silent = true; action = "<cmd>wincmd k<CR>"; }
      { mode = "n"; key = "<leader>i"; options.silent = true; action = "i<Space><Left>"; }
      # { mode = "n"; key = "<C-S-f>"; options.silent = true; action = "<cmd>Telescope live_grep<CR>"; }
      { mode = "n"; key = "♠"; options.silent = true; action = "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({ additional_args = { '--fixed-strings' }})<CR>"; }
      { mode = "n"; key = "<C-A-o>"; options.silent = true; action = "<cmd>Startify<CR>"; }
      { mode = "n"; key = "♡"; options.silent = true; action = "<C-6>"; }

      { mode = "i"; key = "<C-BS>"; options.silent = true; action = "<C-w>"; }
      { mode = "i"; key = "^H"; options.silent = true; action = "<C-w>"; }
      { mode = "i"; key = "jj"; options.silent = true; action = "<Esc>"; }

      { mode = "v"; key = "<C-A-j>"; options.silent = true; action = ":m '>+1<CR>gv=gv"; }
      { mode = "v"; key = "<C-A-k>"; options.silent = true; action = ":m '<-2<CR>gv=gv"; }

      { mode = "n"; key = "<C-A-j>"; options.silent = true; action = "<cmd>m .+1<CR>=="; }
      { mode = "n"; key = "<C-A-k>"; options.silent = true; action = "<cmd>m .-2<CR>=="; }
    ];
    extraConfigLua = ''
      -- dirty fix to disable diagnostig on easymotion
      -- https://github.com/easymotion/vim-easymotion/issues/402
      vim.api.nvim_create_autocmd("User", {pattern = {"EasyMotionPromptBegin"}, callback = function() vim.diagnostic.disable() end})
      function check_easymotion()
        local timer = vim.loop.new_timer()
        timer:start(500, 0, vim.schedule_wrap(function()
          -- vim.notify("check_easymotion")
          if vim.fn["EasyMotion#is_active"]() == 0 then
            vim.diagnostic.enable()
            vim.g.waiting_for_easy_motion = false
          else
            check_easymotion()
          end
        end))
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "EasyMotionPromptEnd",
        callback = function()
          if vim.g.waiting_for_easy_motion then return end
          vim.g.waiting_for_easy_motion = true
          check_easymotion()
        end
      })

      -- exit buffers qith q
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'qf', 'help' },
        callback = function()
          vim.keymap.set('n', 'q', '<cmd>bd<cr>', { silent = true, buffer = true })
        end,
      })
    '';
  };
}
