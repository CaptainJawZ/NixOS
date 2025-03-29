{
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./jawz.nix
    ./modules/modules.nix
  ];
  system.stateVersion = "24.11";
  # sops = {
  #   defaultSopsFormat = "yaml";
  #   defaultSopsFile = ./secrets/secrets.yaml;
  #   age = {
  #     sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  #     keyFile = "/var/lib/sops-nix/key.txt";
  #     generateKey = true;
  #   };
  # };
  home-manager = {
    backupFileExtension = "hbckup";
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    users.jawz = import ./home-manager.nix;
  };
  time = {
    timeZone = "America/Mexico_City";
    hardwareClockInLocalTime = true;
  };
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    extraLocaleSettings = {
      LC_MONETARY = "es_MX.UTF-8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  security = {
    polkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
      }
    ];
  };
  users = {
    mutableUsers = false;
    groups = {
      users.gid = 100;
      piracy.gid = 985;
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "aspnetcore-runtime-wrapped-6.0.36"
      "aspnetcore-runtime-6.0.36"
      "dotnet-runtime-6.0.36"
      "dotnet-sdk-wrapped-6.0.428"
      "dotnet-sdk-6.0.428"
    ];
  };
  nix =
    let
      featuresList = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
        "gccarch-znver3"
        "gccarch-skylake"
        "gccarch-alderlake"
      ];
    in
    {
      distributedBuilds = true;
      optimise.automatic = true;
      settings = {
        use-xdg-base-directories = true;
        auto-optimise-store = true;
        trusted-users = [ "nixremote" ];
        system-features = featuresList;
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        substituters = [
          "https://nix-gaming.cachix.org"
          "https://nixpkgs-python.cachix.org"
          "https://devenv.cachix.org"
          "https://cuda-maintainers.cachix.org"
          "https://ai.cachix.org"
          "https://cache.lix.systems"
          "https://cosmic.cachix.org"
        ];
        trusted-public-keys = [
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
          "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
          "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
          "cache.servidos.lat:om+P81I+m8Hawcvt1ydaSNVxGNnR0POJ8Wz+QVjQ3hA="
        ];
      };
    };
  documentation.enable = false;
  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        wget
        # sops
        ;
    };
    variables =
      let
        XDG_DATA_HOME = "\${HOME}/.local/share";
        XDG_CONFIG_HOME = "\${HOME}/.config";
        XDG_CACHE_HOME = "\${HOME}/.cache";
      in
      {
        # PATH
        inherit XDG_DATA_HOME XDG_CONFIG_HOME XDG_CACHE_HOME;
        XDG_BIN_HOME = "\${HOME}/.local/bin";
        XDG_STATE_HOME = "\${HOME}/.local/state";

        # DEV PATH
        CARGO_HOME = "${XDG_DATA_HOME}/cargo";
        GEM_HOME = "${XDG_DATA_HOME}/ruby/gems";
        GEM_PATH = "${XDG_DATA_HOME}/ruby/gems";
        GEM_SPEC_CACHE = "${XDG_DATA_HOME}/ruby/specs";
        GOPATH = "${XDG_DATA_HOME}/go";
        PSQL_HISTORY = "${XDG_DATA_HOME}/psql_history";
        REDISCLI_HISTFILE = "${XDG_DATA_HOME}/redis/rediscli_history";
        WINEPREFIX = "${XDG_DATA_HOME}/wine";

        # OPTIONS
        ELECTRUMDIR = "${XDG_DATA_HOME}/electrum";
        WGETRC = "${XDG_CONFIG_HOME}/wgetrc";
        XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
        "_JAVA_OPTIONS" = "-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java";

        # NVIDIA
        CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";

        # WAYLAND
        WLR_NO_HARDWARE_CURSORS = 1;
        NIXOS_OZONE_WL = 1;

        PATH = [ "\${HOME}/.local/bin" ];
      };
  };
  programs = {
    nh = {
      enable = true;
      flake = "/home/jawz/Development/NixOS";
      clean = {
        enable = true;
        extraArgs = "--keep-since 3d";
      };
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  services = {
    smartd.enable = true;
    fstrim.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    openssh = {
      enable = true;
      openFirewall = true;
      startWhenNeeded = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
        KbdInteractiveAuthentication = false;
      };
    };
  };
  fonts.fontconfig.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
