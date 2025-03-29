{
  modulesPath,
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.ucodenix.nixosModules.default
  ];
  services = {
    udev.extraRules = lib.mkIf config.my.apps.gaming.enable ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0cf3", ATTRS{idProduct}=="3005", TAG+="uaccess"
    '';
    ucodenix = {
      enable = true;
      cpuModelId = "00A50F00";
    };
  };
  hardware = {
    bluetooth = {
      enable = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
  boot = {
    plymouth.enable = true;
    consoleLogLevel = 0;
    loader.timeout = 0;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "preempt=full"
    ];
    kernelPackages = pkgs.linuxPackages_zen;
    kernel.sysctl = {
      "vm.swappiness" = 80;
      "net.ipv4.tcp_mtu_probing" = 1;
      "kernel.sched_cfsbandwidth_slice_us" = lib.mkDefault 3000;
      "net.ipv4.tcp_fin_timeout" = lib.mkDefault 5;
      "vm.max_map_count" = lib.mkDefault 2147483642;
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        enableCryptodisk = true;
      };
    };
    initrd = {
      verbose = false;
      secrets."/keyfile" = /etc/keyfile;
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      luks.devices.nvme = {
        device = "/dev/disk/by-uuid/e9618e85-a631-4374-b2a4-22c376d6e41b";
        keyFile = "/keyfile";
        preLVM = true;
      };
      luks.devices.hd = {
        device = "/dev/disk/by-uuid/59ac5e2e-cf50-4a23-94c8-d9f2fa13c805";
        keyFile = "/keyfile";
        preLVM = true;
      };
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
      btrfsMount = subvol: {
        device = "/dev/mapper/nvme";
        fsType = "btrfs";
        options = [
          "subvol=${subvol}"
          "ssd"
          "compress=lzo"
          "x-systemd.device-timeout=0"
          "space_cache=v2"
          "commit=120"
          "datacow"
        ] ++ (if subvol == "nixos" then [ "noatime" ] else [ ]);
      };
    in
    {
      "/" = btrfsMount "nixos";
      "/home" = btrfsMount "home";
      "/srv/games" = btrfsMount "games";
      "/srv/miniserver/pool" = nfsMount "miniserver" "pool";
      "/srv/miniserver/jawz" = nfsMount "miniserver" "jawz";
      "/srv/server/pool" = nfsMount "server" "pool";
      "/srv/server/jawz" = nfsMount "server" "jawz";
      "/boot" = {
        device = "/dev/disk/by-uuid/ac6d349a-96b9-499e-9009-229efd7743a5";
        fsType = "ext4";
      };
      "/boot/efi" = {
        device = "/dev/disk/by-uuid/B05D-B5FB";
        fsType = "vfat";
      };
    };
  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/c1bd22d7-e62c-440a-88d1-6464be1aa1b0";
      randomEncryption = {
        enable = true;
        cipher = "aes-xts-plain64";
        keySize = 512;
        sectorSize = 4096;
      };
    }
  ];
}
