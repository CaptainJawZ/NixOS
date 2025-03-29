{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../base.nix
    ../../gnome.nix
    ../../stylix.nix
  ];
  my = import ./toggles.nix;
  home-manager.users.jawz.programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableBashIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
  };
  networking = {
    hostName = "workstation";
    firewall =
      let
        openPorts = [
          6674 # ns-usbloader
        ];
        openPortRanges = [
          {
            from = 1714; # kdeconnect
            to = 1764; # kdeconnect
          }
        ];
      in
      {
        allowedTCPPorts = openPorts;
        allowedUDPPorts = openPorts;
        allowedTCPPortRanges = openPortRanges;
        allowedUDPPortRanges = openPortRanges;
      };
  };
  nix.settings = {
    cores = 8;
    max-jobs = 8;
  };
  nixpkgs.config.permittedInsecurePackages = [ ];
  users = {
    groups.nixremote.gid = 555;
    users = {
      jawz.packages = builtins.attrValues {
        inherit (pkgs)
          distrobox # install packages from other os
          gocryptfs # encrypted filesystem! shhh!!!
          torrenttools # create torrent files from the terminal!
          # vcsi # video thumbnails for torrents, can I replace it with ^?
          ;
      };
      nixremote = {
        isNormalUser = true;
        createHome = true;
        group = "nixremote";
        home = "/var/nixremote/";
        # openssh.authorizedKeys.keyFiles = [
        #   ../../secrets/ssh/ed25519_nixserver.pub
        #   ../../secrets/ssh/ed25519_nixminiserver.pub
        # ];
      };
    };
  };
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = builtins.attrValues {
        inherit (pkgs.obs-studio-plugins)
          obs-vkcapture
          obs-vaapi
          obs-tuna
          looking-glass-obs
          input-overlay
          ;
      };
    };
  };
  # security.pki.certificateFiles = [
  #   ../../secrets/ssh/ca.pem
  # ];
  services = {
    flatpak.enable = true;
    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
    protonmail-bridge = {
      enable = true;
      path = [ pkgs.gnome-keyring ];
    };
    ollama = {
      enable = true;
      acceleration = "cuda";
    };
    open-webui.enable = true;
    resilio = {
      enable = true;
      useUpnp = true;
      enableWebUI = true;
      httpPass = "Uplifting-Proofs-Eggshell-Molecule-Wriggly-Janitor3-Padded-Oxidizing";
      deviceName = "Oversweet3834";
      httpLogin = "Oversweet3834";
      httpListenPort = 9876;
      httpListenAddr = "0.0.0.0";
      directoryRoot = "/resilio";
    };
  };
}
