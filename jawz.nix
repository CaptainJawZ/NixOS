{ config, ... }:
let
  inherit (config.networking) hostName;
in
{
  # sops.secrets =
  #   let
  #     baseDir = ".ssh/ed25519";
  #     keyConfig = file: {
  #       sopsFile = ./secrets/keys.yaml;
  #       owner = config.users.users.jawz.name;
  #       inherit (config.users.users.jawz) group;
  #       path = "/home/jawz/${file}";
  #     };
  #   in
  #   {
  #     jawz-password.neededForUsers = true;
  #     # "private_keys/age" = keyConfig "${baseDir}_age";
  #     # "public_keys/age" = keyConfig "${baseDir}_age.pub";
  #     # "private_keys/${hostName}" = keyConfig "${baseDir}_${hostName}";
  #     # "git_private_keys/${hostName}" = keyConfig "${baseDir}_git";
  #     # "syncthing_keys/${hostName}" = keyConfig ".config/syncthing/key.pem";
  #     # "syncthing_certs/${hostName}" = keyConfig ".config/syncthing/cert.pem";
  #   };
  services.syncthing = {
    enable = false;
    user = "jawz";
    group = "users";
    overrideDevices = true;
    overrideFolders = true;
    # key = config.sops.secrets."syncthing_keys/${hostName}".path;
    # cert = config.sops.secrets."syncthing_certs/${hostName}".path;
    settings = {
      devices = {
        server.id = "000000000000000000000000000000000000000000000000000000000000000";
        miniserver.id = "000000000000000000000000000000000000000000000000000000000000000";
      };
      folders = {
        cache = {
          path = "/home/jawz/Downloads/cache/";
          ignorePerms = false;
          devices = [ "galaxy" ];
        };
        gdl = {
          path = "/home/jawz/.config/jawz/";
          ignorePerms = false;
          devices = [
            "server"
            "miniserver"
            "workstation"
          ];
        };
        librewolf = {
          path = "/home/jawz/.librewolf/";
          ignorePerms = false;
          copyOwnershipFromParent = true;
          type = if config.networking.hostName == "workstation" then "sendonly" else "receiveonly";
          devices = [
            "server"
            "miniserver"
            "workstation"
          ];
        };
      };
    };
  };
  users.users.jawz = {
    uid = 1000;
    linger = true;
    isNormalUser = true;
    initialPassword = "supersecret";
    # hashedPasswordFile = config.sops.secrets.jawz-password.path;
    extraGroups = [
      "wheel"
      "networkmanager"
      "scanner"
      "lp"
      "piracy"
      "kavita"
      "video"
      "docker"
      "libvirt"
      "rslsync"
      "plugdev"
      "bluetooth"
    ];
    openssh.authorizedKeys.keyFiles = [
      # ./secrets/ssh/ed25519_deacero.pub
      # ./secrets/ssh/ed25519_workstation.pub
      # ./secrets/ssh/ed25519_server.pub
      # ./secrets/ssh/ed25519_miniserver.pub
      # ./secrets/ssh/ed25519_galaxy.pub
      # ./secrets/ssh/ed25519_phone.pub
    ];
  };
}
