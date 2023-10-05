

{ config, pkgs, ... }:

{
    imports = [ <home-manager/nixos> ];


    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;

    home-manager.users.wd = {
        home.stateVersion = "23.05";
        home.packages = [
            pkgs.firefox
            pkgs.tree 
        ];
        programs.bash = { 
            enable = true;
            shellAliases = {
                ll = "ls -l";
                v = "nvim";
		update = "sudo nixos-rebuild switch --show-trace";
                edit_config = "sudo nvim /etc/nixos/configuration.nix";
            };
        };
        programs.neovim = {
            enable = true;
	    extraLuaConfig = ''
            vim.g.mapleader = " "
            vim.o.expandtab = true
            vim.o.shiftwidth = 4
            vim.o.number = true
            vim.o.relativenumber = true

            vim.api.nvim_create_user_command('CCompile', '!gcc % -o dev -Wall -Wextra', {})
            vim.api.nvim_create_user_command('CppCompile', '!g++ % -o dev -Wall -Wextra', {})
            
            vim.keymap.set("n", "<leader>cc", "<cmd>CCompile<cr>", {})
            vim.keymap.set("n", "<leader>cf", "<cmd>CppCompile<cr>", {})

            -- Defines a read-write directory for treesitters in nvim's cache dir
            local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
            vim.fn.mkdir(parser_install_dir, "p")
            -- Prevents reinstall of treesitter plugins every boot
            vim.opt.runtimepath:append(parser_install_dir)

            '';
            plugins = with pkgs.vimPlugins; [
                { plugin = telescope-nvim;
                  type = "lua";
                  config = ''
                  local builtin = require("telescope.builtin")
                  vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
                  vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
                  '';
                }
                { plugin = catppuccin-nvim;
                  type = "lua";
                  config = "vim.cmd[[colorscheme catppuccin]]";
                }
                { plugin = nvim-treesitter;
                  type = "lua";
                  config = ''

                  require"nvim-treesitter.configs".setup {
                        ensure_installed = { "c", "cpp", "nix", "ocaml", "zig" },
                        highlight = {
                                enable = true;
                        },
			parser_install_dir = parser_install_dir
                  }
                  '';
                }
                { plugin = nvim-lspconfig;
                  type = "lua";
                  config = ''
                      local lspconfig = require("lspconfig")

                      lspconfig.ocamllsp.setup{}
                      lspconfig.rust_analyzer.setup{}

                      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
                      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
                      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
                      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

                      vim.api.nvim_create_autocmd("LspAttach", {
                              group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                              callback = function(ev)
                              -- Enable completion triggered by <c-x><c-o>
                              vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                              -- Buffer local mappings.
                              -- See `:help vim.lsp.*` for documentation on any of the below functions
                              local opts = { buffer = ev.buf }
                              vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                              vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                              vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                              vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
                              vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
                              vim.keymap.set("n", "<space>wl", function()
                                      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                                      end, opts)
                              vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
                              vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
                              vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
                              vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                              end,
                      })
                      '';
               }
            ];
        };
    };
}
