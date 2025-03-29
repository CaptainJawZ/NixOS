{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../base.nix
    ../../stylix.nix
  ];
  my = import ./toggles.nix;
  networking = {
    hostName = "miniserver";
    firewall = {
      allowedTCPPorts = [ 2049 ];
      allowedUDPPorts = [ 2049 ];
    };
  };
  nix = {
    settings = {
      cores = 3;
      max-jobs = 8;
    };
    buildMachines =
      let
        buildMachine = hostName: maxJobs: speedFactor: {
          inherit hostName maxJobs speedFactor;
          system = "x86_64-linux";
          sshUser = "nixremote";
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "big-parallel"
            "kvm"
            "gccarch-znver3"
            "gccarch-skylake"
            "gccarch-alderlake"
          ];
        };
      in
      [
        (buildMachine "workstation" 16 40)
        (buildMachine "server" 16 17)
      ];
  };
  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];
  users = {
    groups.nixremote.gid = 555;
    users.nixremote = {
      isNormalUser = true;
      createHome = true;
      group = "nixremote";
      home = "/var/nixremote/";
      # openssh.authorizedKeys.keyFiles = [
      #   ../../secrets/ssh/ed25519_nixworkstation.pub
      #   ../../secrets/ssh/ed25519_nixserver.pub
      # ];
    };
  };
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
  };
}
