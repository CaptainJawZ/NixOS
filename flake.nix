{
  description = "JawZ NixOS flake setup";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs?ref=nixos-unstable-small";
    nixpkgs11.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    ucodenix.url = "github:e-tho/ucodenix";
    doom-emacs = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };
    jawz-scripts = {
      url = "github:CaptainJawZ/jawz-scripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixtendo-switch = {
      url = "github:nyawox/nixtendo-switch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      mkpkgs =
        repo:
        import repo {
          inherit system;
          config.allowUnfree = true;
        };
      createConfig =
        name: local-nixpkgs:
        let
          lib = local-nixpkgs.lib // inputs.home-manager.lib;
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            {
              nixpkgs.overlays = [
                (import ./overlay.nix { inherit mkpkgs inputs; })
                inputs.doom-emacs.overlays.default
              ];
            }
            ./hosts/${name}/configuration.nix
            inputs.nur.modules.nixos.default
            inputs.sops-nix.nixosModules.sops
            inputs.stylix.nixosModules.stylix
            inputs.nixtendo-switch.nixosModules.nixtendo-switch
          ];
        };
    in
    {
      nixosConfigurations = {
        workstation = createConfig "workstation" inputs.nixpkgs;
        miniserver = createConfig "miniserver" inputs.nixpkgs-small;
        server = createConfig "server" inputs.nixpkgs-small;
      };
    };
}
