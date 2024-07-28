{ config, pkgs, ... }:
{
  # 80 for HTTP, 448 for HTTPS, 8096 for Jellyfin 3000 for Homepage
  
#  services.httpd.enable = true;
#  services.httpd.adminAddr = "admin@example.org";
#  services.httpd.enablePHP = true;

#  systemd.tmpfiles.rules = [
#    "d /var/www/mysite.com"
#    "f /var/www/mysite.com/index.php - - - - <?php phpinfo();"
#  ];

#  environment.systemPackages = with pkgs; [ qbittorrent-nox ];

  users.users.nginx.extraGroups = [ "acme" ];

  # Used by nginx, might SSL later down the line
  security.acme = {
    acceptTerms = true;
    defaults.email = "master4491@gmail.com";
    certs."jellyfin-flowers-1942130.duckdns.org" = {
      dnsProvider = "duckdns";
      webroot = null;
      group = "nginx";
      environmentFile = "/home/david/.secrets";
    };
  };

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
    
    # Mullvad  VPN
    mullvad-vpn.enable = true;
    resolved.enable = true;

    # No major use yet
    #mysql = {
    #  enable = true;
    #  package = pkgs.mariadb;
    #};
  
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
        "jellyfin.homelab.local" = {
          serverName = "jellyfin.homelab.local";
          
          locations = {
            "/" = {
              proxyPass = "http://localhost:8096";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
        "jellyfin-flowers-1942130.duckdns.org" = {
          useACMEHost = "jellyfin-flowers-1942130.duckdns.org";
          forceSSL = true; 
          locations = {
            "/" = {
              proxyPass = "http://localhost:8096";
            };
          };
        };
        "homepage.homelab.local" = {
          serverName = "homepage.homelab.local";

          locations = {
              "/" = {
                proxyPass = "http://localhost:3000";
                extraConfig = ''
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Proto $scheme;
                '';
              };
          };
        };
        "uptime.homelab.local" = {
          serverName = "uptime.homelab.local";
          
          locations = {
            "/" = {
              proxyPass = "http://localhost:7000";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
        "speedtest.homelab.local" = {
          serverName = "speedtest.homelab.local";

          locations = {
              "/" = {
                proxyPass = "http://localhost:4000";
                extraConfig = ''
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Proto $scheme;
                '';
              };
          };
        };
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
