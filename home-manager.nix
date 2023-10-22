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
        home.file.thingy = {
            enable = true;
            text = ''
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ .@$$$. ..  .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$..M$$``{  ...8$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$/.^$$$$$#` .. $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$. $$$$$$$@   . _..1$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$..$$$$$$$$Y. . $$$$$#$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  $$$$$$$$^.  .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$b.$$$$$$$.    . $$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$d $$$$$.         $$$$$$$$$$$$$$$$$$$$$$>..@$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Y)$$$............`$$$$$$$$$$$$$$$$$$$@..  $$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$M$$.            J$$$$$$$$$$$$$$$$$$ .  $$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$^  . ....... ..$$$$$$$^ ... ........ $$$$$
@` .                ..  ....|B$$$$$$$$$$$$$$$$$$$$$$$$$$$.   .`; .. .....           .$$$$$$$
$$.  .                                            .....  .                         X$$$$$$$$
$$$$b ..........................................................................  $$$$$$$$$$
$$$$$$$:                                                                        $$$$$$$$$$$$
$$$$$$$$$$$$$$$q .............................................................$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$                  .                                      $$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$z... ...   `M$$$$$$j ..  ........                . $$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"     .  .    $$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$^.l$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                        '';
                    executable = false;
                };
            home.file.config = {
                enable = true;
                target = ".config/sway/config";
                text = ''
                    exec swaymsg output Virtual-1 pos 0 0 res 1920 1080
		    default_border pixel 1
                    include /etc/sway/config
                    '';
            };
            home.file."foot.ini" = {
                enable = true;
                target = ".config/foot/foot.ini";
                text = ''
                    font=FiraCode Nerd Font:size=10

                    [cursor]
                    color=1A1826 D9E0EE

                    [colors]
                    foreground=D9E0EE
                    background=1E1D2F
                    regular0=6E6C7E  # black
                    regular1=F28FAD  # red
                    regular2=ABE9B3  # green
                    regular3=FAE3B0  # yellow
                    regular4=96CDFB  # blue
                    regular5=F5C2E7  # magenta
                    regular6=89DCEB  # cyan
                    regular7=D9E0EE  # white
                    bright0=988BA2   # bright black
                    bright1=F28FAD   # bright red
                    bright2=ABE9B3   # bright green
                    bright3=FAE3B0   # bright yellow
                    bright4=96CDFB   # bright blue
                    bright5=F5C2E7   # bright magenta
                    bright6=89DCEB   # bright cyan
                    bright7=D9E0EE   # bright white
                '';
            };
            programs.bash = { 
                enable = true;
                shellAliases = {
                    ll = "ls -l";
                    v = "nvim";
                    update = "sudo nixos-rebuild switch --show-trace";
                    edit_config = "sudo nvim /etc/nixos/configuration.nix";
                };
                initExtra = ''
                    cat ~/thingy
                    '';
            };
            programs.neovim = {
                enable = true;
                extraLuaConfig = ''
                    vim.g.mapleader = " "
                    vim.o.expandtab = true
                    vim.o.shiftwidth = 4
                    vim.o.number = true
                    vim.o.relativenumber = true

		    vim.g.netrw_banner=0

                    vim.keymap.set("t", "<esc>", "<C-\\><C-n>", {})
		    vim.keymap.set("n", "<Leader>t", "<cmd>belowright 100vs | term<Cr>", {})
		    vim.keymap.set("n", "<Leader>sb", "<cmd>bel 100vs | Telescope buffers<CR>", {})
                    vim.keymap.set("n", "<Leader>qf", "<cmd>copen<CR>", {})
                    --


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
                    config = ''
                        vim.cmd[[colorscheme catppuccin]]
                        vim.api.nvim_set_hl(0, 'LineNr', {fg = "#f5e0dc" } )
                        '';
                }
                { plugin = neorg;
                    type = "lua";
                    config = ''
                        require"neorg".setup {
                            load = {
                                ["core.defaults"] = {},
                                ["core.concealer"] = {}
                            }
                        }
                    '';
                }
                { plugin = nvim-treesitter;
                    type = "lua";
                    config = ''

                        require"nvim-treesitter.configs".setup {
                            ensure_installed = { "c", "cpp", "comment", "nix", "norg", "ocaml", "rust"},
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

                        lspconfig.ocamllsp.setup {}

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
            programs.tmux = {
                enable = true;
                clock24 = true;
                terminal = "tmux-256color";
                historyLimit = 1000;
                plugins = with pkgs; [
                    tmuxPlugins.catppuccin
                ];
                extraConfig = ''
                    set -sg escape-time 0
                '';
            };
        };
    }
