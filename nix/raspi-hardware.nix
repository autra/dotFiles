{ lib, pkgs, ...}:

{
  boot = {
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkForce pkgs.linuxPackages_5_4;
    kernelParams = [
      "dwc_otg.lpm_enable=0"
      # "console=ttyAMA0,115200"
      "console=tty0,115200n8"
      "rootwait"
      "elevator=deadline"
    ];
    # loader = {
    #   grub.enable = lib.mkDefault false;
    #   generationsDir.enable = lib.mkDefault false;
    #   raspberryPi = {
    #     enable = lib.mkDefault true;
    #     version = lib.mkDefault 1;
    #   };
    # };
  };
    nixpkgs.overlays = [
      (final: super: {
        makeModulesClosure = x:
          super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];

  nixpkgs.config.platform = lib.systems.platforms.raspberrypi;

  # cpufrequtils doesn't build on ARM
  powerManagement.enable = lib.mkDefault false;

  services.openssh.enable = lib.mkDefault true;
}
