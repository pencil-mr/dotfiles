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
            home.file.config = {
                enable = true;
                target = ".config/sway/config";
                text = ''
set $mod Mod4
set $left h
set $down j
set $up k
set $right l
set $term foot
set $menu dmenu_path | dmenu | xargs swaymsg exec --

bindsym $mod+Return exec $term
bindsym $mod+Shift+q kill
bindsym $mod+d exec $menu
floating_modifier $mod normal
bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'

bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right

bindsym $mod+Shift+$left move left
bindsym $mod+Shift+$down move down
bindsym $mod+Shift+$up move up
bindsym $mod+Shift+$right move right

bindsym $mod+1 workspace number 1
bindsym $mod+2 workspace number 2
bindsym $mod+3 workspace number 3
bindsym $mod+4 workspace number 4
bindsym $mod+5 workspace number 5
bindsym $mod+6 workspace number 6
bindsym $mod+7 workspace number 7
bindsym $mod+8 workspace number 8
bindsym $mod+9 workspace number 9
bindsym $mod+0 workspace number 10

bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
bindsym $mod+Shift+5 move container to workspace number 5
bindsym $mod+Shift+6 move container to workspace number 6
bindsym $mod+Shift+7 move container to workspace number 7
bindsym $mod+Shift+8 move container to workspace number 8
bindsym $mod+Shift+9 move container to workspace number 9
bindsym $mod+Shift+0 move container to workspace number 10

bindsym $mod+b splith
bindsym $mod+v splitv

bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

bindsym $mod+f fullscreen

bindsym $mod+Shift+space floating toggle
bindsym $mod+space focus mode_toggle

bindsym $mod+a focus parent

bindsym $mod+Shift+minus move scratchpad
bindsym $mod+minus scratchpad show

mode "resize" {
    bindsym $left resize shrink width 10px
        bindsym $down resize grow height 10px
        bindsym $up resize shrink height 10px
        bindsym $right resize grow width 10px

        bindsym Return mode "default"
        bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

default_border pixel 1
output * bg /run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill
output Virtual-1 pos 0 0 res 1920 1080

bar {
    position top

    status_command while date +'%Y-%m-%d %I:%M:%S %p'; do sleep 1; done

    colors {
        statusline #ffffff
            background #323232
            inactive_workspace #32323200 #32323200 #5c5c5c
        }
}
include /etc/sway/config.d/*
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
            };
            programs.fzf = {
                enable = true;
            };
            programs.neovim = {
                enable = true;
                extraLuaConfig = ''
vim.g.mapleader = " "
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = "number"

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
                        '';
                }
                { plugin = nvim-treesitter;
                    type = "lua";
                    config = ''
                        require"nvim-treesitter.configs".setup {
                            ensure_installed = { "c", "cpp", "comment","go", "nix", "ocaml", "rust"},
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
                        lspconfig.gopls.setup {}

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
