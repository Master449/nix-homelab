{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./samba.nix
      ./services.nix
      ./firewall.nix
      ./systemd.nix
      ./ups.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "chronos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.0.127" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.nixPath = [
    "/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/david/nix-homelab/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users = {
    david = {
      isNormalUser = true;
      description = "david";
      extraGroups = [ "wheel" "admin" "networkmanager" "samba" "docker" "libvirtd" "libvirt" "kvm" ];
      shell = pkgs.zsh;
      packages = with pkgs; [];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    ffmpeg-full
    jellyfin-ffmpeg
    htop
    git
    nvtopPackages.nvidia
    fastfetch
    kitty
    curl
    bc
    figlet
    fortune
    libvirt
    lm_sensors
    nut
    pciutils
    qemu
    temurin-jre-bin-21
    usbutils
    virt-manager
    nodejs_22
    nodePackages_latest.npm
    glances
  ];

  programs.zsh.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Specific for NVIDIA proprietary drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    opengl.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaPersistenced = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
  # -----------------------------------------

  system.stateVersion = "24.05"; # Did you read the comment?

}
