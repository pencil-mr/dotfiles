{ config, pkgs, ... }:
{
    environment.systemPackages = [
    pkgs.rust-analyzer
    pkgs.rustc
    pkgs.cargo
    ];
    environment.variables = rec { 
	    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };
}
