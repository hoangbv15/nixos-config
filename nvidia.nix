{ config, pkgs, ... }:

{
  # Display drivers
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    # Enable modifying clocks for overclocking/undervolting
    deviceSection = ''
      Option "Coolbits" "28"
    '';
  };

  # Grab Nvidia version 465
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  # Allow nvidia-smi to run sudo with no password to set power limit at start up
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ { command = "/run/current-system/sw/bin/nvidia-smi"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  # Undervolt script for 3090
  systemd.user.services.undervolt = {
    script = ''
      /run/wrappers/bin/sudo /run/current-system/sw/bin/nvidia-smi -pm 1
      /run/wrappers/bin/sudo /run/current-system/sw/bin/nvidia-smi -pl 200
      /run/wrappers/bin/sudo /run/current-system/sw/bin/nvidia-smi -lgc 210,1775
      /run/current-system/sw/bin/nvidia-settings -a "[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=75"
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
