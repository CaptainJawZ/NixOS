{
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.vpl-gpu-rt ];
    };
  };
  boot = {
    kernelModules = [ "kvm-intel" ];
    kernel.sysctl."vm.swappiness" = 80;
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
    extraModulePackages = [ ];
    initrd = {
      secrets."/keyfile" = /etc/keyfile;
      luks.devices.nvme = {
        device = "/dev/disk/by-uuid/30fd7d86-9bed-42a6-8a4e-a2ddb0031233";
        keyFile = "keyfile";
        preLVM = true;
      };
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      kernelModules = [ "kvm-intel" ];
    };
  };
  fileSystems =
    let
      nfsMount = server: nfsDisk: {
        device = "${server}:/${nfsDisk}";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=600"
        ];
      };
    in
    {
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
      "/boot" = {
        device = "/dev/disk/by-uuid/bf0aeb95-94cc-4377-b6e4-1dbb4958b334";
        fsType = "ext4";
      };
      "/boot/efi" = {
        device = "/dev/disk/by-uuid/0C7B-4D4C";
        fsType = "vfat";
      };
      "/var/lib/nextcloud/data" = {
        device = "/srv/pool/nextcloud";
        options = [ "bind" ];
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
      "/srv/server/pool" = nfsMount "server" "pool" // { };
      "/srv/server/jawz" = nfsMount "server" "jawz" // { };
    };
  services.nfs.server = {
    enable = true;
    exports = ''
      /export           workstation(rw,fsid=0,no_subtree_check)
      /export/jawz      workstation(rw,nohide,insecure,no_subtree_check)
      /export/pool      workstation(rw,nohide,insecure,no_subtree_check)
    '';
  };
  swapDevices = [
    {
      device = "/dev/nvme0n1p3";
      randomEncryption = {
        enable = true;
        cipher = "aes-xts-plain64";
        keySize = 512;
        sectorSize = 4096;
      };
    }
  ];
}
