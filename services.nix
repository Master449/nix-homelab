{ config, pkgs, ... }:
{
  # 80 for HTTP, 448 for HTTPS, 8096 for Jellyfin 3000 for Homepage
  networking.firewall.allowedTCPPorts = [ 80 443 8096 3000 ];
  
  services.httpd.enable = true;
  services.httpd.adminAddr = "admin@example.org";
  services.httpd.enablePHP = true;

  systemd.tmpfiles.rules = [
    "d /var/www/mysite.com"
    "f /var/www/mysite.com/index.php - - - - <?php phpinfo();"
  ];

  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
  
  services.jellyfin = {
    enable = true;
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "master4491@gmail.com";
  };

  services.nginx = {
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
    };
    recommendedGzipSettings = true;
  };

  virtualisation.docker.enable = true;
}
