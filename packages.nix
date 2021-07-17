{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # System
    vim
    wget
    git
    kate

    # General
    google-chrome
    skype
    ferdi

    # Games
    lutris
    steam
    xdelta # For GI-on-Linux

    # Work
    virt-manager
  ];

  # etc/hosts
  networking.extraHosts =
  ''
    # Genshin logging servers (do not remove!)
    0.0.0.0 log-upload-os.mihoyo.com
    0.0.0.0 overseauspider.yuanshen.com
    # Genshin logging servers (do not remove!)
    0.0.0.0 log-upload-os.mihoyo.com
    0.0.0.0 overseauspider.yuanshen.com
  '';
  
  # Configurations needed for some packages
  programs = {
    steam.enable = true;
    dconf.enable = true;
  };
  
  # Enable libvirtd for virt-manager
  virtualisation.libvirtd.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
