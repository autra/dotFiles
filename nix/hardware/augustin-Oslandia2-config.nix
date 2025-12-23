{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      systemd.enable = true;
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices."cryptroot".device = "/dev/disk/by-uuid/e732018a-166e-4a7b-a3af-214c6eb78acf";
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };
    # allows to test cross-compilation sometimes
    binfmt.emulatedSystems = [ "aarch64-linux" ];

  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.hostName = "augustin-Oslandia2";
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp193s0f3u2u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # f16 has a fingerprint reader
  # but it doesn't work very well (I need to periodically enroll my fingerprints so that it keeps working)
  # and probably creates subtle bugs (I cannot login with password until the fingerprint has been attempted, I need to click on "unlock" in some cases on the lock screen...)
  services.fprintd.enable = false;
  # and it can use fwupd, cf https://wiki.nixos.org/wiki/Fwupd
  services.fwupd.enable = true;

  # F16 tends to wake up on its own when in my bag, probably because of small signal on the keyboard or the touchpad
  # simple solution: only wake-up on power button press
  services.udev.extraRules = ''
ACTION=="add", SUBSYSTEM=="acpi", DRIVERS=="button", ATTRS{hid}=="PNP0C0D", ATTR{power/wakeup}="disabled"
ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
ACTION=="add", SUBSYSTEM=="i2c", DRIVERS=="i2c_hid_acpi", ATTRS{name}=="PIXA3854:00", ATTR{power/wakeup}="disabled"
'';

  # specific stylix config for this machine
  stylix.targets.grub.enable = false;

  # a test user
  users.users.test = {
    shell = pkgs.zsh;
    isNormalUser = true;
    # extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "cdrom"];
    initialPassword = "test";
  };
}
