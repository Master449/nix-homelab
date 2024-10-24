{ config, pkgs, ... }:
{
  services = {
    
    # xserver
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    
    # SSH
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
      settings.DenyUsers = [ "test" "media" "time-machine" ];
      settings.LoginGraceTime = 0;
      settings.PrintMotd = true;
    };
    
    # Tailscale VPN
    tailscale = {
      enable = true;
    };

    # Jellyfin Media Server
    jellyfin = {
      enable = true;
    };

    # Broadcasts Time Machine Availability
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    
    # Reverse Proxy
    nginx = {
      enable = true;
      virtualHosts = {
        "homepage.home".locations."/".proxyPass = "http://192.168.0.109:3000";
        "jellyfin.home".locations."/".proxyPass = "http://192.168.0.109:8096";
        "torrents.home".locations."/".proxyPass = "http://192.168.0.109:8080";
        "uptime.home".locations."/".proxyPass = "http://192.168.0.109:7000";
        "bluemap.home".locations."/".proxyPass = "http://192.168.0.109:8100";
        "mc.home".locations."/".proxyPass = "http://192.168.0.109:25565";
        "speedtest.home".locations."/".proxyPass = "http://192.168.0.109:4000";
      };
      recommendedGzipSettings = true;
    };

  };
  
  # Docker
  virtualisation.docker = {
    enable = true;
    listenOptions = [ "2375" ];
  };
}
