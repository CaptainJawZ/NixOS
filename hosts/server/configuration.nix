{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../base.nix
    ../../stylix.nix
  ];
  my = import ./toggles.nix;
  networking =
    let
      ports = [
        2049 # idk
      ];
    in
    {
      hostName = "server";
      firewall = {
        allowedTCPPorts = ports;
        allowedUDPPorts = ports;
      };
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
      settings.cores = 6;
      buildMachines = [
        {
          hostName = "workstation";
          system = "x86_64-linux";
          sshUser = "nixremote";
          maxJobs = 12;
          speedFactor = 1;
          supportedFeatures = featuresList;
        }
      ];
    };
  users = {
    groups.nixremote.gid = 555;
    users = {
      nixremote = {
        isNormalUser = true;
        createHome = true;
        group = "nixremote";
        home = "/var/nixremote/";
        # openssh.authorizedKeys.keyFiles = [
        #   ../../secrets/ssh/ed25519_nixworkstation.pub
        #   ../../secrets/ssh/ed25519_nixminiserver.pub
        # ];
      };
    };
  };
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
  };
}
