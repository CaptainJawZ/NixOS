{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
      };
    };
    initrd = {
      secrets."/keyfile" = /etc/keyfile;
      luks.devices = {
        nvme = {
          device = "/dev/disk/by-uuid/af72f45c-cf7c-4e7d-8eab-2a95ab754921";
          keyFile = "/keyfile";
          preLVM = true;
        };
        # WHEN MIGRATING THE DISKS
        # remember to delete this keyfile
        # and replace it with the one on miniserver
        # or move the keyfile
        disk1 = {
          device = "/dev/disk/by-uuid/a9b0f346-7e38-40a6-baf6-3ad80cafc842";
          keyFile = "/keyfile";
          preLVM = true;
        };
        disk2 = {
          device = "/dev/disk/by-uuid/0ed12b83-4c56-4ba8-b4ea-75a9e927d771";
          keyFile = "/keyfile";
          preLVM = true;
        };
        disk3 = {
          device = "/dev/disk/by-uuid/8cd728f6-0d5b-4cea-8f7d-01aad11192c1";
          keyFile = "/keyfile";
          preLVM = true;
        };
        disk4 = {
          device = "/dev/disk/by-uuid/7fcac808-491f-4846-a4a9-a34cc77cb43d";
          keyFile = "/keyfile";
          preLVM = true;
        };
      };
    };
    kernelModules = [ "kvm-intel" ];
    kernel.sysctl."vm.swappiness" = 80;
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
  };
  fileSystems = {
    "/" = {
      device = "/dev/mapper/nvme";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "ssd"
        "compress=zstd:3"
        "x-systemd.device-timeout=0"
        "space_cache=v2"
        "commit=120"
        "datacow"
        "noatime"
      ];
    };
    "/home" = {
      device = "/dev/mapper/nvme";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "ssd"
        "compress=zstd:3"
        "x-systemd.device-timeout=0"
        "space_cache=v2"
        "commit=120"
        "datacow"
      ];
    };
    "/srv/pool" = {
      device = "/dev/disk/by-uuid/1e7cf787-e34d-4e3e-ac3c-0c07309dbd34";
      fsType = "btrfs";
      options = [
        "subvol=@data"
        "compress=zstd:3"
        "space_cache=v2"
        "commit=120"
        "datacow"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/c574cb53-dc40-46db-beff-0fe8a4787156";
      fsType = "ext4";
      options = [ "nofail" ];
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/CBE7-5DEB";
      fsType = "vfat";
    };
    "/var/lib/nextcloud/data" = {
      device = "/srv/pool/nextcloud";
      options = [ "bind" ];
      depends = [ "/srv/pool" ];
    };
    "/srv/jellyfin/media" = {
      device = "/srv/pool/multimedia/media";
      options = [
        "bind"
        "ro"
      ];
      depends = [ "/srv/pool" ];
    };
    "/export/pool" = {
      device = "/srv/pool";
      options = [ "bind" ];
      depends = [ "/srv/pool" ];
    };
    "/export/jawz" = {
      device = "/home/jawz";
      options = [ "bind" ];
      depends = [ "/srv/pool" ];
    };
  };
  services.nfs.server = {
    enable = true;
    exports = ''
      /export           workstation(rw,fsid=0,no_subtree_check)
                        miniserver(rw,fsid=0,no_subtree_check)
      /export/jawz      workstation(rw,nohide,insecure,no_subtree_check)
                        miniserver(rw,nohide,insecure,no_subtree_check)
      /export/pool      workstation(rw,nohide,insecure,no_subtree_check)
                        miniserver(rw,nohide,insecure,no_subtree_check)
    '';
  };
  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/cb0ad486-ebf8-4bfc-ad7c-96bdc68576ca";
      randomEncryption = {
        enable = true;
        cipher = "aes-xts-plain64";
        keySize = 512;
        sectorSize = 4096;
      };
    }
  ];
}
