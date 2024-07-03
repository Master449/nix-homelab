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
 
  # Used by nginx, might SSL later down the line
  security.acme = {
    acceptTerms = true;
    defaults.email = "master4491@gmail.com";
  };

  services = {
    
    # Transmission BitTorrent Client
#    transmission = {
#      enable = true;
#      settings = {
#        bind-address-ipv4 = "0.0.0.0";
#        download-dir = "/mnt/WD1/torrent";
#        encryption = 1;
#        peer-port = 6881;
#        peer-port-random-high = 65535;
#        peer-port-random-low = 49152;
#        peer-port-random-on-start = false;
#        rpc-authentication-required = true;
#        rpc-bind-address = "0.0.0.0";
#        rpc-enabled = true;
#        rpc-host-whitelist-enabled = true;
#        rpc-port = 9091;
#        rpc-whitelist = "127.0.0.1,::1";
#        rpc-username = "david";
#        rpc-password = "Some12hold";
#      };
#    };
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
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  
    # Jellyfin Media Server
    jellyfin = {
      enable = true;
    };

    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 7000;
          domain = "grafana.homelab.local";
        };
      };
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
        "grafana.homelab.local" = {
          serverName = "grafana.homelab.local";
          
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
#        "torrents.homelab.local" = {
#          serverName = "torrents.homelab.local";
#
#          locations = {
#              "/" = {
#                proxyPass = "http://localhost:9091";
#                extraConfig = ''
#                  proxy_set_header Host $host;
#                  proxy_set_header X-Real-IP $remote_addr;
#                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#                  proxy_set_header X-Forwarded-Proto $scheme;
#                '';
#              };
#          };
#        };
      };
      recommendedGzipSettings = true;
    };
  };
  
  # Docker
  virtualisation.docker.enable = true;
}
